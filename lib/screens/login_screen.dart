import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true; // Estado inicial: contraseña oculta

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
                child: const RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                ),
              ),
              //Espacio entre el oso y el email
              const SizedBox(height: 10),

              //Campo de texto de email
              TextField(
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
            ],
          ),
        ),
      ),
    );
  }
}
