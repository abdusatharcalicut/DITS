import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dits/model/product_model.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Product product) async {
    await _productCollection.add(product.toMap());
  }

  Future<List<Product>> getProducts() async {
    QuerySnapshot snapshot = await _productCollection.get();
    return snapshot.docs
        .map((doc) => Product(
              productName: doc['productName'],
              unit: doc['unit'],
              purchasePrice: doc['purchasePrice'],
              sellingPrice: doc['sellingPrice'],
              openingStock: doc['openingStock'],
              uid: doc['uid'],
            ))
        .toList();
  }

  Future<void> updateProduct(Product product, String productId) async {
    await _productCollection.doc(productId).update(product.toMap());
    // Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> deleteProduct(String productId) async {
    await _productCollection.doc(productId).delete();
  }
}
