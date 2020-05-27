import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/student_method.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:course_app/widget/text_widget.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'classwork_stu_details_page.dart';

///学生作业界面
class ClassWorkStudentPage extends StatefulWidget {
  final courseId;
  final teacherId;
  final userId;

  ClassWorkStudentPage(
      {Key key,
      @required this.courseId,
      @required this.teacherId,
      @required this.userId})
      : super(key: key);

  @override
  _ClassWorkStudentPageState createState() => _ClassWorkStudentPageState();
}

class _ClassWorkStudentPageState extends State<ClassWorkStudentPage> {
  List data = [];
  List allData = [];
  bool isLoading = true;

  getDataList() async {
    var result = await StudentMethod.getClassWorkListByStudent(
        context, widget.courseId, widget.userId);
    if (result != null) {
      allData.addAll(result);
      data.addAll(result);
      // data = allData;
      //print(data);
    }
    setState(() {
      isLoading = false;
    });
  }

  onRefresh() async {
    var result = await StudentMethod.getClassWorkListByStudent(
        context, widget.courseId, widget.userId);
    allData.clear();
    data.clear();
    if (result != null) {
      allData.addAll(result);
      data.addAll(result);
    }
    setState(() {
      isLoading = false;
    });
  }

  int cupertinoTabBarValue = 0;

  int cupertinoTabBarValueGetter() {
    return cupertinoTabBarValue;
  }

  changeCurrentData(int status) {
    debugPrint('changeCurrentData , $status');
    if (status == 0) {
      data.clear();
      data.addAll(allData);
    } else if (status == 1) {
      data.clear();
      allData.forEach((element) {
        print(element);
        if (1 == element['status'] || 2 == element['status']) {
          data.add(element);
        }
      });
    } else if (status == 2) {
      data.clear();
      allData.forEach((element) {
        if (3 == element['status']) {
          data.add(element);
        }
      });
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
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: ScreenUtil.screenWidth,
          height: 50,
          child: CupertinoTabBar(
            Colors.blueAccent,
            Colors.lightBlueAccent,
            [
              Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '全部',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '已提交',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '未提交',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
            cupertinoTabBarValueGetter,
            (index) {
              setState(
                () {
                  changeCurrentData(index);
                  cupertinoTabBarValue = index;
                },
              );
            },
            useSeparators: true,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: (isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : EasyRefresh.custom(
                header: BallPulseHeader(backgroundColor: Colors.purple),
                onRefresh: () async {
                  await onRefresh();
                  changeCurrentData(cupertinoTabBarValue);
                },
                emptyWidget: (data.isEmpty)
                    ? NoDataWidget(
                        title: '教师还没有发布作业~', path: 'assets/img/nodata2.png')
                    : null,
                slivers: <Widget>[
                    SliverSafeArea(
                      //安全区
                      sliver: SliverPadding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                        sliver: SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
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
    bool end = false;
    DateTime dateTime = DateTime.tryParse(dataSource['createTime']);
    if (dateTime != null) {
      var temp = dateTime.add(Duration(minutes: dataSource['expireTime']));
      if (temp.isBefore(DateTime.now())) {
        end = true;
      }
      endTime = temp.toString().substring(0, 19);
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
                              (end) ? ' 已截止' : '截止时间: ${endTime}',
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
                                  builder: (_) => ClassworkStuDetailPage(
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
