import 'package:coffeeapp/components/text_field.dart';
import 'package:coffeeapp/pages/home_page.dart';
import 'package:coffeeapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignuppageState();
}

class _SignuppageState extends State<SignUpPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Center(
                    child: Text(
                      "Sign Up Page",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset(
                  "lib/images/latte.png",
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NormalTextField(
                  controller: email,
                  text: 'email',
                  iconData: Icons.email,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NormalTextField(
                  controller: password,
                  text: 'password',
                  iconData: Icons.lock,
                ),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.createUserWithEmailAndPassword(email: email.text, password: password.text).then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: 200,
                  decoration: BoxDecoration(color: Colors.brown[700], borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginpage(),
                        ));
                  },
                  child: const Text("Already have an account ? Login ")),
            ],
          ),
        ),
      ),
    );
  }
}
