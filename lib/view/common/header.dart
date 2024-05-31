import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({Key? key}) : super(key: key);
void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
  }
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Material(
      // width: double.infinity,
      // height: size.height * 0.3,
      child: Image.asset('assets/images/dynexoitr.png'),
    );
  }
}
