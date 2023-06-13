import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vrtic/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(email: _emailTextEditingController.text, password: _passwordTextEditingController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("f4791f"),
              hexStringToColor("659999"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                reusableTextField("Enter username", Icons.person_outline, false,
                    _userNameTextEditingController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.email_outlined, false,
                    _emailTextEditingController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outline, true,
                    _passwordTextEditingController),
                signInSignUpButton(context, false, () {
                  createUserWithEmailAndPassword().then((value) {
                    print("Created new account");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                  }).onError((error, stackTrace){
                    print("Error ${error.toString()}");
                  });
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );*/
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
