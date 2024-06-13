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
  String? selectedUnit;
  late TextEditingController purchasePriceController;
  late TextEditingController sellingPriceController;
  late TextEditingController openingStockController;

  @override
  void initState() {
    super.initState();
    productNameController =
        TextEditingController(text: widget.product['productName']);
    selectedUnit = widget.product['unit'];
    purchasePriceController =
        TextEditingController(text: widget.product['purchasePrice'].toString());
    sellingPriceController =
        TextEditingController(text: widget.product['sellingPrice'].toString());
    openingStockController =
        TextEditingController(text: widget.product['openingStock'].toString());
  }

  @override
  void dispose() {
    productNameController.dispose();
    purchasePriceController.dispose();
    sellingPriceController.dispose();
    openingStockController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    Product updatedProduct = Product(
      productName: productNameController.text,
      unit: selectedUnit!,
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

  Future<void> _showStockDialog(String action) async {
    TextEditingController stockController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Stock'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter the quantity to $action:'),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Quantity'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                // Handle the stock update logic here
                int stockChange = int.parse(stockController.text);
                if (action == 'Increase') {
                  openingStockController.text =
                      (int.parse(openingStockController.text) + stockChange)
                          .toString();
                } else if (action == 'Reduce') {
                  openingStockController.text =
                      (int.parse(openingStockController.text) - stockChange)
                          .toString();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          icon: Icon(Icons.arrow_back, color: AppThemes.primaryColorDark),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10.0),
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  suffixIcon: SizedBox(
                    width: 120, // Set the width of the dropdown button
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      items: [
                        'No Unit',
                        'Kg',
                        'Gm',
                        'Ltr',
                        'Ml',
                        'Mtr',
                        'Box',
                        'Pack',
                        'Nos',
                        'Piece',
                        'Dozen',
                        'Carton',
                        'Can',
                        'Bundle',
                        'Bag',
                        'Bottle',
                        'Set',
                        'Roll',
                        'Pair',
                        'Foot',
                        'Sqf',
                        'Sqm'
                      ]
                          .map((unit) => DropdownMenuItem(
                                child: Text(unit),
                                value: unit,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppThemes.primaryColorDark,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Unit Type',
                      ),
                      elevation: 4, // adjust elevation
                      itemHeight: 48, // adjust item height
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppThemes.primaryColorDark,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Product Name',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: purchasePriceController,
                decoration: InputDecoration(
                  labelText: 'Purchase Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppThemes.primaryColorDark,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Purchase Price',
                ),
                onSubmitted: (value) {},
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: sellingPriceController,
                decoration: InputDecoration(
                  labelText: 'Sale Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppThemes.primaryColorDark,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Sale Price',
                ),
                onSubmitted: (value) {},
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: openingStockController,
                decoration: InputDecoration(
                  labelText: 'Opening Stock',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppThemes.primaryColorDark,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Opening Stock',
                ),
                onSubmitted: (value) {},
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24.0),
              Container(
                child: SizedBox(
                  width: 400,
                  height: 160,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(
                              Icons.production_quantity_limits_outlined,
                              size: 40),
                          title: Text(
                            'Stock Quantity',
                            style: TextStyle(
                              fontSize: 22.0,
                              color: AppThemes.primaryColorDark,
                            ),
                          ),
                          subtitle: Text(
                            'Manage stock quantity',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () => _showStockDialog('Increase'),
                              child: Text('Increase (+)'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Set rounded corner radius
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            ElevatedButton(
                              onPressed: () => _showStockDialog('Reduce'),
                              child: Text('Reduce (-)'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Set rounded corner radius
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    child: Text('Update Product'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Set rounded corner radius
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
