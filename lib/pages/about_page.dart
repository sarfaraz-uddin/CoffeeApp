import 'package:coffeeapp/const.dart';
import 'package:flutter/material.dart';

/*

ABOUT PAGE

Just a simple about page describing the app

*/

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[900],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'About',
          style: TextStyle(color: Colors.grey.shade900),
        ),
      ),
      body: const Center(child: Text('This app was designed and coded by ISR Group')),
    );
  }
}
