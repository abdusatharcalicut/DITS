import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dits/model/product_model.dart';

// Add product controller
Future<bool> addProductToBox(BuildContext context, Product product) async {
  var box = await Hive.openBox<Product>('products');
  bool status = false;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? mobileNumber = prefs.getString('logId');

  if (mobileNumber == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in')),
    );
    return status;
  }

  // Set the product's uid to the user's mobile number
  product.uid = int.parse(mobileNumber);

  try {
    // Check if the product already exists in Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');

    QuerySnapshot querySnapshot = await productsCollection
        .where('productName', isEqualTo: product.productName)
        .where('uid', isEqualTo: product.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Product already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product already exists')),
      );
      status = false;
    } else {
      // Product doesn't exist, add it to the box and Firestore
      await box.add(product);
      await productsCollection.add(product.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added: ${product.productName}')),
      );
      status = true;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add product: $e')),
    );
  } finally {
    await box.close();
  }

  return status;
}
