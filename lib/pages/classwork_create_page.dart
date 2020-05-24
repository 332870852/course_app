import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/classwork_dto.dart';
import 'package:course_app/data/topic_dto.dart';
import 'package:course_app/pages/revise_page.dart';
import 'package:course_app/provide/chat/flush_bar_util.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weui/notify/index.dart';

///create 课堂作业
class ClassWorkCreatePage extends StatefulWidget {
  final courseId;

  //final teacherId;
  ClassWorkCreatePage({Key key, @required this.courseId}) : super(key: key);

  @override
  _ClassWorkCreatePageState createState() => _ClassWorkCreatePageState();
}

class _ClassWorkCreatePageState extends State<ClassWorkCreatePage> {
  TextEditingController _titleController;

  TextEditingController _contextController;
  TextEditingController _scoreController;
  bool displayLod = false;
  DateTime endTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _contextController = TextEditingController();
    _scoreController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布作业'),
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
                      var exprie = num.tryParse(
                              '${(endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) / 1000}')
                          .toInt();
                      var title = _titleController.value.text.trim();
                      var content = _contextController.value.text.trim();
                      if (ObjectUtil.isEmpty(title) ||
                          (ObjectUtil.isEmpty(content) && urls.length == 0)) {
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
                                    '不能发布空的作业',
                                    style:
                                        TextStyle(color: Colors.yellowAccent),
                                  )
                                ]));
                        return;
                      }
                      var score;
                      var aler = await Alert(
                          context: context,
                          title: "设置分数并发布",
                          content: Column(
                            children: <Widget>[
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: _scoreController,
                                decoration: InputDecoration(
                                  labelText: 'socre',
                                  hintText: '输入作业总分',
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                  //  WhitelistingTextInputFormatter白名单
                                  WhitelistingTextInputFormatter(
                                      RegExp("[0-9]")),
                                ],
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              child: Text(
                                "确认",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                score=_scoreController.value.text;
                                if (score.isEmpty || num.tryParse(score) < 0) {
                                  showTip(context, '分数不能为空，也不能小于0');
                                  return;
                                }
                                Navigator.pop(context, true);
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                            )
                          ]).show();
                      if (aler) {
                        setState(() {
                          displayLod = true;
                        });
                        ClassWorkDto classwork = ClassWorkDto(
                            title: title,
                            content: content,
                            courseId: widget.courseId,
                            score: num.tryParse(score),
                            expireTime: exprie,
                            annex: urls,
                            createTime: DateTime.now().toIso8601String());
                        var res = await TeacherMethod.createClassWork(
                                context, classwork)
                            .whenComplete(() {
                          setState(() {
                            displayLod = false;
                          });
                        });
                        if (res != null) {
                          Fluttertoast.showToast(msg: '发布成功~');
                          Navigator.pop(context, res);
                        }
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
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(5.0),
              child: TextFormField(
                controller: _titleController,
                //initialValue:'${ widget.title}',
                decoration: InputDecoration(
                    hintText: '作业标题',
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
            Container(
              color: Colors.white,
              //height: 250,
              padding: EdgeInsets.all(5.0),
              // margin: EdgeInsets.all(5),
              child: TextFormField(
                controller: _contextController,
                //initialValue: '${widget.contextBody}',
                style: TextStyle(fontSize: ScreenUtil.textScaleFactory * 20),
                decoration: InputDecoration(
                    hintText: '作业详细内容',
                    filled: true,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder()),
                maxLength: 1000,
                maxLines: 20,
                minLines: 10,
              ),
            ),
            Container(
              height: 60,
              //padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      leading: Text(
                        '设置截止时间: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      title: Text('${endTime.toString().substring(0, 19)}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        DateTime date = DateTime.now();
                        DatePicker.showDateTimePicker(
                          context,
                          //theme: DatePickerTheme(),
                          minTime: DateTime.now(),
                          maxTime: DateTime(
                            date.year + 1,
                          ),
                          currentTime: DateTime.now(),
                          locale: LocaleType.zh,
                          onConfirm: (date) {
                            print(date);
                            setState(() {
                              endTime = date;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
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
                    if (display.length > 5) {
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
//                  decoration: BoxDecoration(
//                    color: Colors.grey,
//                    image: DecorationImage(
//                        image: NetworkImage('${display[index]}'),
//                        fit: BoxFit.fill),
//                  ),
                  padding: EdgeInsets.only(left: 15.0),
                  margin: EdgeInsets.all(10),
                  height: 80,
                  width: 80,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/img/上传图片加载中.png',
                    image: '${display[index]}',
                    fit: BoxFit.cover,
                  ),
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
