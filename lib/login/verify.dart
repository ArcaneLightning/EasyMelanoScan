// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class VerifyScreen extends StatelessWidget {
//   const VerifyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton.icon(
//         icon: const Icon(FontAwesomeIcons.check),
//         label: const Text("Proceed?"),
//         onPressed: () {
//           createUser(id: FirebaseAuth.instance.currentUser!.uid);
//           Navigator.pushNamed(context, '/center');
//         },
//       ),
//     );
//   }

  // Future createUser({required String id}) async {
  //   final docUser = FirebaseFirestore.instance.collection('users').doc(id);
  //   final json = {
  //     'name': FirebaseAuth.instance.currentUser!.displayName ?? "Guest"
  //   };
  //   await docUser.set(json);


//   }
// }