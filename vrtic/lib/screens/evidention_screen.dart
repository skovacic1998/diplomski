import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/evidention.dart';
import 'package:vrtic/providers/evidention_provider.dart';
import 'package:vrtic/reusable_widgets/reusable_widget.dart';
import 'package:vrtic/screens/custom_datetime_picker.dart';

class EvidentionScreen extends ConsumerWidget {
  const EvidentionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar('Evidention'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(children: [
            const CustomDateTimePicker(),
            const Align(
                alignment: Alignment.topCenter,
                child: ChildObjectListMultiSelect()),
            ElevatedButton(
              onPressed: () async {
                Evidention evidention = Evidention(timestamp: ref.read(dateTimeProvider).millisecondsSinceEpoch, children: ref.read(selectedChildrenObjectsProvider));
                print(evidention.timestamp);
                print(evidention.children);
                await FirebaseFirestore.instance.collection('evidentions').doc().set(evidention.toMap());
              },
              child: const Text('Save evidention to database'),
            ),
          ]),
        ),
      ),
    );
  }
}
