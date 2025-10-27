import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
//3.1 Importar libreria para timer
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true; // Estado inicial: contraseña oculta
  //5.1 Se agrega la variable de de cargando
  bool _isLoading = false;
  //Cerebro de la logica de las animaciones
  StateMachineController? controller;
  //SMI: State Machine Input
  SMIBool? isChecking; // Activa el modo "chismoso"
  SMIBool? isHandsUp; // Se tapa los ojos
  SMITrigger? trigSuccess; //Se emociona
  SMITrigger? trigFail; //Se pone triste
  //2.1Variable para recorrido de la mirada
  SMINumber? numLook; // 0..80 a tu asset

  //1.1)FocusNode
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //3.2 Timer para detener la mirada al dejar de teclear
  Timer? _typingDebounce;

  //4.1 Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  //4.2 Erorres para pintar (mostrar en la UI)
  String? emailError;
  String? passError;

  // 4.3 Validadores
  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String pass) {
    // mínimo 8, una mayúscula, una minúscula, un dígito y un especial
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  //4.4 Acción al boton
  void _onLogin() async {
    //5.2 Evitar que se presiene el boton de login
    if (_isLoading) return;
    // 5.3 Activar estado de carga y actualizar UI
    setState(() {
      _isLoading = true;
    });
    // trim (recortar) sirve para eliminar espacios en un campo de texto
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    // Recalcular errores dinámicamente (solo el primero aplicable)
    String? eError;
    if (email.isNotEmpty && !isValidEmail(email)) {
      eError = 'Email inválido';
    }

    String? pError;
    if (pass.isNotEmpty && pass.length < 8) {
      pError = 'Debe tener al menos 8 caracteres';
    } else if (!RegExp(r'[A-Z]').hasMatch(pass)) {
      pError = 'Debe tener una mayúscula';
    } else if (!RegExp(r'[a-z]').hasMatch(pass)) {
      pError = 'Debe tener una minúscula';
    } else if (!RegExp(r'\d').hasMatch(pass)) {
      pError = 'Debe incluir un número';
    } else if (!RegExp(r'[^A-Za-z0-9]').hasMatch(pass)) {
      pError = 'Debe incluir un carácter especial';
    }

    //4.5Para avisar que hubo un cambio
    setState(() {
      emailError = eError;
      passError = pError;
    });

    //4.6 Cerrar el teclado y bajar las manos
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0; //Mirada neutarl
    // 5.4 Esperar hasta el siguiente frame completo antes de disparar el trigger
    // Esto garantiza que Rive procese la animación de bajar las manos antes del trigger
    await Future<void>.delayed(
      const Duration(milliseconds: 600),
    ); // Le puse esa cantidad porque es el tiempo necesario para la animación de bajar las manos

    // 5.5 Simular tiempo de carga (~1 segundo)
    await Future.delayed(const Duration(seconds: 1));

    //4.7 Activar triggers
    if (eError == null && pError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
    // 5.6 Desactivar el estado de carga al finalizar
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //1.2)Listeners
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        isHandsUp?.change(false); //Manos abajo en email
        //2.2 Mirada neutral al enfocar email
        numLook?.value = 50.0;
        isHandsUp?.change(false);
      }
    });
    passFocus.addListener(() {
      //Manos arriba en password
      isHandsUp?.change(passFocus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Para obtener el tamaño de la pantalla del dispositivo
    final Size miTam = MediaQuery.of(context).size;
    return Scaffold(
      //Evita nudge o camaras frontales para moviles
      body: SafeArea(
        //Margen interior
        child: Padding(
          //Eje x/horizontal/derecha izquierda
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: miTam.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: const ["Login Machine"],
                  //Al iniciarse
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    //Verificar que inicio bien
                    if (controller == null) return;
                    artboard.addController(controller!);

                    isChecking = controller!.findSMI("isChecking");
                    isHandsUp = controller!.findSMI("isHandsUp");
                    trigSuccess = controller!.findSMI("trigSuccess");
                    trigFail = controller!.findSMI("trigFail");
                    //2.3 Enlazar variable con la animacion
                    numLook = controller!.findSMI("numLook");
                  }, // Clamp
                ),
              ),
              //Espacio entre el oso y el email
              const SizedBox(height: 10),

              //Campo de texto de email
              TextField(
                //1.3) Asignas el focusNode al TextFile
                focusNode: emailFocus,
                //4.8 Enlazar controller a texfile
                controller: emailCtrl,
                //2.4 Implementado numLook
                onChanged: (value) {
                  //Estoy escribiendo
                  isChecking?.change(true);
                  // 5.8 Validación dinámica de email mientras se escribe
                  String? eError;
                  if (value.isNotEmpty && !isValidEmail(value)) {
                    eError = 'Email inválido';
                  }

                  // Se borra el error si el campo esta vacío
                  if (value.isEmpty) {
                    eError = null;
                  }

                  setState(() {
                    emailError = eError;
                  });

                  //Ajuste de limites de 0 a 100
                  //80 es una medida de calibración
                  final look = (value.length / 80 * 100.0).clamp(0.0, 100.0);
                  numLook?.value = look;

                  //3.3 Si vuelve a teclaer , reinicia el contador
                  _typingDebounce?.cancel(); //Cancela cualquier timer existente
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) {
                      return; //Si la pantalla se cierra
                    }
                    //Mirada neutra
                    isChecking?.change(false);
                  });

                  if (isChecking == null) return;
                  //Activa el modo chismoso
                  isChecking!.change(true);
                },
                //para que aparezca @ en moviles
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //4.9 Mostrar el texto del error
                  errorText: emailError,
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              //Campo de contraseña
              TextField(
                focusNode: passFocus,
                //4.8 Enlazar controller a texfile
                controller: passCtrl,
                onChanged: (value) {
                  // 5.9 Validación dinámica de password mientras se escribe
                  String? pError;
                  if (value.isNotEmpty && value.length < 8) {
                    pError = 'Debe tener al menos 8 caracteres';
                  } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    pError = 'Debe tener una mayúscula';
                  } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                    pError = 'Debe tener una minúscula';
                  } else if (!RegExp(r'\d').hasMatch(value)) {
                    pError = 'Debe incluir un número';
                  } else if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                    pError = 'Debe incluir un carácter especial';
                  }

                  // Se borra el error si el campo esta vacío
                  if (value.isEmpty) {
                    pError = null;
                  }

                  setState(() {
                    passError = pError;
                  });

                  if (isHandsUp == null) return;
                  //Activa el modo privado
                  isHandsUp!.change(true);
                },
                obscureText: _isObscure, // ahora depende del estado
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //4.9 Mostrar el texto del error
                  errorText: passError,
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // cambia entre oculto/visible
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //Texto de "Olvide contraseña"
              SizedBox(
                width: miTam.width,
                child: const Text(
                  "Forgot your password?",
                  //Alinear a la derecha
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              //Boton de login
              const SizedBox(height: 10),
              //Boton estilo android
              MaterialButton(
                minWidth: miTam.width,
                height: 50,
                color: const Color.fromARGB(255, 179, 16, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                //4.10 LLamar funcion _onLogin
                // 5.7 Deshabilitar el botón mientras carga
                onPressed: _isLoading ? null : _onLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: miTam.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Liberacion de recursos/ limpieza de focos
  @override
  void dispose() {
    //4.11 Limpieza de los controllers
    emailCtrl.dispose();
    passCtrl.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
