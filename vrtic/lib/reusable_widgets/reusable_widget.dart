import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched
        }

        if (!snapshot.data!.exists) {
          return const Text(
              'User not found'); // Handle case when the user document doesn't exist
        }

        // Access the 'children' field from the user document
        List<dynamic>? children =
            (snapshot.data!.data() as Map<String, dynamic>?)?['children'];
        if (children == null || children.isEmpty) {
          return const Text(
              'No children found'); // Handle case when the 'children' field is empty or not available
        }

        return ListView.builder(
          itemCount: children.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          //     return Card(
          //       child: SizedBox(
          //         width: double.infinity,
          //         height: 100,
          //         child: Center(child: Text(names[number])),
          //       ),
          //     );
          //   },
          itemBuilder: (context, index) {
            // Access each child object within the 'children' list
            dynamic child = children[index];
            return Card(
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Column(
                    children: [
                      Text(child['name']),
                      Text(child['sex'].toString()),
                      Text(child['surname']),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
