import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/pages/revise_page.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:course_app/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weui/image_preview/index.dart';
import 'package:weui/picker_view/index.dart';
import 'package:async/async.dart';

///教师管理作业

class ClassworkDetalPage extends StatefulWidget {
  Map dataSource;
  final endTime;

  ClassworkDetalPage({Key key, @required this.dataSource, this.endTime = ''})
      : super(key: key);

  @override
  _ClassworkDetalPageState createState() => _ClassworkDetalPageState();
}

class _ClassworkDetalPageState extends State<ClassworkDetalPage> {
  List<String> annex = [];
  List students = [];
  AsyncMemoizer<List<Widget>> _memoizer;
  List<UserInfoVo> _studentInfo = [];

  Future<List<Widget>> getStudentData(List userIds) async {
    debugPrint('getStudentData :  ${userIds}');
    if (ObjectUtil.isEmpty(userIds)) return List<Widget>();

    ///get
    List<String> studentIds = [];
    students.forEach((element) {
      studentIds.add(element['studentId'].toString());
    });
    var result = await UserMethod.getStudentInfo(context, studentIds);

    ///
    List<Widget> list = [];
    if (result != null) {
      studentIds.forEach((ele) {
        print(result);
        int index =
            result.indexWhere((element) => element.userId.toString() == ele);
        int ind = students.indexWhere((element) => element['studentId'] == ele);
        list.add(getWidget(userInfoVo: result[index], map: students[ind]));
//        print(list);
      });
    }
    // print('----------${list}');
    _studentInfo = result;
    return list;
  }

  List<Widget> changeCurrentList(int status) {
    List<String> studentIds = [];
    students.forEach((element) {
      if (status == element['status']) {
        studentIds.add(element['studentId'].toString());
      }
    });
    List<Widget> list = [];
    studentIds.forEach((ele) {
      int index = _studentInfo
          .indexWhere((element) => element.userId.toString() == ele);
      int ind = students.indexWhere((element) => element['studentId'] == ele);
      list.add(getWidget(userInfoVo: _studentInfo[index], map: students[ind]));
    });
    return list;
  }

  ///获取网络学生资料
  Widget getWidget({UserInfoVo userInfoVo, Map map}) {
    var status = map['status'];
    String tip = '';
    if (status == 0 || status == 2 || status == 3) {
      tip = '查看';
    } else if (status == 1) {
      tip = '批改';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: CircleAvatar(
                  backgroundImage:
                      (ObjectUtil.isEmptyString('${userInfoVo.faceImage}'))
                          ? AssetImage('assets/img/user.png')
                          : CachedNetworkImageProvider(
                              '${userInfoVo.faceImage}',
                              cacheManager: DefaultCacheManager()))),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${userInfoVo.identityVo.realName}',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          Flexible(
              flex: 2,
              child: FlatButton(
                  onPressed: () {
                    //todo
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RevisePage(
                                  teacher: true,
                                  status: status,
                                  endTime: widget.endTime,
                                  tscore: widget.dataSource['score'],
                                  map: map,
                                )));
                  },
                  visualDensity: VisualDensity.standard,
                  color: Colors.green.withOpacity(0.1),
                  child: Text(
                    tip,
                    style: TextStyle(color: Colors.blueAccent),
                  ))),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    students = widget.dataSource['reviseClassWorkList'];
    annex = widget.dataSource['annex'].cast<String>();
    _memoizer = new AsyncMemoizer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dataSource['title']}'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: ListView(
          children: <Widget>[
            head(context),
            wear(context),
            display(context),
          ],
        ),
      ),
    );
  }

  Widget head(
    context,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 350,
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black26, width: 1.0))),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MyTextAnimate(
                              text: '${widget.dataSource['title']}',
                              colors: [
                                Colors.blueAccent,
                                Colors.greenAccent,
                                Colors.blueAccent
                              ],
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w500),
                            ),
//                            Text(
//                              '${widget.dataSource['title']}',
//                              maxLines: 2,
//                              style: TextStyle(
//                                  fontSize: 23, fontWeight: FontWeight.w500),
//                              overflow: TextOverflow.ellipsis,
//                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '截止时间: ${widget.endTime}',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black26),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2)),
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.dataSource['score']}(分)',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            Flexible(
                flex: 6,
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(
                            text: '${widget.dataSource['content']}'));
                        Fluttertoast.showToast(msg: '内容已复制到粘贴栏');
                      },
                      child: Text(
                        '${widget.dataSource['content']}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    (annex.isNotEmpty)
                        ? ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 100,
                              maxWidth: ScreenUtil.screenWidth,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: PageView(
                                children: annex
                                    .map((e) {
                                      return GestureDetector(
                                        onTap: () {
                                          weImagePreview(context)(
                                              images: annex,
                                              defaultIndex: annex.indexWhere(
                                                  (element) => element == e));
                                        },
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/img/图片加载中.png',
                                          image: '${e}',
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    })
                                    .toList()
                                    .cast<Widget>(),
                              ),
                            ))
                        : Container(),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  int cupertinoTabBarValue = 0;

  int cupertinoTabBarValueGetter() {
    return cupertinoTabBarValue;
  }

  Widget wear(context) {
    return Container(
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
                  '待批改',
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
                  '已批改',
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
              cupertinoTabBarValue = index;
            },
          );
        },
        useSeparators: true,
      ),
    );
  }

  Widget display(context) {
    if (students.isEmpty) {
      return NoDataWidget(title: '暂无课堂学生记录~', path: 'assets/img/nodata2.png');
    }
    if (cupertinoTabBarValue == 0) {
      return FutureBuilder(future: _memoizer.runOnce(() async {
        debugPrint('_memoizer ${students}');
        return await getStudentData(students);
      }), builder: (_, sna) {
        if (sna.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        List list = sna.data;
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (_, index) {
              return list[index];
            });
      });
    } else {
      //print('uuuuuuuuu');
      var list = changeCurrentList(cupertinoTabBarValue);
      //print('uuuuuuuuu  ${list.length}');
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (_, index) {
            return list[index];
          });
    }
  }
}
