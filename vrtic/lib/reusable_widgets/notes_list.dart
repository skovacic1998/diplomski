import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key, this.currentUser});

  final currentUser;

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getMatchingNotes(
      String userUid) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    List<dynamic> children = userDoc.data()?['children'];

    QuerySnapshot<Map<String, dynamic>> notesQuerySnapshot =
        await FirebaseFirestore
            .instance
            .collection('notes')
            .where('child.id',
                whereIn: children.map((child) => child['uid']).cast<String>())
            .get();

    return notesQuerySnapshot.docs;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
      future: getMatchingNotes(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final notes = snapshot.data;
        if (notes == null || notes.isEmpty) {
          return const Text('No notes found.');
        }
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return _CustomCardForNotes(notes[index].data());
              },
            ));
      },
    );
  }
}

class _CustomCardForNotes extends StatelessWidget {
  const _CustomCardForNotes(this.noteObject);
  final Map<String, dynamic>? noteObject;

  @override
  Widget build(BuildContext context) {
    final String note = noteObject?['note'];
    final Map<String, dynamic> child = noteObject?['child'];
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(noteObject?['timestamp']);
    return Card(
      child: Column(children: [
        const Icon(Icons.child_care_outlined),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(child['name']),
            const SizedBox(width: 4),
            const Text(
              'Surname: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(child['surname']),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Text(
              'Note: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(note))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
            '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute}'),
      ]),
    );
  }
}
