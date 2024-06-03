import 'package:dits/controller/product_crud_controller.dart';
import 'package:dits/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dits/model/product_model.dart';

class ProductDetail extends StatefulWidget {
  final DocumentSnapshot product;

  const ProductDetail({required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ProductService productService = ProductService();
  late TextEditingController productNameController;
  late TextEditingController unitController;
  late TextEditingController purchasePriceController;
  late TextEditingController sellingPriceController;
  late TextEditingController openingStockController;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(text: widget.product['productName']);
    unitController = TextEditingController(text: widget.product['unit']);
    purchasePriceController = TextEditingController(text: widget.product['purchasePrice'].toString());
    sellingPriceController = TextEditingController(text: widget.product['sellingPrice'].toString());
    openingStockController = TextEditingController(text: widget.product['openingStock'].toString());
  }

  @override
  void dispose() {
    productNameController.dispose();
    unitController.dispose();
    purchasePriceController.dispose();
    sellingPriceController.dispose();
    openingStockController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    Product updatedProduct = Product(
      productName: productNameController.text,
      unit: unitController.text,
      purchasePrice: double.parse(purchasePriceController.text),
      sellingPrice: double.parse(sellingPriceController.text),
      openingStock: int.parse(openingStockController.text),
      uid: widget.product['uid'],
    );

    await productService.updateProduct(updatedProduct, widget.product.id);
    Navigator.pop(context, true); // return true to indicate successful update
  }

  Future<void> _deleteProduct() async {
    await productService.deleteProduct(widget.product.id);
    Navigator.pop(context, true); // return true to indicate successful deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
              'Product Detail',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColorDark,
              ),
            ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppThemes.primaryColorDark,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _deleteProduct();
            },
            color: Colors.red,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: unitController,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
            TextField(
              controller: purchasePriceController,
              decoration: InputDecoration(labelText: 'Purchase Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sellingPriceController,
              decoration: InputDecoration(labelText: 'Selling Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: openingStockController,
              decoration: InputDecoration(labelText: 'Opening Stock'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
