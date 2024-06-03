import 'package:dits/network/network_sync_service.dart';
import 'package:dits/model/signup_model.dart';
import 'package:dits/network/db_connection.dart';
import 'package:dits/model/product_model.dart';
import 'package:dits/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dits/view/splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Initialize Firestore
  NetworkSyncService.startService();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirestore();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
