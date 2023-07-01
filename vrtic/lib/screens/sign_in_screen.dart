// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/user.dart' as user_model;
import 'package:vrtic/providers/user_provider.dart';
import 'package:vrtic/screens/home_screen.dart';
import 'package:vrtic/screens/sign_up_screen.dart';
import 'package:vrtic/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../reusable_widgets/reusable_widget.dart';

final userFromAuth = StateProvider<User?>((ref) => null);

class SignInScreen extends ConsumerWidget {
  const SignInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController passwordTextController =
        TextEditingController();
    final TextEditingController emailTextController = TextEditingController();

    late user_model.User? user;

    return Scaffold(
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
                logoWidget("assets/images/logo-no-background.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextFieldLoginAndSignup("Enter email", Icons.person_outline, false,
                    emailTextController, null, null),
                const SizedBox(
                  height: 20,
                ),
                reusableTextFieldLoginAndSignup("Enter password", Icons.lock_outline, true,
                    passwordTextController, null, null),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(
                  context,
                  true,
                  () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailTextController.text,
                          password: passwordTextController.text).then((value){
                            ref.read(userFromAuth.notifier).state = value.user;
                            FirebaseFirestore.instance.collection('users').doc(value.user!.uid).get().then((value) => {
                              user = user_model.User(username: value['username'], email: value['email'], isParent: value['isParent'], children: value['children']),
                              ref.read(userProvider.notifier).state = user
                            });
                          });
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
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
                ),
                signUpOption(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}