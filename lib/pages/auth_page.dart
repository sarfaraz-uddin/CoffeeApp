import 'package:coffeeapp/pages/home_page.dart';
import 'package:coffeeapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return const HomePage();
    } else {
      return const Loginpage();
    }
  }
}
