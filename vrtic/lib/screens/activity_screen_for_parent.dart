import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widget.dart';

class AllActivities extends StatelessWidget {
  const AllActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Activities'),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: ActivitiesList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}