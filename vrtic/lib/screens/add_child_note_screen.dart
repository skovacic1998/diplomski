import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/note.dart';
import 'package:vrtic/providers/evidention_provider.dart';

import '../reusable_widgets/reusable_widget.dart';
import 'custom_datetime_picker.dart';

class AddNoteForChild extends StatelessWidget {
  const AddNoteForChild({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController noteEditingController = TextEditingController();
    return Scaffold(
      appBar: customAppBar('Add child note'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: reusableTextField(
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
            ),
            const CustomDateTimePicker(),
            const Align(
                alignment: Alignment.topCenter,
                child: ChildObjectListSingleSelect()),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final child = ref.watch(selectedChildObjectProvider);
                final timestamp =
                    ref.read(dateTimeProvider).millisecondsSinceEpoch;
                return ElevatedButton(
                  onPressed: () async {
                    Note note = Note(
                        noteText: noteEditingController.text,
                        timestamp: timestamp,
                        child: child);
                    print(note.noteText);
                    print(note.timestamp);
                    print(note.child);
                    await FirebaseFirestore.instance.collection('notes').doc().set(note.toMap());
                  },
                  child: const Text('Save note to database'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
