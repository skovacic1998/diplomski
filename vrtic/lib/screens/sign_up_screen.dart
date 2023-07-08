// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vrtic/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                reusableTextFieldLoginAndSignup("Enter username", Icons.person_outline, false,
                    _userNameTextEditingController, null, null),
                const SizedBox(
                  height: 20,
                ),
                reusableTextFieldLoginAndSignup("Enter email", Icons.email_outlined, false,
                    _emailTextEditingController, null, null),
                const SizedBox(
                  height: 20,
                ),
                reusableTextFieldLoginAndSignup("Enter password", Icons.lock_outline, true,
                    _passwordTextEditingController, null, null),
                signInSignUpButton(
                  context,
                  false,
                  () async {
                    try {
                      final userCredentials = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextEditingController.text,
                              password: _passwordTextEditingController.text);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredentials.user!.uid)
                          .set({
                            'username': _userNameTextEditingController.text,
                            'email': _emailTextEditingController.text,
                            'isParent': 1,
                            'children': [],
                          });
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      SnackBar snackBar = SnackBar(
                        backgroundColor: hexStringToColor("D37E1A"),
                        content: Text(
                          e.code,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      );
                      return ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
