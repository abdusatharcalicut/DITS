import 'package:dits/view/home.dart';
import 'package:dits/view/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? logstatus;
  String? log = "Logout";

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
    LoadData();
  }

Future<void> LoadData() async {
    await Future.delayed(Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      logstatus = prefs.getString('status');
    });
    if(logstatus == log || logstatus == null){
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=> LoginPage()),
      );
    }else{
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=> HomePage()),
      );
    }
    
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dynexoitr.png',
              height: 250,
            ),
            // Loading indicator
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
