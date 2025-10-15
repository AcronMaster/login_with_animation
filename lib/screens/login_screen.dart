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

  //3.2 Timer para detner la mirada al dejar de teclear
  Timer? _typingDebounce;

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
                onChanged: (value) {
                  if (isHandsUp != null) {
                    //2.4 Implementado numLook
                    //Estoy escribiendo
                    isChecking!.change(true);

                    //Ajuste de limites de 0 a 100
                    //80 es una medida de calibración
                    final look = (value.length / 80 * 100.0).clamp(0.0, 100.0);
                    numLook?.value = look;

                    //3.3 Si vuelve a teclaer , reinicia el contador
                    _typingDebounce
                        ?.cancel(); //Cancela cualquier timer existente
                    _typingDebounce = Timer(const Duration(seconds: 3), () {
                      if (!mounted) {
                        return; //Si la pantalla se cierra
                      }
                      //Mirada neutra
                      isChecking?.change(false);
                    });
                  }
                  if (isChecking == null) return;
                  //Activa el modo chismoso
                  isChecking!.change(true);
                },
                //para que aparezca @ en moviles
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
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
                onChanged: (value) {
                  if (isChecking != null) {
                    //No actividar el modo chismoso
                    //isChecking!.change(false);
                  }
                  if (isHandsUp == null) return;
                  //Activa el modo privado
                  isHandsUp!.change(true);
                },
                obscureText: _isObscure, // ahora depende del estado
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
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
                onPressed: () {
                  //TO DO:
                },
                child: Text("Login", style: TextStyle(color: Colors.white)),
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
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
