import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class AddChildren extends StatefulWidget {
  const AddChildren({super.key});

  @override
  State<AddChildren> createState() => _AddChildrenState();
}

class _AddChildrenState extends State<AddChildren> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  int? selectedOption = 0;
  List<String> names = ['pero', 'marica', 'barica'];
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
                Radio(
                  value: 0,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                const Text('Male'),
                const SizedBox(width: 20),
                Radio(
                  value: 1,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
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
            SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: names.length,
                itemBuilder: (BuildContext ctx, number) {
                  return Card(
                    child: SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Center(child: Text(names[number])),
                    ),
                  );
                },
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
