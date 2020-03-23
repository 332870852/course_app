import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tick extends StatelessWidget {
  final DecorationImage image;

  Tick({this.image});

  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: ScreenUtil.screenWidthDp,
      height: 200.0,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/img/appIcon.png',fit: BoxFit.contain,width: ScreenUtil.textScaleFactory*100
            ,height:  ScreenUtil().setHeight(150),),
          Text('智慧课堂辅助App',style: TextStyle(color: Colors.white,fontSize: ScreenUtil.textScaleFactory*30),),
        ],
      ),
//      decoration: new BoxDecoration(
//        image: image,
//      ),
    ));
  }
}
