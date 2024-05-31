import 'package:dits/controller/add_product_controller.dart';
import 'package:dits/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:dits/model/add_product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _productNameController = TextEditingController();
  String? _selectedUnit;
  TextEditingController _purchasePriceController = TextEditingController();
  TextEditingController _salePriceController = TextEditingController();
  TextEditingController _openingStockController = TextEditingController();
  List<Product> _products = [];

  @override
  void dispose() {
    _productNameController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _openingStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Add Products',
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
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  suffixIcon: SizedBox(
                    width: 120, // Set the width of the dropdown button
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
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
                      ].map((unit) => DropdownMenuItem(
                            child: Text(unit),
                            value: unit,
                          )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value;
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
                controller: _purchasePriceController,
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
                controller: _salePriceController,
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
                controller: _openingStockController,
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
              Center(
                child: SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addProduct,
                    child: Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Set rounded corner radius
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: _buildProductList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() async {
    // Validate form
    if (!_validateForm()) return;

    // Create Product object
    Product product = Product(
      productName: _productNameController.text,
      unit: _selectedUnit ?? "",
      purchasePrice: double.parse(_purchasePriceController.text),
      sellingPrice: double.parse(_salePriceController.text),
      openingStock: int.parse(_openingStockController.text),
    );

    bool addedSuccessfully = await addProductToBox(context, product);

    if (addedSuccessfully) {
      setState(() {
        _products.add(product);
      });
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Product added Successfully'),
      //   ),
      // );
      _productNameController.clear();
      _purchasePriceController.clear();
      _salePriceController.clear();
      _openingStockController.clear();
      setState(() {
        _selectedUnit = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product already exists: ${product.productName}'),
        ),
      );
    }
  }

  bool _validateForm() {
    if (_productNameController.text.isEmpty ||
        _purchasePriceController.text.isEmpty ||
        _salePriceController.text.isEmpty ||
        _openingStockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return false;
    }
    return true;
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                     Text("Product ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                     Text(product.productName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 49, 100, 158),),),
                     ],
                     ),
              Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                     Text("Sale price",style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                     Text("INR : " + '${product.sellingPrice}',style: TextStyle(fontSize: 14),),
                     ],
                     ),
              Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                     Text("purchase Price",style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                     Text("INR : " + '${product.purchasePrice}',style: TextStyle(fontSize: 14),),
                     ],
                     ),
                     Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                     Text("Stock",style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                     Text('${product.openingStock}',style: TextStyle(fontSize: 14,color: Colors.green),),
                     Text('${product.unit}',style: TextStyle(fontSize: 14),),
                     ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
        ),
      ],
    );
      },
    );
  }
}
