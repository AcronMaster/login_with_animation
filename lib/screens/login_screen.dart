import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

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

  @override
  Widget build(BuildContext context) {
    //Para obtener el tamaño de la pantalla del disp.
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
                  },
                ),
              ),
              //Espacio entre el oso y el email
              const SizedBox(height: 10),

              //Campo de texto de email
              TextField(
                onChanged: (value) {
                  if (isHandsUp != null) {
                    //No tapas los ojos al escribir email
                    isHandsUp!.change(false);
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
                onChanged: (value) {
                  if (isChecking != null) {
                    //No actividar el modo chismoso
                    isChecking!.change(false);
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
                color: Colors.red,
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
}
