import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';

import 'classwork_create_page.dart';
import 'classwork_detial_page.dart';

///课堂作业
class ClassworkPage extends StatefulWidget {
  final courseId;
  final teacherId;

  ClassworkPage({Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  _ClassworkPageState createState() => _ClassworkPageState();
}

class _ClassworkPageState extends State<ClassworkPage> {
  bool isAdmin;

  List data = [];

  getDataList() async {
    var result = await TeacherMethod.getClassWorkList(
        context, widget.courseId, widget.teacherId);
    if (result != null) {
      setState(() {
        data = result;
      });
      print(data);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataList();
  }

  @override
  Widget build(BuildContext context) {
    isAdmin = (Provide.value<UserProvide>(context).userId == widget.teacherId);
    return Scaffold(
      appBar: AppBar(
        title: Text((isAdmin) ? '作业管理' : '作业'),
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //todo
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ClassWorkCreatePage(
                        courseId: widget.courseId,
                      )));
          if (result != null) {
            setState(() {
              print(data);
              data.insert(0,result);
            });
          }
        },
        child: Icon(
          CupertinoIcons.create,
          size: 30,
        ),
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: EasyRefresh.custom(
            header: BallPulseHeader(backgroundColor: Colors.purple),
            onRefresh: () async {},
            emptyWidget: (data.isEmpty)
                ? NoDataWidget(
                    title: '还没有发布作业~', path: 'assets/img/nodata2.png')
                : null,
            slivers: <Widget>[
              SliverSafeArea(
                //安全区
                sliver: SliverPadding(
                  padding: EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return cardItem(context, dataSource: data[index]);
                  }, childCount: data.length)),
                ),
              ),
            ]),
      ),
    );
  }

  Widget cardItem(context, {dataSource}) {
    var endTime = '';
    DateTime dateTime = DateTime.tryParse(dataSource['createTime']);
    if (dateTime != null) {
      endTime = dateTime
          .add(Duration(minutes: dataSource['expireTime']))
          .toString()
          .substring(0, 19);
    }

    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(2.0),
      width: ScreenUtil.screenWidth,
      height: 250,
//      decoration: BoxDecoration(
//        color: Colors.white,
//        borderRadius: BorderRadius.all(Radius.circular(8.0)),
//      ),
      child: Card(
          elevation: 1.0,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${dataSource['createTime']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          '${dataSource['title']}',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          '${dataSource['content']}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ))
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              border: Border.all(
                                  color: Colors.blue.withOpacity(0.5),
                                  width: 1.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '截止时间: ${endTime}',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          )),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Colors.greenAccent, width: 1.0)),
                      child: InkWell(
                        onTap: () {
                          //todo
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ClassworkDetalPage(
                                        dataSource: dataSource,
                                        endTime: endTime,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '查看',
                              style: TextStyle(
                                  wordSpacing: 2.0,
                                  color: Colors.greenAccent,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
