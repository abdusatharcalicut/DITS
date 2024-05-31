import 'package:dits/network/network_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dits/model/signup_model.dart';

// Add user to local storage and Firestore if network is available
Future<bool> adduserToBox(BuildContext context, User user) async {
  var box = await Hive.openBox<User>('users');
  bool status = false;

  try {
    // Check if the user already exists
    bool userExists = box.values.any((p) => p.mobileNumber == user.mobileNumber);

    if (userExists) {
      // User already exists
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User already exists!'),
        ),
      );
    } else {
      // User doesn't exist, add it to the box
      await box.add(user);
      status = true;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-up Successfully Please login'),
        ),
      );

      // Check network connection
      if (await hasNetworkConnection()) {
        // Add user data to Firestore
        await syncLocalDataToFirestore();
      }
    }
  } finally {
    await box.close();
  }

  return status;
}

// Sync local data to Firestore
Future<void> syncLocalDataToFirestore() async {
  var box = await Hive.openBox<User>('users');

  // Check network connection
  if (await hasNetworkConnection()) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userCollection = firestore.collection('users');

    for (var user in box.values) {
      // Check if user already exists in Firestore
      QuerySnapshot querySnapshot = await userCollection
          .where('mobileNumber', isEqualTo: user.mobileNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // User doesn't exist, add to Firestore
        await userCollection.add(user.toMap());
      }
    }
  }

  await box.close();
}
