import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///首页轮播图

class SwiperDiy extends StatefulWidget {
  final Future getHomePageContent;

  SwiperDiy({this.getHomePageContent});

  @override
  _SwiperDiyState createState() => _SwiperDiyState();
}

class _SwiperDiyState extends State<SwiperDiy> {
  List swiperDateList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: widget.getHomePageContent,
              builder: (context, snaphot) {
                if(snaphot.hasData){
                  if(index==0){
                    return FadeInImage.assetNetwork(
                      placeholder: 'assets/img/bg_swiper.png',
                      image: 'http://d-pic-image.yesky.com/' + snaphot.data,
                      imageScale: 1.0,
                      fit: BoxFit.cover,
                      fadeInCurve: Curves.easeInSine,
                    );
                  }else if(index==1){
                    return Image.asset(
                      'assets/images/yanxi3.jpg',
                      fit: BoxFit.fill,
                    );
                  }else{
                    return Image.asset(
                      'assets/images/yanxi2.jpg',
                      fit: BoxFit.cover,
                    );
                  }
                }else{
                  return Image.asset(
                    'assets/images/yanxi3.jpg',
                    fit: BoxFit.cover,
                  );
                }
              },
            );
          },
          itemCount: 1,
          pagination: SwiperPagination(),
          autoplay: true,
        ));
  }
}

