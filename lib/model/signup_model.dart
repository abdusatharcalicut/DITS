import 'package:hive/hive.dart';
part 'signup_model.g.dart';

//signup model
@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int mobileNumber;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  String status;

  @HiveField(5)
  String payment;

  User({
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.password,
    this.status = 'Logout',
    this.payment = 'Not Paid',
  });

  get key => null;

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password,
      'status': status,
      'payment': payment,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      mobileNumber: map['mobileNumber'] ?? 0,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      status: map['status'] ?? 'Logout',
      payment: map['payment'] ?? 'Not Paid',
    );
  }
}