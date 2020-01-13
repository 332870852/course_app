import 'package:course_app/model/Course.dart';
import 'package:course_app/widget/course_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';

///课堂首页老师创建课程显示页
class CreateCourseWidget extends StatefulWidget {
  EasyRefreshController controller;
  final List<Course> courseList;
  OnRefreshCallback onRefresh;
  OnLoadCallback onLoad;
  final int role; //1-学生版界面，2-教师版界面，默认学生
  CreateCourseWidget(
      {Key key,
      @required this.courseList,
      @required this.role,
      this.onLoad,
      this.onRefresh,
      this.controller})
      : super(key: key);

  @override
  _CreateCourseWidgetState createState() => _CreateCourseWidgetState();
}

class _CreateCourseWidgetState extends State<CreateCourseWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      controller: widget.controller,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return CourseItemWidget(item: widget.courseList[index],role: widget.role,);
        }, childCount: widget.courseList.length)),
      ],
      emptyWidget: (widget.courseList.length < 1)
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
      onRefresh: widget.onRefresh,
      onLoad: widget.onLoad,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
