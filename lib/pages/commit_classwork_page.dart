import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/pages/revise_page.dart';
import 'package:course_app/provide/commit_classwork_provide.dart';
import 'package:course_app/service/student_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:weui/button/index.dart';
import 'package:weui/notify/index.dart';
import 'package:weui/progress/index.dart';

///提交作业
class CommitClassWorkPage extends StatefulWidget {
  final String endTime;
  final Map map;

  CommitClassWorkPage({Key key, @required this.endTime, @required this.map})
      : super(key: key);

  @override
  _CommitClassWorkPageState createState() => _CommitClassWorkPageState();
}

class _CommitClassWorkPageState extends State<CommitClassWorkPage> {
  bool loading = false;
  bool end = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var time = DateTime.tryParse(widget.endTime);
    if (time != null) {
      end = time.isBefore(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提交作业'),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            margin: const EdgeInsets.only(bottom: 70),
            child: ListView(
              children: <Widget>[
                head(context),
                tip(context),
                body(context),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 60,
                color: Colors.white10,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: WeButton(
                        Text((end) ? '截止' : '提交'),
                        size: WeButtonSize.acquiescent,
                        disabled: end,
                        onClick: () async {
                          //todo
                          List list =
                              Provide.value<CommitClassWorkProvide>(context)
                                  .data;
                          List<String> fids = [];
                          list.forEach((element) {
                            fids.add(element['fid']);
                          });
                          if (fids.isEmpty) {
                            showTip(context, '附件不能为空~');
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          var b = await StudentMethod.commitCourseWork(
                                  context, widget.map['rid'], fids)
                              .whenComplete(() => setState(() {
                                    loading = false;
                                  }));
                          if (b) {
                            Fluttertoast.showToast(msg: '提交成功');
                            Navigator.pop(context, true);
                          } else {
                            Fluttertoast.showToast(msg: '提交失败');
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        theme: WeButtonType.primary,
                        loading: loading,
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget head(context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 200,
      width: ScreenUtil.screenWidth,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black26, width: 1.0))),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(' 截止时间 :${widget.endTime} | 个人作业'))
                ],
              )),
          Expanded(
              child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2)),
                alignment: Alignment.center,
                child: Text(
                  '${widget.map['score']}分',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          )),
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  (widget.map['status'] == 3) ? '未提交' : '已提交',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              )),
        ],
      ),
    );
  }

  Widget tip(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5),
      // color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('作业(必须以附件的形式提交~)'),
        ],
      ),
    );
  }

  Widget body(context) {
    // Provide.value<CommitClassWorkProvide>(context)
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: Provide<CommitClassWorkProvide>(
        builder: (_, child, scope) {
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 1 + scope.localFile.length,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 1.0),
                      ),
                      child: Icon(Icons.attach_file),
                    ),
                    title: Text(
                      '添加附件',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onTap: () async {
                      //todo
                      var files = await getLocalMediaPath('image');
                      if (ObjectUtil.isEmpty(files)) {
                        WeNotify.show(context)(
                            color: Colors.black,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(Icons.info_outline,
                                          color: Colors.white)),
                                  Text(
                                    '附件不能为空',
                                    style: TextStyle(color: Colors.redAccent),
                                  )
                                ]));
                        return;
                      }
                      var file = {
                        'file': files[0].path,
                        'thumbPath': files[0].thumbPath,
                        'value': 0.0,
                        'visiable': true,
                      };
                      //上传文件
                      Provide.value<CommitClassWorkProvide>(context)
                          .uploadFile(context, file);
                      // scope.localFile.add(file);
                    },
                  );
                }
                return fileWidget(scope.localFile[index - 1], index - 1);
              });
        },
      ),
    );
  }

  //文件
  Widget fileWidget(Map map, index) {
    File f = File('${map['file']}');
    return InkWell(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Image.file(
                  File('${map['thumbPath']}'),
                  fit: BoxFit.fill,
                ),
              )),
          Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '  ${f.path.substring(f.path.lastIndexOf("/") + 1, f.path.length)}',
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '  ${f.lengthSync() / 1000} kb',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: map['visiable'],
                      child: WeProgress(
                          value: map['value'],
                          beforeWidget: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text('${map['value']}%')),
                          afterWidget: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('100%')))),
                ],
              )),
          Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black26,
                  ),
                  onPressed: () {
                    //todo
                    Provide.value<CommitClassWorkProvide>(context)
                        .deleteFile(index);
                    Provide.value<CommitClassWorkProvide>(context)
                        .data
                        .removeWhere(
                            (element) => element['tag'] == map['file']);
                  })),
        ],
      ),
    );
  }

  //选择本地文件
  Future<List<Media>> getLocalMediaPath(String type) async {
    List<Media> _listImagePaths;
    if (type == 'image') {
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showCamera: true,
        compressSize: 500,

        ///超过500KB 将压缩图片
      );
    } else if (type == 'video') {
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.video,
        selectCount: 1,
        showCamera: true,
        compressSize: 1024 * 15,

        ///超过15MB 将压缩图片
      );
    } else if (type == 'camara') {
      Media media = await ImagePickers.openCamera(compressSize: 500);
      _listImagePaths = [];
      _listImagePaths.add(media);
    }
    return _listImagePaths;
  }
}
