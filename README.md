# :teddy_bear: Animated Login Screen — Flutter + Rive

A visually engaging animated login screen built with Flutter and Rive.
This project features a cute character that reacts to user actions:
- :eyes: Looks around while typing your email
- :see_no_evil: Covers its eyes when typing the password
- :smile:Smiles when login is successful
- :cry: Gets sad when login fails

## :star: Brief Description of Functionalities
- :closed_lock_with_key: Email and password validation using regular expressions

- :brain: Interactive animations powered by Rive State Machine

- :timer_clock: Typing timer (debounce) to manage eye movement timing

- :eye_speech_bubble: Toggle password visibility

- :iphone: Responsive UI design compatible with multiple screen sizes

- :paintbrush: Memory-safe resource management with proper controller disposal
## :art: What is Rive?
Rive is a real-time interactive animation tool that allows developers and designers to create animated graphics and connect them directly to app logic.
It enables you to control animations through state machines, making them respond to user input, gestures, or app states in real time.

## :gear: What is a State Machine?
A State Machine in Rive defines how an animation behaves based on input variables.
In this project, it controls:
- isChecking → when the character looks at the text
- isHandsUp → when it covers its eyes
- trigSuccess → when the login is successful
- trigFail → when the login failsnumLook → how the eyes move while typing

This system allows smooth and dynamic animation transitions according to the app’s logic.

## :toolbox: Technologies Used
- :bird: Flutter
- :blue_heart: Dart
- :film_strip: Rive for interactive animation
- :timer_clock: Timer for typing delay
- :file_folder: Material Design Widgets
  
## :open_file_folder: Project Structure
```bash
lib/
│
├── main.dart                # Punto de entrada principal
├── screens/
│   └── login_screen.dart    # Pantalla principal del login con animaciones
└── assets/
    └── animated_login_character.riv        # Archivo de animación del personaje (Rive)
pubsec.yaml                  # Dependencies and Flutter configuration
```

---
## :film_projector: 
![Demo de la aplicación](assets/Demo.gif)
---
## :blue_book: Course Information
- :school: Intituto tecnológico de Mérida
- :man_technologist: Rodrigo Fidel Gaxiola Sosa
- :man_student: Luis Adrián Cauich Dzul

## :globe_with_meridians: Credits
- Rive animation used in this project: https://rive.app/marketplace/3645-7621-remix-of-login-machine/
