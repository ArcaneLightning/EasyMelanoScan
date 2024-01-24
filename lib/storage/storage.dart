import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melanoma_detection/center/center.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readUser(id: FirebaseAuth.instance.currentUser!.uid),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text("Storage"), centerTitle: true, backgroundColor: Colors.white,
            actions: [clear(context, id: FirebaseAuth.instance.currentUser!.uid)],),
            body: user.picturesLabels.isEmpty
            ? const Center(child: Text("No Data in Storage"))
            : GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: user.picturesLabels.map((pl) => dataToWidget(pl)).toList(),
            )
          );
        } else {
          return Container();
        }
      }),
    );
  }

  Future<IUser?> readUser({required String id}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return IUser.fromJson(snapshot.data()!);
    }
  }

  Future clearUser({required String id}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    docUser.update({
      'picturesLabels': [],
    });
  }

  Widget dataToWidget (String pictureLabel) {
    List<String> both = pictureLabel.split("-");
    String imagePath = both[0];
    String label = both[1];
    File imageFile = File(imagePath);
    Image image = Image.file(imageFile);
    return Column(
      children: [Expanded(flex: 1, child: image), Text(label.toUpperCase(), style: TextStyle(fontSize: 15, color: label == 'benign' ? Colors.green : Colors.red),)],
    );
  }

  Widget clear (BuildContext context, {required String id}) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.clear),
      label: const Text("Clear"),
      onPressed:() {
        clearUser(id: id);
        Navigator.pop(context);
      },
    );
  }
}