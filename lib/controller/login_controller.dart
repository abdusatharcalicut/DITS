import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dits/model/signup_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> authenticateUser(String mobileNumber, String password) async {
  var box = await Hive.openBox<User>('users');
  bool isAuthenticated = false;

  try {
    // Check if the user exists in Hive
    User? user = box.values.cast<User?>().firstWhere(
          (p) =>
              p?.mobileNumber.toString() == mobileNumber &&
              p?.password == password,
          orElse: () => null,
        );

    if (user != null) {
      // User found and password matched in Hive
      user.status = 'Login';
      box.putAt(box.values.toList().indexOf(user), user);
      await updateUserStatusInFirestore(user.mobileNumber, 'Login');
      await saveLogId(user.mobileNumber.toString(), user.status);
      isAuthenticated = true;
    } else {
      // Check internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // Check in Firestore if user is not found in Hive
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference userCollection = firestore.collection('users');

        QuerySnapshot querySnapshot = await userCollection
            .where('mobileNumber', isEqualTo: int.parse(mobileNumber))
            .where('password', isEqualTo: password)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          doc.reference.update({'status': 'Login'});

          // Update status in Hive if needed
          User firestoreUser = User.fromMap(doc.data() as Map<String, dynamic>);
          firestoreUser.status = 'Login';
          box.add(firestoreUser);

          await saveLogId(
              firestoreUser.mobileNumber.toString(), firestoreUser.status);
          isAuthenticated = true;
        }
      }
    }
  } catch (e) {
    print('Error during authentication: $e');
  } finally {
    await box.close();
  }

  return isAuthenticated;
}

Future<void> updateUserStatusInFirestore(
    int mobileNumber, String status) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userCollection = firestore.collection('users');

  QuerySnapshot querySnapshot =
      await userCollection.where('mobileNumber', isEqualTo: mobileNumber).get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot doc = querySnapshot.docs.first;
    doc.reference.update({'status': status});
  }
}

Future<void> saveLogId(String mobileNumber, String status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('logId', mobileNumber);
  await prefs.setString('status', status);
}

Future<String?> getLogId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('logId');
}

Future<String?> getStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('status');
}
