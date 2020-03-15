import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

///推广下载app
class ShareDownLoadPage extends StatelessWidget {
  ShareDownLoadPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                    'http://p1.ifengimg.com/2019_03/5734B8507ADDBE09F4B13147D9622BE6A5AEC871_w1620_h1080.jpg',
                    cacheManager: DefaultCacheManager()),
                fit: BoxFit.cover)),
        padding: EdgeInsets.only(top: 80, left: 10, right: 10, bottom: 10),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Opacity(
              opacity: 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '智慧课堂辅助App,扫描下载',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(35),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    height: 250,
                    child: Image.network(
                        'http://47.102.97.30:11001/app/qRcode.png'),
                  ),
                  Flexible(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '下载地址:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(35),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'http://47.102.97.30:11001/app/app-release.apk',
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(35),
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '官方网址: 暂无',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '赶紧分享给小伙伴们一起使用吧!',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(35),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
