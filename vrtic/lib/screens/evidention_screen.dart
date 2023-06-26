import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/reusable_widgets/reusable_widget.dart';

class EvidentionScreen extends StatelessWidget {
  const EvidentionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return Scaffold(
      appBar: customAppBar('Child evidention'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Create new evidention',
                  style: TextStyle(fontSize: 18)),
              const Text('Choose date and time of evidention',
                  style: TextStyle(fontSize: 18)),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return OutlinedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: dateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date == null) return;
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: dateTime.hour, minute: dateTime.minute),
                      );
                      if (time == null) return;

                      final dateAndTime = DateTime(date.day, date.month,
                          date.year, time.hour, time.minute);
                    },
                    child: Text(
                        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future pickDateAndTime(DateTime dateTime, BuildContext context) async {
  //   DateTime? date = await pickDate(dateTime, context);
  //   if (date == null) return;
  //   TimeOfDay? time = await pickTime(dateTime, context);
  //   if (time == null) return;

  //   final dateAndTime =
  //       DateTime(date.day, date.month, date.year, time.hour, time.minute);
  // }

  // Future<DateTime?> pickDate(DateTime datetime, BuildContext context) =>
  //     showDatePicker(
  //         context: context,
  //         initialDate: datetime,
  //         firstDate: DateTime(2000),
  //         lastDate: DateTime(2100));

  // Future<TimeOfDay?> pickTime(DateTime dateTime, BuildContext context) =>
  //     showTimePicker(
  //         context: context,
  //         initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
