import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:melanoma_detection/services/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: "876775281331-nsaq0m468suvb50o75jeogb7rd0kkfck.apps.googleusercontent.com"),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: LoginButton(
              icon: FontAwesomeIcons.userNinja,
                text: 'Continue as Guest',
                loginMethod: AuthService().anonLogin,
                color: Colors.deepPurple,
            ),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: action == AuthAction.signIn
              ? const Text('Welcome to EasyMelanoScan, please sign in!')
              : const Text('Welcome to EasyMelanoScan, please sign up!'),
        );
      },
      footerBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'Having an account in this app allows the app to consistently track previously uploaded photos and results.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
      // sideBuilder: (context, shrinkOffset) {
      //   return Padding(
      //     padding: const EdgeInsets.all(20),
      //     child: AspectRatio(
      //       aspectRatio: 1,
      //       child: LoginButton(
      //         icon: FontAwesomeIcons.userNinja,
      //           text: 'Continue as Guest',
      //           loginMethod: AuthService().anonLogin,
      //           color: Colors.deepPurple,
      //       ),
      //     ),
      //   );
      // },
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}