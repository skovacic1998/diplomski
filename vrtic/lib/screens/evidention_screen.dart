import 'package:flutter/material.dart';
import 'package:vrtic/reusable_widgets/reusable_widget.dart';
import 'package:vrtic/screens/custom_datetime_picker.dart';

class EvidentionScreen extends StatelessWidget {
  const EvidentionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Evidention'),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          CustomDateTimePicker(),
          Align(alignment: Alignment.topCenter,child: ChildObjectListMultiSelect()),
        ]),
      ),
    );
  }
}
