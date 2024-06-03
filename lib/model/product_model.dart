import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String productName;

  @HiveField(1)
  final String unit;

  @HiveField(2)
  final double purchasePrice;

  @HiveField(3)
  final double sellingPrice;

  @HiveField(4)
  final int openingStock;

  @HiveField(5)
  int uid;

  Product({
    required this.productName,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.openingStock,
    this.uid = 0,
  });

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'unit': unit,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'openingStock': openingStock,
      'uid': uid,
    };
  }

  static fromMap(Map<String, dynamic> data) {}
}
