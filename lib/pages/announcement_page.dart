import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/bottom_menu_item.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///公告页

class AnnouncementPage extends StatefulWidget {
  final String courseId;
  final String teacherId;

  AnnouncementPage({Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<AnnouncementVo> announceList = [];
  ScrollController _scrollController;
  bool display = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      //print();
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provide.value<ReplyListProvide>(context).changDisplay(true);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provide.value<ReplyListProvide>(context).changDisplay(false);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool roleDis =
        (Provide.value<UserProvide>(context).userId == widget.teacherId);
    return Provide<ReplyListProvide>(
      builder: (context, child, data) {
        announceList = data.announceList;
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text('公告'),
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
          //floatingActionButtonAnimator: ,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: (roleDis)
              ? Visibility(
                  child: FloatingActionButton(
                      child: Icon(Icons.border_color),
                      onPressed: () {
                        //TODO  创建公告
                        Application.router.navigateTo(
                            context,
                            Routes.createAnnouncePage +
                                '?courseId=${widget.courseId}');
                      }),
                  visible: data.display,
                )
              : null,
          body: Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: (announceList.isNotEmpty)
                ? ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return _bodycontent(context, announceList[index]);
                    },
                    itemCount: announceList.length,
                  )
                : Center(
                    child: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset('assets/img/zanwugg@2x.png'),
                          Text('暂无公告',
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: ScreenUtil().setSp(35),
                              )),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }


  ///
  Widget _body(context, {@required AnnouncementVo item}) {
    DateTime dateTime = DateTime.tryParse(item.date);
    String time =
        '${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}';
    UserInfoVo userInfoVo = Provide.value<UserProvide>(context).tacherInfo;
    String name = (userInfoVo.identityVo.realName != null)
        ? userInfoVo.identityVo.realName
        : userInfoVo.nickname;
    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {
            //TODO 处理点击公告项
            //item.publisherId
            Application.router.navigateTo(
                context,
                Routes.announcementContentPage +
                    '?announceId=${item.announceId}'
                        '&announceTitle=${Uri.encodeComponent('${item.announceTitle}')}'
                        '&username=${Uri.encodeComponent('${name}')}'
                        '&commentNum=${item.replyNums}'
                        '&announceText=${Uri.encodeComponent('${item.announceBody}')}'
                        '&date=${Uri.encodeComponent('${time}')}'
                        '&annex=${Uri.encodeComponent('${item.annex}')}'
                        '&readedNum=${item.readeds.length}',
                transition: TransitionType.inFromRight);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${item.announceTitle}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(35)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        //TODO
                        _openModalBottomSheet(
                          context,
                          item,
                        );
                      })
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                          text: '发布人: ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: '${name}',
                                style: TextStyle(color: Colors.blue)),
                            TextSpan(
                                text: ' 发布时间: ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: '${time}',
                                      style: TextStyle(color: Colors.blue)),
                                ]),
                          ]),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${item.announceBody}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${item.replyNums}条评论',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(25)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Text('附件: 1')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///公告内容
  Widget _bodycontent(context, AnnouncementVo item) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      padding: EdgeInsets.only(left: 10, bottom: 5, right: 5),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: _body(context, item: item),
    );
  }

  ///学生点击底部更多
  Future _openModalBottomSheet(
    context,
    AnnouncementVo item,
  ) async {
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
          //TODO 修改公告
          Application.router.navigateTo(
              context,
              Routes.createAnnouncePage +
                  '?courseId=${item.courseId}'
                      '&pageTitle=${Uri.encodeComponent('修改公告')}'
                      '&isCreatePage=false'
                      '&announceId=${item.announceId}'
                      '&announceTitle=${Uri.encodeComponent('${item.announceTitle}')}'
                      '&announceBody=${Uri.encodeComponent('${item.announceBody}')}'
                      '&fujian=${Uri.encodeComponent('${item.annex}')}');
          break;
        }
      case 1:
        {
          //TODO 删除公告
          var b = await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertionDialog(
                  title: '删除公告',
                  content: '是否确定删除公告(${item.announceTitle}),删除后将无法恢复?',
                  onOk: () {
                    Navigator.pop(context, 1);
                  },
                  onCancel: () {
                    Navigator.pop(context, 0);
                  },
                  isLoding: false,
                );
              });
          if (b == 1) {
            TeacherMethod.delAnnouncement(context,
                    announceId: item.announceId.toString(),
                    userId: Provide.value<UserProvide>(context).userId)
                .then((onValue) {
              Fluttertoast.showToast(msg: '删除成功');
              Provide.value<ReplyListProvide>(context)
                  .removeAnnouncement(item.announceId.toString());
              if(announceList.length<=3){
                Provide.value<ReplyListProvide>(context).changDisplay(true);
              }
            }).catchError((onError) {
              Fluttertoast.showToast(msg: '删除失败');
            });
          }
          break;
        }
    }
  }
}
