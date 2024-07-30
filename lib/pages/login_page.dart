import 'package:coffeeapp/components/text_field.dart';
import 'package:coffeeapp/pages/forgot-pswd.dart';
import 'package:coffeeapp/pages/home_page.dart';
import 'package:coffeeapp/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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
                      "Login",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset(
                  "lib/images/logo2.png",
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
                  auth.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }).catchError((error) {
                    // Show toast message for incorrect username/password
                    Fluttertoast.showToast(
                      msg: "Incorrect username or password",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: 200,
                  decoration: BoxDecoration(color: Colors.brown[700], borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(onPressed: (()=>Get.to(Forgot())), child: Text("Forgot Password ?")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account ? Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
  // void clearCart() {
  //   FirebaseFirestore.instance.collection('cart').get().then((snapshot) {
  //     for (DocumentSnapshot doc in snapshot.docs) {
  //       doc.reference.delete();
  //     }
  //   });
  // }
}
