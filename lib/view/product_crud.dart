import 'package:dits/themes/app_themes.dart';
import 'package:flutter/material.dart';

class ProductCrud extends StatefulWidget {
  const ProductCrud({Key? key}) : super(key: key);

  @override
  State<ProductCrud> createState() => _ProductCrudState();
}

class _ProductCrudState extends State<ProductCrud> {
  TextEditingController _productNameController = TextEditingController();
  String? _selectedUnit;
  TextEditingController _purchasePriceController = TextEditingController();
  TextEditingController _salePriceController = TextEditingController();
  TextEditingController _openingStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Product',style: TextStyle(color: AppThemes.primaryColorDark,),),
          backgroundColor: Colors.transparent, // Set background color to transparent
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: AppThemes.primaryColorDark,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete,color: Colors.red,),
              onPressed: () {
                // Add your delete functionality here
                // For example, you can show a confirmation dialog
                // and delete the product if confirmed.
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      ]
                          .map((unit) => DropdownMenuItem(
                                child: Text(unit),
                                value: unit,
                              ))
                          .toList(),
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
              Container(
                height: 150,
                width: 400,
                decoration: BoxDecoration(border: Border.all(color:Colors.grey),
                shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(8.0),),
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               ElevatedButton(
                    onPressed: () {},
                    child: Text('ADD STOCK'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Set rounded corner radius
                      ),
                    ),
                  ),
              ElevatedButton(
                    onPressed: () {},
                    child: Text('REDUCE STOCK'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Set rounded corner radius
                      ),
                    ),
                  ),
            ],
          ),
          ),

              ),
              SizedBox(height: 24.0),
              Center(
                child: SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Update'),
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

