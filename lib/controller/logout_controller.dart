import 'package:dits/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dits/model/signup_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Update the status in both Hive and Firestore
Future<void> logoutUser(BuildContext context, String mobileNumber) async {
  try {
    // Update status in Hive
    var box = await Hive.openBox<User>('users');
    int parsedMobileNumber = int.parse(mobileNumber);

    // Find the user in Hive and update the status
    User? user = box.values
        .firstWhere((user) => user.mobileNumber == parsedMobileNumber);
    if (user != null) {
      user.status = 'Logout';
      int userIndex = box.values.toList().indexOf(user);
      await box.putAt(userIndex, user);
    }

    // Update the status in SharedPreferences
    await saveLogId(mobileNumber, 'Logout');

    // Check internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // If there's internet, update Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference userCollection = firestore.collection('users');

      // Query Firestore to find the user document
      QuerySnapshot querySnapshot = await userCollection
          .where('mobileNumber', isEqualTo: parsedMobileNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the matched user
        String docId = querySnapshot.docs.first.id;

        // Update the status field in Firestore
        await userCollection.doc(docId).update({'status': 'Logout'});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout successful'),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
        ),
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error during logout: $e'),
      ),
    );
  }
}
