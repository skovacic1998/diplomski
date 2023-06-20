import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class AddChildren extends StatefulWidget {
  const AddChildren({super.key});

  @override
  State<AddChildren> createState() => _AddChildrenState();
}

class _AddChildrenState extends State<AddChildren> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar('Add children'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Child name:'),
                const SizedBox(width: 8,),
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
                          borderSide:
                              const BorderSide(width: 1, style: BorderStyle.none),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
