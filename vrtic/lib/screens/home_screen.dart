import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/screens/sign_in_screen.dart';

import '../utils/color_utils.dart';
import 'adding_children_screen.dart';
/*
final userProviderFromSignIn = StateProvider((ref) {
  return ref.watch(userProvider);
});
*/
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindergarten Joy'),
        flexibleSpace: Container(
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
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outlined),
                          if(user == null)
                            const Text(''),
                          if(user != null)
                            Text(user.email.toString()),
                      ],
                    ),
                    Text('Vrsta korisnika Roditelj/Teta'),
                  ],
                )),
            ListTile(
              title: const Text('Prvi page'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddChildren(currentUser: user)));
              },
            ),
            ListTile(
              title: const Text('Drugi page'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              horizontalTitleGap: 3,
              minLeadingWidth: 3,
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  SnackBar snackBar = SnackBar(
                    backgroundColor: hexStringToColor("D37E1A"),
                    duration: const Duration(seconds: 1),
                    content: const Text(
                      "Signed Out",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
