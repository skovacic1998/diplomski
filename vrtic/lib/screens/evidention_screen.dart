import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/evidention.dart';
import 'package:vrtic/providers/evidention_provider.dart';
import 'package:vrtic/reusable_widgets/reusable_widget.dart';
import 'package:vrtic/screens/custom_datetime_picker.dart';

class EvidentionScreen extends StatelessWidget {
  const EvidentionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Evidention'),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(children: [
              CustomDateTimePicker(),
              Align(
                  alignment: Alignment.topCenter,
                  child: ChildObjectListMultiSelect()),
            ]),
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return ElevatedButton(
                      onPressed: () async {
                        Evidention evidention = Evidention(
                            timestamp:
                                ref.read(dateTimeProvider).millisecondsSinceEpoch,
                            children: ref.read(selectedChildrenObjectsProvider));
                        print(evidention.timestamp);
                        print(evidention.children);
                        await FirebaseFirestore.instance
                            .collection('evidentions')
                            .doc()
                            .set(evidention.toMap());
                      },
                      child: const Text('Save evidention to database'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
