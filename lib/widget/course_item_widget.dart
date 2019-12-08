import 'package:course_app/config/constants.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/test/test_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///课堂项
class CourseItemWidget extends StatelessWidget {
  final Course item;

  CourseItemWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(330),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          _headItem(
            context,
            title: item.title,
            joincode: item.joincode,
            semester: item.semester,
            start: item.start,
            end: item.end,
            courseId: item.course_id,
          ),
          leadingItem(context, url: item.head_urls, nums: item.nums)
        ],
      ),
    );
  }

  //点击底部更多
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
    String courseId,
    var start,
    var end,
    var semester,
  }) {
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(200),
        //margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/bg_swiper.png',
                ),
                fit: BoxFit.cover),
            color: Colors.blueAccent,
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
        Application.router.navigateTo(context, Routes.classRoomPage,);
      },
    );
  }

  ///底部
  Widget leadingItem(BuildContext context,
      {@required List<String> url, @required int nums}) {
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
          _imageCount(url, nums),
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

  ///头像和人数
  Widget _imageCount(List<String> url, int nums) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Image.network(url[0]),
            minRadius: 10,
            maxRadius: 10,
          ),
          CircleAvatar(
            child: Image.network(url[1]),
            minRadius: 10,
            maxRadius: 10,
          ),
          CircleAvatar(
            child: Image.network(url[2]),
            minRadius: 10,
            maxRadius: 10,
          ),
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
