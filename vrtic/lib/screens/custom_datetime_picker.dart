import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/evidention_provider.dart';

class CustomDateTimePicker extends ConsumerStatefulWidget {
  const CustomDateTimePicker({super.key});

  @override
  ConsumerState<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends ConsumerState<CustomDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = ref.watch(dateTimeProvider);
    return Center(
      // appBar: customAppBar('Child evidention'),
      child: Column(
        // body: Padding(
        //   padding: const EdgeInsets.all(8),
        //   child: Center(
        //     child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Choose date and time of evidention',
              style: TextStyle(fontSize: 18)),
          OutlinedButton(
            onPressed: () async {
              final date = await pickDate();
              if (date == null) return;
              final time = await pickTime();
              if (time == null) return;
              final newDateTime = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);
                dateTime = newDateTime;
                ref.read(dateTimeProvider.notifier).state = dateTime;
            },
            child: Text(
                '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute}'),
          ),
        ],
      ),
    );
    //     ),
    //   ),
    // );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: ref.read(dateTimeProvider),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      );
}
