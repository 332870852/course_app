import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/topic_dto.dart';
import 'package:course_app/provide/chat/flush_bar_util.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:weui/notify/index.dart';

///场景话题
class TopicCreatePage extends StatefulWidget {
  final courseId;

  TopicCreatePage({Key key, @required this.courseId}) : super(key: key);

  @override
  _TopicCreatePageState createState() => _TopicCreatePageState();
}

class _TopicCreatePageState extends State<TopicCreatePage> {
  TextEditingController _titleController;

  TextEditingController _contextController;

  bool displayLod = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _contextController = TextEditingController();
//    Widget w =
//    data.add(w);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布话题'),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            width: 60,
            margin: EdgeInsets.all(10),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              disabledColor: Colors.grey.withOpacity(0.7),
              disabledTextColor: Colors.black45,
              onPressed: (!displayLod)
                  ? () async {
                      //Navigator.pop(context, true);
                      var tag = _titleController.value.text.trim();
                      var body = _contextController.value.text.trim();
                      if (ObjectUtil.isEmpty(tag) &&
                          ObjectUtil.isEmpty(body) &&
                          urls.length == 0) {
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
                                    '不能发表空的话题',
                                    style:
                                        TextStyle(color: Colors.yellowAccent),
                                  )
                                ]));
                        return;
                      }
                      setState(() {
                        displayLod = true;
                      });
                      TopicDto top = new TopicDto(
                        tag: tag,
                        content: body,
                        createTime: DateTime.now().toIso8601String(),
                        courseId: widget.courseId,
                        annexes: urls,
                        publisher: Provide.value<UserProvide>(context).userId,
                      );
                      var res = await UserMethod.createTopic(context, top)
                          .whenComplete(() {
                        setState(() {
                          displayLod = false;
                        });
                      });
                      if (res != null) {
                        Navigator.pop(context, res);
                      }
                    }
                  : null,
              child: (!displayLod) ? Text('发布') : CupertinoActivityIndicator(),
            ),
          )
        ],
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: _titleController,
                  //initialValue:'${ widget.title}',
                  decoration: InputDecoration(
                      hintText: '话题标签(选填)',
                      hintStyle:
                          TextStyle(fontSize: ScreenUtil.textScaleFactory * 20),
                      filled: true,
                      focusedBorder: OutlineInputBorder(),
                      border: InputBorder.none,
                      focusColor: Colors.red),
                  maxLength: 50,
                  maxLines: 1,
                ),
              ),
            ),
            Flexible(
              child: Container(
                color: Colors.white,
                //height: 250,
                padding: EdgeInsets.all(5.0),
                // margin: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _contextController,
                  //initialValue: '${widget.contextBody}',
                  style: TextStyle(fontSize: ScreenUtil.textScaleFactory * 20),
                  decoration: InputDecoration(
                      hintText: '话题详细内容',
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder()),
                  maxLength: 500,
                  maxLines: 20,
                  minLines: 10,
                ),
              ),
            ),
            uploadItem(),
          ],
        ),
      ),
    );
  }

  List<String> urls = [];

  List<String> display = [];

  ///上传附件
  Widget uploadItem() {
    return Container(
      height: 180,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/img/添加相片.png',
                          ),
                          fit: BoxFit.fill),
                    ),
                    padding: EdgeInsets.only(left: 15.0),
                    margin: EdgeInsets.all(10),
                    height: 80,
                    width: 80,
                    //color: Colors.red,
                  ),
                  onTap: () {
                    if (display.length > 2) {
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
                                  '最多只能上传6个文件',
                                  style: TextStyle(color: Colors.yellowAccent),
                                )
                              ]));
                      return;
                    }
                    uploadMedia();
                  },
                ),
                Text('最多只能上传6给文件~  ')
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: display.length,
              itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage('${display[index]}'),
                        fit: BoxFit.fill),
                  ),
                  padding: EdgeInsets.only(left: 15.0),
                  margin: EdgeInsets.all(10),
                  height: 80,
                  width: 80,
                  //color: Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  uploadMedia() async {
    var _listImagePaths = await getLocalMediaPath('image');
    Flushbar bar = FlushBarUtil.getFlushBar(null, //Duration(seconds: 4),
        titleText: Text(
          '温馨提示',
          style: TextStyle(color: Colors.yellow[600], fontSize: 18),
        ),
        messageText: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: FileImage(
                File(_listImagePaths[0].path),
              ),
              maxRadius: 20,
              minRadius: 20,
            ),
            Text(
              '  图片上传中...',
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ],
        ),
        isDismissible: true,
        showProgressIndicator: true)
      ..show(context);
    UserMethod.uploadChatImageBase64(context, _listImagePaths[0].path,
            timeout: 60 * 1000)
        .then((onValue) async {
      if (onValue != null) {
        if (!urls.contains(onValue.faceImageBig)) {
          setState(() {
            urls.add(onValue.faceImageBig);
            display.add(onValue.faceImage);
          });
        }
        print(onValue.faceImage);
      }
      bar.dismiss();
    }).whenComplete(() {
      if (bar.isShowing()) {
        bar.dismiss();
      }
    });
  }

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
