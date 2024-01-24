import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:melanoma_detection/services/auth.dart';
import 'package:melanoma_detection/shared/bottom_nav.dart';

class CenterScreen extends StatefulWidget {
  const CenterScreen({super.key});

  @override
  State<CenterScreen> createState() => _CenterScreenState();
}

class _CenterScreenState extends State<CenterScreen> {
  @override
  void initState() {
    super.initState();
    createUser(id: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        actions: const [
          SignOutButton(),
        ],
        leading: IconButton(
            icon: const Icon(Icons.person), tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // Image.asset('dash.png'),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Warning: Results by this app are not guaranteed to be an accurate diagnosis',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Future createUser({required String id}) async {
    bool docExists = await checkIfDocExists(id);
    debugPrint("Document exists in Firestore?: $docExists, ID: $id");

    if (!docExists) {
      final docUser = FirebaseFirestore.instance.collection('users').doc(id);
      IUser user = IUser(
        picturesLabels: [],
      );

      var json = user.toJson();
      await docUser.set(json);
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('users');

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    rethrow;
  }
}
}

class IUser {
  List picturesLabels = [];

  IUser({
    required this.picturesLabels,
  });

  Map<String, dynamic> toJson() => {
    'picturesLabels': picturesLabels
  };

  static IUser fromJson(Map<String, dynamic> json) => IUser(
    picturesLabels: json['picturesLabels']
  );

}