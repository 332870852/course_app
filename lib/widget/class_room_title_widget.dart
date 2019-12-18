import 'package:course_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///课堂页信息头部
class ClassRoomTitleWidget extends StatelessWidget {
  final classtitle;
  final joinCode;
  final studentNums;

  ClassRoomTitleWidget(
      {Key key,
      @required this.classtitle,
      @required this.joinCode,
      @required this.studentNums})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 25, top: 40),
      child: Column(
        children: <Widget>[
          _titleBar(context, classtitle: classtitle),
          _classRommInfo(joinCode: joinCode, studentNums: studentNums),
        ],
      ),
    );
  }

  ///头部appBar
  Widget _titleBar(context, {@required classtitle}) {
    return Container(
      width: ScreenUtil().width,
      height: 50,
      //color: Colors.,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              '|',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w100),
            ),
          ),
          Container(
            //color: Colors.red,
            width: 250,
            child: Text(
              classtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(35),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  ///加课码等房间信息
  Widget _classRommInfo({@required joinCode, @required studentNums}) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 15),
      height: 30,
      //color: Colors.red,
      child: Row(
        children: <Widget>[
          _iconStrItem(
              Icon(
                IconData(
                  0xe608,
                  fontFamily: Constants.IconFontFamily,
                ),
                color: Colors.white,
                size: ScreenUtil().setSp(35),
              ),
              '加课码: ${joinCode}'),
          Text(
            ' | ',
            style: TextStyle(color: Colors.white54),
          ),
          InkWell(
            onTap: () {
              ///TODO 点击同学
              print('点击同学');
            },
            child: _iconStrItem(
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: ScreenUtil().setSp(35),
                ),
                '同学 ${studentNums}'),
          ),
          Text(
            ' | ',
            style: TextStyle(color: Colors.white54),
          ),
          InkWell(
            onTap: () {
              //TODO  点击成绩
              print('点击成绩');
            },
            child: _iconStrItem(
                Icon(
                  Icons.event_note,
                  color: Colors.white,
                  size: ScreenUtil().setSp(35),
                ),
                '成绩'),
          ),
        ],
      ),
    );
  }

  Widget _iconStrItem(Icon icon, String str) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      icon,
      Text(
        ' ' + str,
        style: TextStyle(color: Colors.white),
      )
    ]);
  }
}
