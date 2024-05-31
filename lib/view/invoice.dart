import 'package:flutter/material.dart';

class invoice extends StatefulWidget {
  const invoice({super.key});

  @override
  State<invoice> createState() => _dashBoardState();
}

class _dashBoardState extends State<invoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drawer Example',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
