import 'package:course_app/config/constants.dart';
import 'package:course_app/provide/joincourse_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/test/test_data.dart';
import 'package:course_app/widget/course_item_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';


class IndexPage extends StatelessWidget {
  // GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    // List<Course> courses =Provide.value<JoinCourseProvide>(context).courses;
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('全部课程'),
          actions: <Widget>[
            _popButtom(context),
          ],
          elevation: 0.0,
        ),
        body: _ProvideData());
  }

  Widget _ProvideData() {
    return Provide<JoinCourseProvide>(builder: (context, child, data) {
      if (data.courses.length > 0) {
        return EasyRefresh.custom(
          controller: _controller,
          //enableControlFinishRefresh: true,
          //enableControlFinishLoad: true,
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return CourseItemWidget(item: data.courses[index]);
            }, childCount: data.courses.length)),
          ],

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
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {});
            _controller.finishRefresh(success: true);
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2), () {
              Provide.value<JoinCourseProvide>(context).getMoreCourseList();
              // _controller.finishLoad(success: true, noMore: true);
              //_controller.resetLoadState();
            });
          },
        );
      } else {
        return Text('暂时没有数据');
      }
    });
  }

  Widget _popButtom(context) {
    return PopupMenuButton(
      offset: Offset(2, 100),
      color: Colors.white.withOpacity(0.5),
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          PopupMenuItem(
            child:
                _buildPopupMenuItem(0xe62f, "加入课程", color: Colors.blueAccent),
            value: "join_course",
          ),
          PopupMenuItem(
            child:
                _buildPopupMenuItem(0xe606, "课程排序", color: Colors.blueAccent),
            value: "sort_course",
          ),
          PopupMenuItem(
            child: _buildPopupMenuItem(0xe60a, "扫一扫", color: Colors.blueAccent),
            value: "saoyisao",
          ),
        ];
      },
      icon: Icon(Icons.add),
      //(Icons.add),
      onSelected: (String selected) {
        switch (selected) {
          case 'join_course':
            {
              Provide.value<JoinCourseProvide>(context).code = Code.def;
              Application.router.navigateTo(context, '/join_course',transition: TransitionType.inFromRight);
              break;
            }
          case 'sort_course':
            {
              break;
            }
          case 'saoyisao':
            {
              break;
            }
        }
        print("点击的是$selected");
      },
    );
  }

  _buildPopupMenuItem(int iconName, String title, {Color color}) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: Icon(
            IconData(iconName, fontFamily: Constants.IconFontFamily),
            color: color,
            size: ScreenUtil().setSp(40),
          ),
          maxRadius: ScreenUtil().setSp(30),
          backgroundColor: Colors.blue.shade100,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(title)
      ],
    );
  }
}
