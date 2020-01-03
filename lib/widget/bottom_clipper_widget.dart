import 'package:flutter/material.dart';

class BottomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height-30);
    var firstControlPoint =Offset(size.width/2,size.height);
    var firstEndPoint = Offset(size.width,size.height-30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height-30);
    path.lineTo(size.width, 0);

    return path;

  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}