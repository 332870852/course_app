import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/widget/bottom_menu_item.dart';
import 'package:course_app/widget/user_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

///二维码名片
class QRcodePage extends StatelessWidget {
  QRcodePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(
          '二维码名片',
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(40)),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.0,
        actions: <Widget>[
          Provide<UserProvide>(builder: (context, child, data) {
            return FlatButton(
              onPressed: () {
                //TODO more
                _openQRcodeModalBottomSheet(context,
                    userInfoVo: data.userInfoVo);
              },
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            );
          }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100, left: 30, right: 30),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Provide<UserProvide>(
            builder: (context, child, data) {
              UserInfoVo userInfoVo = data.userInfoVo;
//              print("信息");
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: userItem(userInfoVo),
                  ),
                  Flexible(
                    flex: 3,
                    child: QrCodeItem(userInfoVo.cid),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      '扫描上面二维码图案,可以加我为好友',
                      style: TextStyle(color: Colors.black26),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget QrCodeItem(String cid) {
    return Container(
      // padding: EdgeInsets.all(15),
      //height: 300,
      color: Colors.white,
      child: CachedNetworkImage(
        imageUrl: '${cid}',
        placeholder: (context, url) {
          return SpinKitFadingFour(
            color: Colors.grey,
          );
        },
        cacheManager: DefaultCacheManager(),
        errorWidget: (BuildContext context, String url, Object error) {
          print("assets/img/网络失败.png ${url}");
          return Image.asset('assets/img/网络失败.png');
        },
      ),
    );
  }

  Widget userItem(UserInfoVo userInfoVo) {
    return Row(
      children: <Widget>[
        UserImageWidget(
          url: userInfoVo.faceImage,
        ),
        Text(
          '${userInfoVo.nickname}',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: (ObjectUtil.isNotEmpty(userInfoVo.sex))
              ? Image.asset(
                  (userInfoVo.sex == 0)
                      ? "assets/img/sex0.png"
                      : "assets/img/sex1.png",
                  width: 20,
                  height: 20,
                )
              : Icon(
                  Icons.fiber_manual_record,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
        ),
      ],
    );
  }

  Future _openQRcodeModalBottomSheet(context,
      {@required UserInfoVo userInfoVo}) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 210.0,
            child: Column(
              children: <Widget>[
                bottomItem(context, '保存到手机', 0),
                bottomItem(context, '刷新二维码', 1),
                bottomItem(context, '扫描二维码', 2),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                bottomItem(context, '取消', 3),
              ],
            ),
          );
        });
    print(option);
    switch (option) {
      case 0:
        {
          //TODO 保存到手机
          String path =
              await ImagePickers.saveImageToGallery('${userInfoVo.cid}');
          debugPrint(path);
          String tip = '';
          if (ObjectUtil.isEmptyString(path)) {
            tip = '保存失败';
          } else {
            tip = '保存成功';
          }
          Fluttertoast.showToast(msg: tip);
          break;
        }
      case 1:
        {
          //TODO 重置二维码
          Provide.value<UserModelProvide>(context)
              .getUserQRcode(context,update: true)
              .then((cid) {
            if (cid != null) {
              userInfoVo.cid = cid;
              Provide.value<UserProvide>(context).saveUserInfo(userInfoVo);
            }
          });
          break;
        }
      case 2:
        {
          //TODO 扫描二维码
          Fluttertoast.showToast(msg: '正在开发..');
          break;
        }
    }
  }
}
