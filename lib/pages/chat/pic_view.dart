import 'dart:io';

import 'package:course_app/widget/bottom_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';

class ImageViewPage extends StatelessWidget {
  final bool isNetUrl;
  final String urlPath;

  ImageViewPage({Key key, @required this.isNetUrl, @required this.urlPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('view ${urlPath}  ${isNetUrl}');
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        onLongPress: () {
          //todo
          if (isNetUrl) _openModalBottomSheet(context);
        },
        child: Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          foregroundDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              image: DecorationImage(
                  image: (isNetUrl)
                      ? CachedNetworkImageProvider('${urlPath}',
                          cacheManager: DefaultCacheManager())
                      : AssetImage(
                          '${urlPath}',
                        ),
//                      : FileImage(File('${urlPath}')),
                  fit: BoxFit.cover)),
          // decoration: , //
          child: CupertinoActivityIndicator(
            radius: 30.0,
          ),
        ),
      ),
    );
  }

  Future _openModalBottomSheet(
    context,
  ) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 110.0,
            child: Column(
              children: <Widget>[
                bottomItem(context, '保存图片', 0),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                bottomItem(context, '取消', 2),
              ],
            ),
          );
        });
    debugPrint('${option}');
    switch (option) {
      case 0:
        {
          ImagePickers.saveImageToGallery(urlPath).then((onValue) {
            Fluttertoast.showToast(msg: '保存成功');
          });

          ///
          break;
        }
    }
  }
}
