import 'package:flutter/material.dart';

class customers extends StatefulWidget {
  const customers({super.key});

  @override
  State<customers> createState() => _customersState();
}

class _customersState extends State<customers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed logic here
          print('FAB pressed!');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple, // Customize the FAB color if needed
      ),
    );
  }
}