import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///头像图片
//Widget UserImage({@required String url}) {
//  return Container(
//    margin: EdgeInsets.only(left: 15.0, right: 5, top: 5, bottom: 0),
//    width: 80,
//    height: 100,
//    child: CachedNetworkImage(
//      imageUrl: url,
//    ),
//  );
//}

class UserImageWidget extends StatelessWidget {
  final String url;

  UserImageWidget({Key key, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 5, top: 5, bottom: 0),
      width: 80,
      height: 80,
      child: (url==null||url.toString().isEmpty)?Image.asset('assets/img/用户.png'):CachedNetworkImage(
        imageUrl: url,
        placeholder:  (context,url){
          return SpinKitFadingFour(color: Colors.grey,);
        },
      ),
    );
  }
}
