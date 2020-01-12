import 'package:course_app/config/constants.dart';
import 'package:course_app/pages/teacher/indext_teacher_page.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/widget/course_item_widget.dart';
import 'package:course_app/widget/create_course_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:course_app/config/service_url.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<UserProvide>(
      builder: (context, child, data) {
        if (data.role == 3) {
          ///学生界面
          return IndexstudentPage();
        } else {
          return IndexTeacherPage();
        }
      },
    );
  }

  ///学生页面
  Widget IndexstudentPage() {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('全部课程'),
        actions: <Widget>[
          _popButtom(context),
        ],
        elevation: 0.0,
      ),
      body: Provide<CourseProvide>(builder: (context, child, data) {
        print("CourseProvide 6666666   ${data.courseList.length}");
        return CreateCourseWidget(
          courseList: data.courseList,
          controller: _controller,
          onRefresh: () => joinRefresh(context),
          onLoad: () => joinOnLoad(context),
        );
      }),
    );
  }

  ///join- fresh
  joinRefresh(context) async {
    await Provide.value<CourseProvide>(context)
        .student_getCoursePage(Provide.value<UserProvide>(context).userId)
        .whenComplete(() async {
      _controller.finishRefresh(success: true);
      _controller.resetLoadState();
    }).catchError((onError) {
      _controller.finishRefresh(success: false);
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
      _controller.finishLoad(success: false);
      Provide.value<CourseProvide>(context).decreatelPage();
      return;
    });
    //print(flag);
    if (flag == false) {
      ///没有更多
      Provide.value<CourseProvide>(context).decreatelPage();
      _controller.finishLoad(success: true, noMore: true);
    } else {
      ///加载出更多数据
      _controller.finishLoad(success: true, noMore: false);
    }
  }

  /// +
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
              Provide.value<CourseProvide>(context).code = Code.def;
              Application.router.navigateTo(context, '/join_course',
                  transition: TransitionType.inFromRight);
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

  ///底部菜单
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


  //  Widget _ProvideData() {
//    return Provide<CourseProvide>(builder: (context, child, data) {
////      if (data.courseList.length > 0) {
//      print("6666666   ${data.courseList.length}");
//      return EasyRefresh.custom(
//        controller: _controller,
//        slivers: <Widget>[
//          SliverList(
//              delegate: SliverChildBuilderDelegate((context, index) {
//            return CourseItemWidget(item: data.courseList[index]);
//          }, childCount: data.courseList.length)),
//        ],
//        emptyWidget: (data.courseList.length < 1)
//            ? Center(
//                child: Text('暂时没有数据'),
//              )
//            : null,
//        firstRefresh: true,
//        //headerIndex: Provide.value<CourseProvide>(context).curssor.offset,
//        header: MaterialHeader(),
//        footer: ClassicalFooter(
//          bgColor: Colors.white,
//          textColor: Theme.of(context).primaryColor,
//          loadingText: '正在加载...',
//          loadedText: '下拉加载',
//          noMoreText: '没有更多了',
//          loadReadyText: '释放立即刷新',
//          loadText: '上拉加载',
//          loadFailedText: '加载失败',
//        ),
//        onRefresh: () async {
//          await Provide.value<CourseProvide>(context)
//              .student_getCoursePage(Provide.value<UserProvide>(context).userId)
//              .whenComplete(() async {
//            _controller.finishRefresh(success: true);
//            _controller.resetLoadState();
//          }).catchError((onError) {
//            _controller.finishRefresh(success: false);
//          });
//          // Fluttertoast.showToast(msg: '刷新成功!');
//        },
//        onLoad: () async {
//          _getMoreList(context);
//        },
//      );
//    });
//  }

