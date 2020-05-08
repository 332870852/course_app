import 'package:course_app/router/navigatorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///课堂测试
class TestPage extends StatelessWidget {
  final String courseId;
  final String teacherId;

  TestPage({Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  var project = {
    'id': 1,
    'exercise_title': '第一次数据库',
    'release_time': '2020-01-19',
    'deadline_time': '2020-02-01',
    'isEnd': true,
    'isTest': true,
    'submitted': 8,
    'unsubmitted': 2,
    'status': 1,
    'publisher': '123'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('课堂测试'),
        elevation: 0.0,
      ),
      endDrawer: Builder(
          builder: (_) => Drawer(
                child: Container(),
              )),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Stack(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 18.0),
              padding: const EdgeInsets.only(bottom: 45.0, top: 5),
              child: EasyRefresh.custom(
                header: MaterialHeader(),
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return testItem(
                      context,
                      item: project,
                    );
                  }, childCount: 35)),
                ],
                emptyWidget: (false)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/img/nodata2.png'),
                          Text(
                            '暂无数据',
                            style: TextStyle(color: Colors.blue.shade200),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 45,
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top:
                                BorderSide(color: Colors.black26, width: 2.0))),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.border_color,
                            color: Colors.blue,
                          ),
                          Text(
                            '发布课堂测试',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      onTap: () async {
                        //todo
                        final option = await showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Container(
                                width: ScreenUtil.screenWidth,
                                height: 150,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    releaseBtn('assets/img/create.png',
                                        title: '创建试题模', onTap: () {
                                      Navigator.pop(context, 0);
                                    }),
                                    releaseBtn('assets/img/muban.png',
                                        title: '模板中导入', onTap: () {
                                      Navigator.pop(context, 1);
                                    }),
                                    releaseBtn('assets/img/questionList.png',
                                        title: '试题集导入', onTap: () {
                                      Navigator.pop(context, 2);
                                    }),
                                  ],
                                ),
                              );
                            });
                        if (option == 0) {
                          //创建模板
                          NavigatorUtil.goCreateTestPage(context,
                              courseId: courseId);
                        }
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget releaseBtn(img, {title, onTap}) {
    return Expanded(
        child: InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('${img}'),
            maxRadius: 30,
            minRadius: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text('${title}'),
          ),
        ],
      ),
      onTap: onTap,
    ));
  }

  Widget testItem(
    context, {
    @required item,
  }) {
    return Container(
        //padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        margin: const EdgeInsets.only(top: 8),
        child: Ink(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: labelItem(isTest: item['isTest']),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          '${item['exercise_title']}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            item['isEnd'] ? '已截止' : '未截止',
                            style: TextStyle(color: Colors.black26),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                          )
                        ],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 2),
                      alignment: Alignment.bottomLeft,
                      child: Text('发布时间: ${item['release_time']}'),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              //todo
              NavigatorUtil.goTestDetailPage(context,
                  pageTitle: item['exercise_title'],
                  releaseTime: item['release_time'],
                  endTime: item['deadline_time'],
                  submitted: item['submitted'],
                  unsubmitted: item['unsubmitted']);
            },
          ),
        ));
  }

  Widget labelItem({bool isTest = true}) {
    ///1-练习，2-测试
    return Container(
      margin: const EdgeInsets.only(left: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: isTest ? Colors.red : Colors.green)),
      child: Text(
        (isTest) ? '测试' : '练习',
        style: TextStyle(color: (isTest) ? Colors.red : Colors.green),
      ),
    );
  }
}
