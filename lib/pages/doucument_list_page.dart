import 'dart:io';

import 'package:course_app/provide/doucument_page_provide.dart';
import 'package:course_app/provide/file_opt_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/test/float_button.dart';
import 'package:course_app/utils/toast_web.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provide/provide.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:course_app/utils/file_icon_util.dart';
import 'package:tip_dialog/tip_dialog.dart';

///资料页面

class DoucumentListPage extends StatefulWidget {
  final courseId;
  final teacherId;

  DoucumentListPage(
      {Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  _DoucumentListPageState createState() => _DoucumentListPageState();
}

class _DoucumentListPageState extends State<DoucumentListPage> {
  AsyncMemoizer _asyncMemoizer;

  @override
  void initState() {
    super.initState();
    _asyncMemoizer = new AsyncMemoizer();
    UserMethod.getFileInfoList(context, courseId: widget.courseId, type: 1)
        .then((value) {
      if (value != null) {
        Provide.value<DoucumentPageProvide>(context).loadFileData(value);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return ;

    return Scaffold(
      appBar: AppBar(
        title: Text('资料'),
        centerTitle: true,
        elevation: 0.0,
        leading: Provide<DoucumentPageProvide>(
          builder: (_, child, data) {
            return (!data.bottomTOF)
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    })
                : FlatButton(
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Provide.value<DoucumentPageProvide>(context)
                          .changeBottomTOF(false);
                    });
          },
        ),
        actions: <Widget>[
          Provide<DoucumentPageProvide>(builder: (_, child, data) {
            return Offstage(
              offstage: !data.bottomTOF,
              child: FlatButton(
                onPressed: () {
                  data.changeSelectAll(!data.selectAll);
                },
                child: (data.selectAll)
                    ? Text(
                        '全选',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text('全不选', style: TextStyle(color: Colors.white)),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          MenuFloatButton(
            courseId: widget.courseId,
          ),
        ],
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        padding: EdgeInsets.only(top: 8),
        child: FutureBuilder(
            future: Provide.value<DoucumentPageProvide>(context).getFileData(),
            builder: (_, fData) {
              if (fData.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator();
              }
              return Provide<DoucumentPageProvide>(builder: (_, child, data) {
                if (data.fileList.length == 0) {
                  return Center(
                    child: NoDataWidget(
                        path: 'assets/img/nodata4.png', title: '暂无文件'),
                  );
                }
                return Stack(
                  children: <Widget>[
                    EasyRefresh.custom(
                      header: MaterialHeader(),
                      onRefresh: () {
                        return null;
                      },
                      slivers: <Widget>[
                        SliverSafeArea(
                            sliver: SliverPadding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                          sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: FileItem(
                                  item: data.fileList[index],
                                  index: index,
                                ),
                              );
                            },
                            childCount: data.fileList.length,
                          )),
                        )),
                      ],
                    ),
                    Positioned(
                      child: Offstage(
                        offstage: !data.bottomTOF,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              btnItem(
                                  Icons.delete,
                                  '删除',
                                  (Provide.value<UserProvide>(context).userId ==
                                          widget.teacherId)
                                      ? () {
                                          data.deletefile(
                                              context, widget.courseId);
                                        }
                                      : null),
                              btnItem(Icons.file_download, '下载', () async {
                                List list =
                                    await Provide.value<DoucumentPageProvide>(
                                            context)
                                        .download(context);
                                Provide.value<FileOptProvide>(context)
                                    .downloadFile(context, list);
                                print(list);
                              }),
                            ],
                          ),
                        ),
                      ),
                      left: 0,
                      right: 0,
                      bottom: 0,
                    ),

                    ///tip
                    TipDialogContainer(duration: const Duration(seconds: 2)),
                  ],
                );
              });
            }),
      ),
    );
  }

  ///按钮
  Widget btnItem(IconData iconData, title, onTap) {
    return InkWell(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: (onTap != null) ? Colors.white : Colors.black26,
            ),
            Text(
              '${title}',
              style: TextStyle(
                color: (onTap != null) ? Colors.white : Colors.black26,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

class FileItem extends StatelessWidget {
  var item;
  final index;

  FileItem({Key key, @required this.index, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selTOF = Provide.value<DoucumentPageProvide>(context).bottomTOF;
    String size = '';
    if (item['fsize'] < 1000000) {
      size = '${item['fsize'] / 1000}Kb';
    } else {
      size = '${item['fsize'] / 1000000}Mb';
    }

    return ListTile(
      onTap: () async {
        if (Provide.value<DoucumentPageProvide>(context).bottomTOF) {
          item['select'] = !item['select'];
          Provide.value<DoucumentPageProvide>(context)
              .changeFileList(index, item);
          Provide.value<DoucumentPageProvide>(context).judgetAndOpt();
        } else {
          var path = await getExternalStorageDirectory();
          String fPath = path.path + '/download/${item['fileName']}';
          File fp = File(fPath);
          bool exit = fp.existsSync();
          if (exit == false) {
            fPath = item['urlPath'];
          }
          if (item['ftype'].toString().contains('image')) {
            NavigatorUtil.goImageViewPage(context, fPath, isNetUrl: '${!exit}');
          } else if (item['ftype'].toString().contains('video')) {
            NavigatorUtil.goVideoViewPage(context, fPath);
          } else {
            Fluttertoast.showToast(
                msg: '不支持打开该格式', gravity: ToastGravity.CENTER);
          }
        }
      },
      onLongPress: () {
        item['select'] = !item['select'];
        Provide.value<DoucumentPageProvide>(context)
            .changeFileList(index, item);
        Provide.value<DoucumentPageProvide>(context).changeBottomTOF(true);
      },
      title: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil.mediaQueryData.size.width - 165,
                child: Text(
                  '${item['fileName']}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 150,
                child: Text('${item['createTime']}'),
              ),
              Text(
                '${size}',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 50,
          maxHeight: 50,
        ),
        child: Image.asset(FileIconUtil.getStringPath(item['ftype'])), //
      ),
      trailing: Offstage(
        offstage: !selTOF,
        child: Checkbox(
            value: item['select'],
            onChanged: (T) {
              item['select'] = T;
              Provide.value<DoucumentPageProvide>(context).judgetAndOpt();
            }),
      ),
    );
  }
}

//class FileItem extends StatefulWidget {
//  var item;
//  final index;
//
//  FileItem({Key key, @required this.index, this.item}) : super(key: key);
//
//  @override
//  _FileItemState createState() => _FileItemState();
//}
//
//class _FileItemState extends State<FileItem> {
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    bool selTOF = Provide.value<DoucumentPageProvide>(context).bottomTOF;
//    String size = '';
//    if (widget.item['fsize'] < 1000000) {
//      size = '${widget.item['fsize'] / 1000}Kb';
//    } else {
//      size = '${widget.item['fsize'] / 1000000}Mb';
//    }
//
//    return ListTile(
//      onTap: () {
//        if (Provide.value<DoucumentPageProvide>(context).bottomTOF) {
//          widget.item['select'] = !widget.item['select'];
//          Provide.value<DoucumentPageProvide>(context)
//              .changeFileList(widget.index, widget.item);
//          Provide.value<DoucumentPageProvide>(context).judgetAndOpt();
//        }
//      },
//      onLongPress: () {
//        widget.item['select'] = !widget.item['select'];
//        Provide.value<DoucumentPageProvide>(context)
//            .changeFileList(widget.index, widget.item);
//        Provide.value<DoucumentPageProvide>(context).changeBottomTOF(true);
//      },
//      title: Wrap(
//        direction: Axis.vertical,
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Container(
//                width: ScreenUtil.mediaQueryData.size.width - 165,
//                child: Text(
//                  '${widget.item['fileName']}',
//                  overflow: TextOverflow.ellipsis,
//                ),
//              ),
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              Container(
//                width: 150,
//                child: Text('${widget.item['createTime']}'),
//              ),
//              Text(
//                '${size}',
//                overflow: TextOverflow.ellipsis,
//              ),
//            ],
//          ),
//        ],
//      ),
//      leading: ConstrainedBox(
//        constraints: BoxConstraints(
//          maxWidth: 50,
//          maxHeight: 50,
//        ),
//        child: Image.asset(FileIconUtil.getStringPath(widget.item['ftype'])), //
//      ),
//      trailing: Offstage(
//        offstage: !selTOF,
//        child: Checkbox(
//            value: widget.item['select'],
//            onChanged: (T) {
//              setState(() {
//                widget.item['select'] = T;
//                Provide.value<DoucumentPageProvide>(context).judgetAndOpt();
//              });
//            }),
//      ),
//    );
//  }
//}