//  void _getMoreList(context) async {
//    Provide.value<CourseProvide>(context).increatePage();
////    await Future.delayed(Duration(seconds: 2), () {
////      Provide.value<CourseProvide>(context).getMoreCourseList('2',pageSize:1);
////    });
//
//    bool flag = await Provide.value<CourseProvide>(context)
//        .getMoreCourseList(Provide.value<UserProvide>(context).userId,
//            pageSize: 5)
//        .catchError((onError) {
//      ///加载出现异常
//      _controller.finishLoad(success: false);
//      Provide.value<CourseProvide>(context).decreatelPage();
//      return;
//    });
//    //print(flag);
//    if (flag == false) {
//      ///没有更多
//      Provide.value<CourseProvide>(context).decreatelPage();
//      _controller.finishLoad(success: true, noMore: true);
//    } else {
//      ///加载出更多数据
//      _controller.finishLoad(success: true, noMore: false);
//    }
//  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///首页
//class IndexPage extends StatelessWidget {
//  // GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
//  EasyRefreshController _controller = EasyRefreshController();
//
//  @override
//  Widget build(BuildContext context) {
//    //Provide.value<CourseProvide>(context).student_getCoursePage('2');
//    return Scaffold(
//        backgroundColor: Colors.grey.shade200,
//        appBar: AppBar(
//          title: Text('全部课程'),
//          actions: <Widget>[
//            _popButtom(context),
//          ],
//          elevation: 0.0,
//        ),
//        body: FutureBuilder(
//          //TODO userId
//            future: Provide.value<CourseProvide>(context)
//                .student_getCoursePage('2'),
//            builder: (context, snapshot) {
//              print(snapshot.data);
//              if (snapshot.hasData) {
//                return;
//              } else if(snapshot.connectionState==ConnectionState.waiting){
//                return Center(
//                  child: CircularProgressIndicator(strokeWidth: 1.0,),
//                );
//              }else{
//                return SizedBox();
//              }
//            }));
//  }
//
//  Widget _ProvideData() {
//    return Provide<CourseProvide>(builder: (context, child, data) {
//      if (data.courseList.length > 0) {
//        return EasyRefresh.custom(
//          controller: _controller,
//          //enableControlFinishRefresh: true,
//          //enableControlFinishLoad: true,
//          slivers: <Widget>[
//            SliverList(
//                delegate: SliverChildBuilderDelegate((context, index) {
//              return CourseItemWidget(item: data.courseList[index]);
//            }, childCount: data.courseList.length)),
//          ],
//          firstRefresh: true,
//          //headerIndex: Provide.value<CourseProvide>(context).curssor.offset,
//          header: MaterialHeader(),
//          footer: ClassicalFooter(
//            bgColor: Colors.white,
//            textColor: Theme.of(context).primaryColor,
//            loadingText: '正在加载...',
//            loadedText: '下拉加载',
//            noMoreText: '没有更多了',
//            loadReadyText: '释放立即刷新',
//            loadText: '上拉加载',
//            loadFailedText: '加载失败',
//          ),
//          onRefresh: () async {
//             await Provide.value<CourseProvide>(context)
//                .student_getCoursePage('2');
//            await _controller.finishRefresh(success: true);
//           // Fluttertoast.showToast(msg: '刷新成功!');
//          },
//          onLoad: () async {
//            _getMoreList(context);
//          },
//        );
//      } else {
//        return Center(
//          child: Text('暂时没有数据'),
//        );
//      }
//    });
//  }
//
//  /// +
//  Widget _popButtom(context) {
//    return PopupMenuButton(
//      offset: Offset(2, 100),
//      color: Colors.white.withOpacity(0.5),
//      itemBuilder: (BuildContext context) {
//        return <PopupMenuItem<String>>[
//          PopupMenuItem(
//            child:
//                _buildPopupMenuItem(0xe62f, "加入课程", color: Colors.blueAccent),
//            value: "join_course",
//          ),
//          PopupMenuItem(
//            child:
//                _buildPopupMenuItem(0xe606, "课程排序", color: Colors.blueAccent),
//            value: "sort_course",
//          ),
//          PopupMenuItem(
//            child: _buildPopupMenuItem(0xe60a, "扫一扫", color: Colors.blueAccent),
//            value: "saoyisao",
//          ),
//        ];
//      },
//      icon: Icon(Icons.add),
//      //(Icons.add),
//      onSelected: (String selected) {
//        switch (selected) {
//          case 'join_course':
//            {
//              Provide.value<CourseProvide>(context).code = Code.def;
//              Application.router.navigateTo(context, '/join_course',
//                  transition: TransitionType.inFromRight);
//              break;
//            }
//          case 'sort_course':
//            {
//              break;
//            }
//          case 'saoyisao':
//            {
//              break;
//            }
//        }
//        print("点击的是$selected");
//      },
//    );
//  }
//
//  ///底部菜单
//  _buildPopupMenuItem(int iconName, String title, {Color color}) {
//    return Row(
//      children: <Widget>[
//        CircleAvatar(
//          child: Icon(
//            IconData(iconName, fontFamily: Constants.IconFontFamily),
//            color: color,
//            size: ScreenUtil().setSp(40),
//          ),
//          maxRadius: ScreenUtil().setSp(30),
//          backgroundColor: Colors.blue.shade100,
//        ),
//        SizedBox(
//          width: 12.0,
//        ),
//        Text(title)
//      ],
//    );
//  }
//
//
//  void _getMoreList(context)async{
//     Provide.value<CourseProvide>(context).increatePage();
////    await Future.delayed(Duration(seconds: 2), () {
////      Provide.value<CourseProvide>(context).getMoreCourseList('2',pageSize:1);
////    });
//    await Provide.value<CourseProvide>(context).getMoreCourseList('2',pageSize:1).then((onValue){
//      if(onValue==false){
//        print(onValue);
//        Provide.value<CourseProvide>(context).decreatelPage();
//      }
//    });
//  }
//
//
//}
