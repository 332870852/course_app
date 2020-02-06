import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/bottom_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';

///公告详情页
class AnnouncementContentPage extends StatelessWidget {
  AnnouncementContentPage(
      {Key key,
      @required this.announceId,
      @required this.announceTitle,
      @required this.username,
      @required this.announceText,
      this.date,
      this.commentNum = 0,
      this.readedNum = 0,
      this.annex})
      : super(key: key);
  final String announceId;
  final String announceTitle;
  final String username;
  final String announceText;
  final String date;
  num readedNum;
  num commentNum;
  String annex;

  @override
  Widget build(BuildContext context) {
    //TODO 获取评论
    UserMethod.getReplyListPage(
        announceId, Provide.value<UserProvide>(context).userId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${announceTitle}',
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[],
      ),
      body: body(context),
    );
  }

  ///首部
  Widget body(context) {
    String userHeadUrl =
        Provide.value<UserProvide>(context).tacherInfo.faceImage;
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(Constants.DividerColor),
                  width: Constants.DividerWith))),
      child: body_cont(userHeadUrl),
    );
  }

  Widget body_cont(String url) {
    return Card(
      //aspectRatio: 16 / 12,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color: Color(Constants.DividerColor),
                      width: Constants.DividerWith))),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${announceTitle}',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: (url != null)
                      ? NetworkImage('${url}')
                      : AssetImage('assets/img/user.png'),
                ),
                title: Text(
                  '${username}',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('${date}'),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(40), color: Colors.black),
                    text: '${announceText}'),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
              ('${annex}'.trim().isNotEmpty)
                  ? Flexible(
                      flex: 7,
                      child: InkWell(
                        onTap: () {
                          //TODO 点击图片
                          if (annex != null && annex.isNotEmpty) {
                            ImagePickers.previewImage(annex);
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: ''
                              '${annex}',
                          placeholder: (context, url) {
                            return SpinKitFadingFour(
                              color: Colors.grey,
                            );
                          },
                          errorWidget:
                              (BuildContext context, String url, Object error) {
                            //print("assets/img/加载失败.png        ${url}");
                            return Image.asset('assets/img/加载失败.png');
                          },
                          cacheManager: DefaultCacheManager(),
                        ),
                      ),
                    )
                  : SizedBox(),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton.icon(
                        onPressed: () {
                          //TODO 点击评论
                          debugPrint("点击评论");
                        },
                        icon: Icon(
                          Icons.comment,
                          //color: Colors.blue,
                        ),
                        label: Text(
                          '${commentNum}条评论',
                          style: TextStyle(color: Colors.blue),
                        )),
                    Flexible(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Chip(
                          label: Text('${readedNum}人已读'),
                          elevation: 5.0,
                          avatar: Icon(
                            Icons.remove_red_eye,
                          ),
                          deleteIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          shadowColor: Colors.black,
                          // backgroundColor: Colors.white,
                          onDeleted: () {
                            //TODO 查看浏览人数
                            print("查看浏览人数");
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              Divider(
                color: Color(
                  Constants.DividerColor,
                ),
                height: 5,
                indent: 10,
                thickness: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _openModalBottomSheet(context, {@required String announceId}) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 160.0,
            child: Column(
              children: <Widget>[
                bottomItem(context, '编辑公告', 0),
                bottomItem(context, '删除公告', 1),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                bottomItem(context, '取消', 2),
              ],
            ),
          );
        });
    print(option);
    switch (option) {
      case 0:
        {
          ///
          break;
        }
      case 1:
        {
          break;
        }
    }
  }
}
