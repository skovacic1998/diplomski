import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class AddChildren extends StatefulWidget {
  const AddChildren({super.key});

  @override
  State<AddChildren> createState() => _AddChildrenState();
}

class _AddChildrenState extends State<AddChildren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar('Add children'),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Name: '),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter child name',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Surname: '),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter child surname',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Name: '),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter child name',
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
