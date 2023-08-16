import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/models/activity.dart';
import 'package:vrtic/reusable_widgets/reusable_widget.dart';
import 'package:vrtic/screens/custom_datetime_picker.dart';

import '../providers/evidention_provider.dart';
import '../utils/color_utils.dart';

class AddActivity extends StatelessWidget {
  const AddActivity({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      appBar: customAppBar('Add activity'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                reusableTextField(
                  'Title',
                  Icons.title,
                  false,
                  titleController,
                  Colors.black,
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(width: 2, style: BorderStyle.solid),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  'Description',
                  Icons.description,
                  false,
                  descriptionController,
                  Colors.black,
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(width: 2, style: BorderStyle.solid),
                  ),
                ),
                const CustomDateTimePicker(),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return ElevatedButton(
                      onPressed: () async {
                        Activity activity = Activity(
                            title: titleController.text,
                            description: descriptionController.text,
                            timestamp: ref
                                .read(dateTimeProvider)
                                .millisecondsSinceEpoch);
                        print(activity.title);
                        print(activity.description);
                        print(activity.timestamp);
                        await FirebaseFirestore.instance
                            .collection('activities')
                            .doc()
                            .set(activity.toMap())
                            .whenComplete(() {
                          SnackBar snackBar = SnackBar(
                            backgroundColor: hexStringToColor("D37E1A"),
                            content: const Text(
                              "Activity saved to database",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: const Text('Save activity to database'),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
