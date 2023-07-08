import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrtic/providers/evidention_provider.dart';

import '../utils/color_utils.dart';

Image logoWidget(String imageString) {
  return Image.asset(
    imageString,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(
    String text,
    IconData iconData,
    bool isPasswordType,
    TextEditingController controller,
    Color? textColor,
    OutlineInputBorder? outlineBorder) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: textColor ?? Colors.white.withOpacity(0.9),
    style: TextStyle(
      color: textColor ?? Colors.white.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        iconData,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: outlineBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    maxLines: isPasswordType ? 1 : 5,
  );
}

TextField reusableTextFieldLoginAndSignup(
    String text,
    IconData iconData,
    bool isPasswordType,
    TextEditingController controller,
    Color? textColor,
    OutlineInputBorder? outlineBorder) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: textColor ?? Colors.white.withOpacity(0.9),
    style: TextStyle(
      color: textColor ?? Colors.white.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        iconData,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: outlineBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    maxLines: 1,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

class ChildObjectListMultiSelect extends ConsumerWidget {
  const ChildObjectListMultiSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedChildrenProvider);
    final selectedChildren = ref.watch(selectedChildrenObjectsProvider);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('child').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final children = snapshot.data?.docs;
        if (children == null || children.isEmpty) {
          return const Text('No children found.');
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (context, index) {
              final childId = children[index].id;
              final child = children[index].data() as Map<String, dynamic>;
              final childName = child['name'];
              final childSurname = child['surname'];
              final actualChild = {
                'name': childName,
                'sex': child['sex'],
                'surname': childSurname,
                'id': childId
              };
              return ListTile(
                tileColor: selectedItems.contains(index)
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.transparent,
                onTap: () {
                  if (!selectedItems.contains(index)) {
                    ref.read(selectedChildrenProvider.notifier).state = [
                      ...selectedItems,
                      index
                    ];
                  }
                  final isValueUnique = selectedChildren
                      .every((item) => item['id'] != actualChild['id']);
                  if (isValueUnique) {
                    ref.read(selectedChildrenObjectsProvider.notifier).state = [
                      ...selectedChildren,
                      actualChild
                    ];
                  }
                },
                onLongPress: () {
                  ref.read(selectedChildrenProvider.notifier).state = [
                    ...selectedItems.where((item) => item != index),
                  ];

                  ref.read(selectedChildrenObjectsProvider.notifier).state = [
                    ...selectedChildren
                        .where((item) => item['id'] != actualChild['id']),
                  ];
                },
                leading: const Icon(
                  Icons.child_care,
                  size: 40,
                ),
                title: Text('$childName'),
                subtitle: Row(
                  children: [
                    Text(childSurname),
                    const SizedBox(
                      width: 20,
                    ),
                    checkChildSex(
                      child['sex'].toString(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ChildObjectListSingleSelect extends ConsumerWidget {
  const ChildObjectListSingleSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('child').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final children = snapshot.data?.docs;
        if (children == null || children.isEmpty) {
          return const Text('No children found.');
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (context, index) {
              final childId = children[index].id;
              final child = children[index].data() as Map<String, dynamic>;
              final childName = child['name'];
              final childSurname = child['surname'];
              final actualChild = {
                'name': childName,
                'sex': child['sex'],
                'surname': childSurname,
                'id': childId
              };
              return _CustomListTile(index, actualChild);
            },
          ),
        );
      },
    );
  }
}

class ActivitiesList extends ConsumerWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('activities').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final activities = snapshot.data?.docs;
        if (activities == null || activities.isEmpty) {
          return const Text('No sctivites found.');
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index].data() as Map<String, dynamic>;
              final activityTitle = activity['title'];
              final activityDescription = activity['description'];
              final timestamp = activity['timestamp'];
              final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              return _CustomCardForActivity(index, activityTitle, activityDescription, dateTime);
            },
          ),
        );
      },
    );
  }
}

class _CustomListTile extends ConsumerWidget {
  const _CustomListTile(this.index, this.child);
  final int index;
  final Map<String, dynamic> child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedChildIndexProvider);
    return ListTile(
      tileColor: selectedItem == index
          ? Colors.blue.withOpacity(0.5)
          : Colors.transparent,
      onTap: () {
        if (selectedItem != index) {
          ref.read(selectedChildObjectProvider.notifier).state = child;
          ref.read(selectedChildIndexProvider.notifier).state = index;
        }
      },
      leading: const Icon(
        Icons.child_care,
        size: 40,
      ),
      title: Text(child['name']),
      subtitle: Row(
        children: [
          Text(child['surname']),
          const SizedBox(
            width: 20,
          ),
          checkChildSex(
            child['sex'].toString(),
          ),
        ],
      ),
    );
  }
}

class _CustomCardForActivity extends ConsumerWidget {
  const _CustomCardForActivity(this.index, this.title, this.description, this.dateTime);
  final int index;
  final String title;
  final String description;
  final DateTime dateTime;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
          const Text('Title: ', style: TextStyle(fontWeight: FontWeight.bold),), Text(title),
        ],),
        const SizedBox(height: 5,), 
        Row(
          children: [const Text('Description: ', style: TextStyle(fontWeight: FontWeight.bold),),Text(description)],
        ),
        const SizedBox(height: 5,), 
        Text('${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute}'),
      ]),
    );
  }
}

class ChildObjectList extends StatelessWidget {
  final String userId;

  const ChildObjectList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.data!.exists) {
          return const Text('User not found');
        }

        List<dynamic>? children =
            (snapshot.data!.data() as Map<String, dynamic>?)?['children'];
        if (children == null || children.isEmpty) {
          return const Text('No children found');
        }

        return ListView.builder(
          itemCount: children.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            dynamic child = children[index];
            return Card(
              child: OutlinedButton(
                onPressed: () {
                  _dialogBuilder(context, child);
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: Column(
                      children: [
                        Text(child['name']),
                        checkChildSex(child['sex'].toString()),
                        Text(child['surname']),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void deleteChildFromChildTable(String childName, String childSurname) {
    FirebaseFirestore.instance
        .collection('child')
        .where('name', isEqualTo: childName)
        .where('surname', isEqualTo: childSurname)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      } else {
        print('Child not found');
      }
    });
  }

  void deleteChildByNameAndSurname(
      String userId, String childName, String childSurname) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        List<dynamic>? children = docSnapshot.data()?['children'];

        if (children != null) {
          children.removeWhere((child) =>
              child['name'] == childName && child['surname'] == childSurname);

          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'children': children})
              .then((_) => print('Child deleted successfully'))
              .catchError((error) => print('Failed to delete child: $error'));
        }
      }
    });
  }

  Future<void> _dialogBuilder(BuildContext context, dynamic child) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove child?'),
          content:
              const Text('Do you wish to remove this child from our database?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                deleteChildFromChildTable(child['name'], child['surname']);
                deleteChildByNameAndSurname(
                    userId, child['name'], child['surname']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Text checkChildSex(String sex) {
  if (sex == "0") {
    return const Text("Male");
  } else {
    return const Text("Female");
  }
}

AppBar customAppBar(String text) {
  return AppBar(
    title: Text(text),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor("f4791f"),
            hexStringToColor("659999"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
  );
}
