import 'package:dits/themes/app_themes.dart';
import 'package:flutter/material.dart';

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final VoidCallback onPressed;
  const CustomFormButton({Key? key,
  required this.innerText,
  required this.onPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: AppThemes.primaryColorDark,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(innerText, style: const TextStyle(color: Colors.white, fontSize: 20),),
      ),
    );
  }
}
