import 'package:course_app/model/Course.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/teacher/course_teacher_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/widget/course_item_widget.dart';
import 'package:course_app/widget/create_course_widget.dart';
import 'package:course_app/widget/pop_buttom_index_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provide/provide.dart';

class IndexTeacherPage extends StatelessWidget {
  EasyRefreshController _joincontroller = EasyRefreshController();
  EasyRefreshController _createcontroller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('全部课程'),
          actions: <Widget>[
            Index_popButtom(context),
          ],
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 60,
              color: Colors.grey.shade300,
              child: TabBar(
                unselectedLabelColor: Colors.white,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Theme.of(context).primaryColor,
                indicatorWeight: 1.0,
                tabs: <Widget>[
                  Tab(
                    text: '创建的课程',
                  ),
                  Tab(
                    text: '加入的课程',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  ///我创建的课程
                  Provide<CourseTeacherProvide>(
                      builder: (context, child, data) {
                    print(
                        "CourseTeacherProvide 6666666   ${data.courseList.length}");
                    return CreateCourseWidget(
                      courseList: data.courseList,
                      controller: _createcontroller,
                      onRefresh: ()=>createRefresh(context),
                      onLoad: ()=>createOnLoad(context),
                    );
                  }),

                  ///我加入的课程
                  Provide<CourseProvide>(builder: (context, child, data) {
                    print("CourseProvide 6666666   ${data.courseList.length}");
                    return CreateCourseWidget(
                      courseList: data.courseList,
                      controller: _joincontroller,
                      onRefresh: ()=>joinRefresh(context),
                      onLoad: ()=>joinOnLoad(context),
                    );
//                    return _ProvideData(
//                        _joincontroller, data.courseList, context,
//                        onRefresh: () => joinRefresh(context),
//                        onLoad: () => joinOnLoad(context));
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///创建的课程
  Widget _ProvideData(
      EasyRefreshController controller, List<Course> courseList, context,
      {OnRefreshCallback onRefresh, OnLoadCallback onLoad}) {
    return EasyRefresh.custom(
      controller: controller,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return CourseItemWidget(item: courseList[index]);
        }, childCount: courseList.length)),
      ],
      emptyWidget: (courseList.length < 1)
          ? Center(
              child: Text('暂时没有数据'),
            )
          : null,
      firstRefresh: true,
      //headerIndex: Provide.value<CourseProvide>(context).curssor.offset,
      header: MaterialHeader(),
      footer: ClassicalFooter(
        bgColor: Colors.white,
        textColor: Theme.of(context).primaryColor,
        loadingText: '正在加载...',
        loadedText: '下拉加载',
        noMoreText: '没有更多了',
        loadReadyText: '释放立即刷新',
        loadText: '上拉加载',
        loadFailedText: '加载失败',
      ),
      onRefresh: onRefresh,
      onLoad: onLoad,
    );
//    return Provide<CourseProvide>(builder: (context, child, data) {
////      if (data.courseList.length > 0) {
//      print("6666666   ${data.courseList.length}");
//
//    });
  }

  ///join- fresh
  joinRefresh(context) async {
    await Provide.value<CourseProvide>(context)
        .student_getCoursePage(Provide.value<UserProvide>(context).userId)
        .whenComplete(() async {
      _joincontroller.finishRefresh(success: true);
      _joincontroller.resetLoadState();
    }).catchError((onError) {
      _joincontroller.finishRefresh(success: false);
    });
  }

  ///join-onLoad
  joinOnLoad(context) async {
    Provide.value<CourseProvide>(context).increatePage();
    bool flag = await Provide.value<CourseProvide>(context)
        .getMoreCourseList(Provide.value<UserProvide>(context).userId,
            pageSize: 5)
        .catchError((onError) {
      ///加载出现异常
      _joincontroller.finishLoad(success: false);
      Provide.value<CourseProvide>(context).decreatelPage();
      return;
    });
    //print(flag);
    if (flag == false) {
      ///没有更多
      Provide.value<CourseProvide>(context).decreatelPage();
      _joincontroller.finishLoad(success: true, noMore: true);
    } else {
      ///加载出更多数据
      _joincontroller.finishLoad(success: true, noMore: false);
    }
  }

  /// create-fresh
  createRefresh(context) async {
    await Provide.value<CourseTeacherProvide>(context)
        .teacher_getCoursePage(Provide.value<UserProvide>(context).userId)
        .whenComplete(() async {
      _createcontroller.finishRefresh(success: true);
      _createcontroller.resetLoadState();
    }).catchError((onError) {
      _createcontroller.finishRefresh(success: false);
    });
  }

  ///join-onLoad
  createOnLoad(context) async {
    Provide.value<CourseTeacherProvide>(context).increatePage();
    bool flag = await Provide.value<CourseTeacherProvide>(context)
        .getMoreCourseList(Provide.value<UserProvide>(context).userId,
            pageSize: 5)
        .catchError((onError) {
      ///加载出现异常
      _createcontroller.finishLoad(success: false);
      Provide.value<CourseTeacherProvide>(context).decreatelPage();
      return;
    });
    //print(flag);
    if (flag == false) {
      ///没有更多
      Provide.value<CourseTeacherProvide>(context).decreatelPage();
      _createcontroller.finishLoad(success: true, noMore: true);
    } else {
      ///加载出更多数据
      _createcontroller.finishLoad(success: true, noMore: false);
    }
  }
}
