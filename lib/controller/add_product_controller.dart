import 'package:dits/model/add_product_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//add product controller
Future<bool> addProductToBox(BuildContext context, Product product) async {
  var box = await Hive.openBox<Product>('products');
  bool status = false;

  try {
    // Check if the product already exists
    var existingProduct = box.values.firstWhere(
      (p) => p.productName == product.productName,
      orElse: () => Product(
        productName: '',
        unit: '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        openingStock: 0,
      ),
    );

    if (existingProduct.productName.isNotEmpty) {
      status = false;
    } else {
      // Product doesn't exist, add it to the box
      await box.add(product);
      status = true;

      // Add product data to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference productsCollection = firestore.collection('products');
      await productsCollection.add(product.toMap());

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Product added to Online: ${product.productName}'),
      //   ),
      // );
    }
  } finally {
    await box.close();
  }

  return status; // Return the status
}




