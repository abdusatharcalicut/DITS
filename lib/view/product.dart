import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dits/view/add_product.dart';
import 'package:flutter/material.dart';
import 'package:dits/themes/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class product extends StatefulWidget {
  const product({Key? key});

  @override
  State<product> createState() => productState();
}

class productState extends State<product> {
  TextEditingController _searchController = TextEditingController();
  String? mobileNumber;
  final CollectionReference items = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    super.initState();
    _loadLogId();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLogId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileNumber = prefs.getString('logId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Text(
              'Products',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColorDark,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Trigger rebuild when text changes
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(
                        () {}); // Trigger rebuild when search button is pressed
                  },
                ),
              ),
              onSubmitted: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: mobileNumber == null
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .where('uid', isEqualTo: int.parse(mobileNumber!))
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          // Filter the list based on the search query
                          final List<DocumentSnapshot> filteredProducts =
                              snapshot.data!.docs.where((doc) {
                            final productName = doc['productName'] as String;
                            return productName
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase());
                          }).toList();
                          return ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot productTable =
                                  filteredProducts[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Sale price",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            Text(
                                              productTable['productName']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppThemes
                                                    .primaryColorDark,
                                              ),
                                            ),
                                            Text(
                                              "INR : " +
                                                  productTable['sellingPrice']
                                                      .toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Purchase Price",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            Text(
                                              "INR : " +
                                                  productTable['purchasePrice']
                                                      .toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Stock",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            Text(
                                              productTable['openingStock']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green),
                                            ),
                                            Text(
                                              productTable['unit'].toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
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
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppThemes.primaryColorDark,
      ),
    );
  }
}
