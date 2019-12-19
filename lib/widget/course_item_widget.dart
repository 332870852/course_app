import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

///课堂项
class CourseItemWidget extends StatelessWidget {
  final Course item;

  CourseItemWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("999*08454");
//    Provide.value<UserProvide>(context).getUserHeadImage(item.userIdSet).then((onValue){
//      List<UserHeadImage> userImageList=
//    });
    return Container(
      height: ScreenUtil().setHeight(330),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          _headItem(
            context,
            title: item.title,
            bgkColor: item.bgkColor,
            bgkUrl: item.bgkUrl,
            joincode: item.joincode,
            semester: item.semester,
            start: item.start,
            end: item.end,
            courseId: item.courseNumber,
          ),
          leadingItem(context, nums: item.member)
        ],
      ),
    );
  }

  ///点击底部更多
  Future _openModalBottomSheet(context) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 160.0,
            child: Column(
              children: <Widget>[
                _bottomItem(context, '置顶课程', 0),
                _bottomItem(context, '退出课程', 1),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                _bottomItem(context, '取消', 2),
              ],
            ),
          );
        });
    print(option);
  }

  Widget _bottomItem(context, title, index) {
    return Container(
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().width,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: InkWell(
          onTap: () {
            Navigator.pop(context, index);
          },
          child: Center(
            child: Text(title),
          )),
    );
  }

  ///首部
  Widget _headItem(
    context, {
    @required String title,
    @required String joincode,
    var bgkColor,
    String bgkUrl,
    String courseId,
    var start,
    var end,
    var semester,
  }) {
    //print("color :${bgkColor}");
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(200),
        //margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  (bgkUrl != null) ? bgkUrl : '',
                  errorListener: () {
                    //TODO 背景图片
                    print('56446*******4');
                  },
                ),
                fit: BoxFit.cover),
            color: (Constants.bgkMap[bgkColor] != null)
                ? Constants.bgkMap[bgkColor]
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              (courseId != null) ? '${title}(${courseId})' : title,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(40)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _joinCodeItem(joincode),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          (start != null && end != null)
                              ? '${start}-${end}'
                              : '',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text((semester != null) ? '第${semester}学期' : '',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print('点击了${title}');
        //TODO 点击课程
        Application.router.navigateTo(
            context,
            Routes.classRoomPage +
                '?' +
                'studentNums=${item.member}'
                    '&classtitle=${Uri.encodeComponent(item.title)}'
                    '&courseNumber=${item.courseNumber}'
                    '&joinCode=${item.joincode}'
                    //  '&teacherName=${Uri.encodeComponent(item.teacherName)}'
                    //  '&teacherUrl=${(item.teacherUrl != null) ? Uri.encodeComponent(item.teacherUrl) : ''}'
                    '&teacherId=${item.teacherId}'
                    '&courseId=${item.courseId}');
      },
    );
  }

  ///底部
  Widget leadingItem(BuildContext context, {@required int nums}) {
    return Container(
      height: ScreenUtil().setHeight(100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _imageCount(context,nums,userIds: item.userIdSet),
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                //TODO  点击底部更多
                _openModalBottomSheet(context);
              }),
        ],
      ),
    );
  }

 ///头像
  CircleAvatar _circleAvatar({image}) {
    var url;
    if(image!=null){
      url=image.faceImage;
    }
    //print(url);
    return CircleAvatar(
      backgroundImage: (url != null)
          ? NetworkImage(url)
          : AssetImage('assets/img/dpic.png'),
      minRadius: 10,
      maxRadius: 10,
    );
  }

  ///头像和人数
  Widget _imageCount(context, int nums,{userIds}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          FutureBuilder(
              future: Provide.value<UserProvide>(context).getUserHeadImage(userIds),
              builder: (context, snaphot) {
                if (snaphot.hasData) {
                  Map map=snaphot.data.asMap();
                  return Row(
                    children: <Widget>[
                      _circleAvatar(image:(map[0]!=null)?map[0]:null),
                      _circleAvatar(image:(map[1]!=null)?map[1]:null),
                      _circleAvatar(image:(map[2]!=null)?map[2]:null),
                    ],
                  );
                } else {
                  return  Row(
                    children: <Widget>[
                      _circleAvatar(),
                      _circleAvatar(),
                      _circleAvatar(),
                    ],
                  );
                }
              }),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              '成员${nums}人',
            ),
          )
        ],
      ),
    );
  }

  ///加课码
  Widget _joinCodeItem(String joincode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            IconData(
              0xe608,
              fontFamily: Constants.IconFontFamily,
            ),
            color: Colors.white,
            size: ScreenUtil().setSp(35),
          ),
          Text(' 加课码${joincode}',
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(30))),
        ],
      ),
    );
  }
}
