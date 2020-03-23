import 'dart:io';

import 'package:course_app/provide/file_opt_provide.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provide/provide.dart';
import 'package:course_app/utils/file_icon_util.dart';

///文件传输列表

class FileOptPage extends StatefulWidget {
  num initValue;

  FileOptPage({Key key, this.initValue = 0}) : super(key: key);

  @override
  _FileOptPageState createState() => _FileOptPageState();
}

class _FileOptPageState extends State<FileOptPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<Widget> tabs = const [
    Tab(
      text: '下载列表',
    ),
    Tab(
      text: '上传列表',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.initValue);
    _tabController = new TabController(
        initialIndex: widget.initValue, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text('传输列表'),
            centerTitle: true,
            bottom: TabBar(
              tabs: tabs,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              indicatorWeight: 4.0,
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              DownFileListPage(),
              UpFileListPage(),
            ],
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///上传列表
class UpFileListPage extends StatefulWidget {
  @override
  _UpFileListPageState createState() => _UpFileListPageState();
}

///下载列表
class _UpFileListPageState extends State<UpFileListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      padding: EdgeInsets.only(top: 8),
      child: Provide<FileOptProvide>(
        builder: (_, child, data) {
          if (data.uploadList.isEmpty) {
            return NoDataWidget(
                path: 'assets/fimage/upload.png', title: '暂无上传记录');
          } else {
            print(data.uploadList.length);
            return ListView.builder(
                itemCount: data.uploadList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: ScreenUtil.mediaQueryData.size.width - 165,
                              child: Text(
                                '${data.uploadList[index]['fname']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              (data.uploadList[index]['finish'])
                                  ? '上传完成'
                                  : '${data.uploadList[index]['progress']}k /${data.uploadList[index]['fsize']}k',
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
                      child: Image.asset(FileIconUtil.getStringPath(
                          data.uploadList[index]['ftype'])),
                    ),
                    trailing: CircularProgressIndicator(
                        value: data.uploadList[index]['progress'] /
                            data.uploadList[index]['fsize'],
                        backgroundColor: data.uploadList[index]['finish']
                            ? Colors.blue
                            : Colors.grey,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue)),
                  );
                });
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class DownFileListPage extends StatefulWidget {
  @override
  _DownFileListPageState createState() => _DownFileListPageState();
}

class _DownFileListPageState extends State<DownFileListPage>
    with AutomaticKeepAliveClientMixin {
  String path = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getApplicationDocumentsDirectory
    getExternalStorageDirectory().then((value) {
      setState(() {
        path = value.path + '/download';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(bottom: 5.0),
            width: ScreenUtil.screenWidth,
            height: 45,
            color: Colors.black26,
            child: Text(
              '${path}',
              //style: TextStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Provide<FileOptProvide>(
            builder: (_, child, data) {
              if (data.downloadList.isEmpty) {
                return NoDataWidget(
                    path: 'assets/fimage/download.png', title: '暂无下载记录');
              } else {
                print(data.downloadList.length);
                return Flexible(
                  child: ListView.builder(
                      itemCount: data.downloadList.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Wrap(
                            direction: Axis.vertical,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        ScreenUtil.mediaQueryData.size.width -
                                            165,
                                    child: Text(
                                      '${data.downloadList[index]['fname']}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    (data.downloadList[index]['finish'])
                                        ? '下载完成'
                                        : '${data.downloadList[index]['progress']}k /${data.downloadList[index]['fsize']}k',
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
                            child: Image.asset(FileIconUtil.getStringPath(
                                data.downloadList[index]['ftype'])),
                          ),
                          trailing: CircularProgressIndicator(
                              value: data.downloadList[index]['progress'] /
                                  data.downloadList[index]['fsize'],
                              backgroundColor: data.downloadList[index]
                                      ['finish']
                                  ? Colors.blue
                                  : Colors.grey,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blue)),
                        );
                      }),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
