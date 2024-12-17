import 'package:flutter/cupertino.dart';

class MyCustomClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size){
    Path path = Path();
    path.lineTo(0,size.height-90);
    path.quadraticBezierTo(size.width/5,size.height-120,size.width, size.height/4);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}