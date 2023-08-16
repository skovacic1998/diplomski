import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/note.dart';
import 'package:vrtic/providers/evidention_provider.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';
import 'custom_datetime_picker.dart';

class AddNoteForChild extends StatelessWidget {
  const AddNoteForChild({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController noteEditingController = TextEditingController();
    return Scaffold(
      appBar: customAppBar('Notes'),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  'Note',
                  Icons.note_alt_outlined,
                  false,
                  noteEditingController,
                  Colors.black,
                  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 2, style: BorderStyle.solid)),
                ),
                const CustomDateTimePicker(),
                const SizedBox(
                  height: 10,
                ),
                const ChildObjectListSingleSelect(),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final child = ref.watch(selectedChildObjectProvider);
              final timestamp =
                  ref.watch(dateTimeProvider).millisecondsSinceEpoch;
              return ElevatedButton(
                onPressed: () async {
                  Note note = Note(
                      noteText: noteEditingController.text,
                      timestamp: timestamp,
                      child: child);
                  await FirebaseFirestore.instance
                      .collection('notes')
                      .doc()
                      .set(note.toMap())
                      .whenComplete(() {
                    SnackBar snackBar = SnackBar(
                      backgroundColor: hexStringToColor("D37E1A"),
                      content: const Text(
                        "Note saved to database",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: const Text('Save note to database'),
              );
            },
          ),
        )
      ],
    );
  }
}
