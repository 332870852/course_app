import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///首页轮播图

class SwiperDiy extends StatefulWidget {
  final Future getHomePageContent;
  final double height;

  SwiperDiy({this.getHomePageContent, this.height = 200});

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
    ///初始化尺寸
    return Container(
        //padding: EdgeInsets.only(left: 5, right: 5),
        margin: EdgeInsets.only(left: 5, right: 5),
        height: widget.height,
        width: ScreenUtil.screenHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.red
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: widget.getHomePageContent,
              builder: (context, snaphot) {
                if (snaphot.hasData) {
                  if (index == 0) {
                    return Container(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/bg_swiper.png',
                        image:
                            'http://pic31.nipic.com/20130730/789607_232633343194_2.jpg',
                        imageScale: 1.0,
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.easeInSine,
                      ),
                    );
                  } else if (index == 1) {
                    return Image.asset(
                      'assets/bgk/bgk0.jpg',
                      fit: BoxFit.fill,
                    );
                  } else {
                    return Image.asset(
                      'assets/bgk/bgk1.jpg',
                      fit: BoxFit.cover,
                    );
                  }
                } else {
                  return Image.asset(
                    'assets/bgk/bgk0.jpg',
                    fit: BoxFit.cover,
                  );
                }
              },
            );
          },
          itemCount: 3,
          pagination: SwiperPagination(alignment: Alignment.bottomCenter),
          autoplay: true,
          scrollDirection: Axis.horizontal,
        ));
  }
}

/*
FutureBuilder(
          future: widget.getHomePageContent,
          builder: (context, snaphot) {
            if (snaphot.hasData) {
              return Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return FadeInImage.assetNetwork(
                    placeholder: 'assets/img/bg_swiper.png',
                    image: serviceUrl + servicePath['meinu'],
                    imageScale: 1.0,
                    fit: BoxFit.cover,
                  );
                },
                itemCount: 1,
                pagination: SwiperPagination(),
                autoplay: true,
              );
            } else {
              return Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    'assets/img/bg_swiper.png',
                    fit: BoxFit.cover,
                  );
                },
                itemCount: 3,
                pagination: SwiperPagination(),
                autoplay: true,
              );
            }
          }),
 */
