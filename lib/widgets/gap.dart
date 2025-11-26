import 'package:flutter/cupertino.dart';

class Gap extends StatelessWidget {
  double h;
  double w;
  Gap({super.key,this.h=0,this.w=0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h,width: w,);
  }
}
