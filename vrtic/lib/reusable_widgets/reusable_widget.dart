import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

TextField reusableTextField(String text, IconData iconData, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
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
          return const Text(
              'User not found');
        }

        List<dynamic>? children =
            (snapshot.data!.data() as Map<String, dynamic>?)?['children'];
        if (children == null || children.isEmpty) {
          return const Text(
              'No children found');
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

  void deleteChildFromChildTable(String childName, String childSurname){
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
            children.removeWhere((child) => child['name'] == childName && child['surname'] == childSurname);

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
          content: const Text(
            'Do you wish to remove this child from our database?'
          ),
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
                  deleteChildByNameAndSurname(userId, child['name'], child['surname']);
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  Text checkChildSex(String sex) {
    if(sex == "0"){
      return const Text("Male");
    }else{
      return const Text("Female");
    }
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
