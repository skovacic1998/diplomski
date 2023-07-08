import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/reusable_widgets/notes_list.dart';
import 'package:vrtic/screens/sign_in_screen.dart';

import '../reusable_widgets/reusable_widget.dart';

class NoteScreen extends ConsumerWidget {
  const NoteScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userFromAuth);
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
                NotesList(currentUser: user,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}