import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/child.dart';
import 'package:vrtic/providers/add_children_provider.dart';
import 'package:vrtic/reusable_widgets/reusable_widget.dart';


import '../utils/color_utils.dart';

class AddChildren extends StatelessWidget {
  const AddChildren({super.key, required this.currentUser});
  final User currentUser;
  @override
  Widget build(BuildContext context) {
    int childTypeForSend = 0;
    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    return Scaffold(
      appBar: _customAppBar('Add children'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Child name:'),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: nameController,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black.withOpacity(0.9)),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 1, style: BorderStyle.none),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('Child surname:'),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: surnameController,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black.withOpacity(0.9)),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 1, style: BorderStyle.none),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Sex: '),
                const SizedBox(
                  width: 8,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final childType = ref.watch(childTypeProvider);
                    return Radio(
                        value: 0,
                        groupValue: childType,
                        onChanged: (value) {
                          childTypeForSend = value!;
                          ref.read(childTypeProvider.notifier).state = value;
                        });
                  },
                ),
                const Text('Male'),
                const SizedBox(width: 20),
                Consumer(
                  builder: (context, ref, child) {
                    final childType = ref.watch(childTypeProvider);
                    return Radio(
                        value: 1,
                        groupValue: childType,
                        onChanged: (value) {
                          childTypeForSend = value!;
                          ref.read(childTypeProvider.notifier).state = value;
                        });
                  },
                ),
                const Text('Female'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                Child newChild = Child(
                  name: nameController.text,
                  surname: surnameController.text,
                  sex: childTypeForSend,
                );
                String jsonUser = jsonEncode(newChild);
                await FirebaseFirestore.instance.collection('child').doc().set(newChild.getMap());
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid.toString()).update({"children":FieldValue.arrayUnion([newChild.getMap()])});
                print(jsonUser);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black26;
                  }
                  return Colors.white;
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              child: const Text(
                'Add child',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ChildObjectList(userId: currentUser!.uid),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar _customAppBar(String text) {
  return AppBar(
    title: Text(text),
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
  );
}
