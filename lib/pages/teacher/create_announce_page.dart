import 'dart:io';

import 'package:course_app/data/announcement_dto.dart';
import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/progress_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/CropConfig.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provide/provide.dart';

///发布公告&&修改公告
class CreateAnnouncePage extends StatefulWidget {
  CreateAnnouncePage({Key key,
    @required this.courseId,
    this.title,
    this.contextBody,
    this.fujian,
    this.pageTitle = '发布公告',
    this.announceId,
    this.isCreatePage = true})
      : assert(courseId != null),
        super(key: key);
  final String courseId;
  String title;
  String contextBody;
  String fujian = null;

  ///页面标题
  String pageTitle;

  ///公告id
  String announceId;

  ///true-创建页面，false-修改页
  bool isCreatePage;

  @override
  _CreateAnnouncePageState createState() => _CreateAnnouncePageState();
}

class _CreateAnnouncePageState extends State<CreateAnnouncePage> {
  TextEditingController _titleController;

  TextEditingController _contextController;
  bool displayLod = false;
  String annex='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _contextController = TextEditingController();
    _titleController.text = widget.title;
    _contextController.text = widget.contextBody;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('${widget.pageTitle}'),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
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
                  ? () {
                //TODO 创建
                if (widget.isCreatePage) {
                  _submit(context,
                      title: _titleController.value.text,
                      body: _contextController.value.text);
                } else {
                  //todo 修改
                  _submit_modify(context,
                      announceId:widget.announceId,
                      title: _titleController.value.text,
                      body: _contextController.value.text);
                }

                //Navigator.pop(context, true);
              }
                  : null,
              child: (!displayLod) ? Text('保存') : CupertinoActivityIndicator(),
            ),
          )
        ],
      ),
      body: _body(context),
    );
  }

  Widget _body(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  hintText: '公告告标题',
                  hintStyle: TextStyle(fontSize: ScreenUtil().setSp(40)),
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
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
              decoration: InputDecoration(
                  hintText: '公告详细内容',
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder()),
              maxLength: 300,
              maxLines: 10,
              minLines: 10,
            ),
          ),
        ),
        uploadItem(),
      ],
    );
  }

  ///上传附件
  Widget uploadItem() {
    return InkWell(
      onTap: () {
        //todo
        selectImage(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: (widget.fujian == null||widget.fujian.trim().isEmpty)
                  ? AssetImage(
                'assets/img/添加相片.png',
              )
                  : NetworkImage('${widget.fujian}'),
              fit: BoxFit.fill),
        ),
        padding: EdgeInsets.only(left: 15.0),
        margin: EdgeInsets.all(10),
        height: 80,
        width: 80,
        //color: Colors.red,
      ),
    );
  }

  ///选择多张图片 Select multiple images
  Future<void> selectImage(context) async {
    List<Media> _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showCamera: true,
        compressSize: 500,

        ///超过500KB 将压缩图片
        uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
        cropConfig: CropConfig(enableCrop: true, width: 1, height: 1));
    ProgressDialog pr;
    pr = ProgressDialogWdiget.showProgressStatic(context,
        message: '请稍后..',
        type: ProgressDialogType.Normal,
        progressWidget: CupertinoActivityIndicator(
          radius: 20.0,
        ));

    UserMethod.uploadImage(imagePath: _listImagePaths[0].path)
        .then((onValue) {
      setState(() {
        widget.fujian = onValue.faceImageBig;
        annex=onValue.faceImageBig;
      });
    })
        .catchError((onError) {})
        .whenComplete(() {
      if (pr.isShowing()) {
        pr.dismiss();
      }
    });
  }

  void _submit(BuildContext context, {@required String title, String body}) {
    if (title.isEmpty) {
      Fluttertoast.showToast(msg: '公告标题不能为空');
    }
    setState(() {
      displayLod = true;
    });
    AnnouncementDto announcementDto = AnnouncementDto();
    announcementDto.announceTitle = title;
    announcementDto.announceBody = body;
    announcementDto.courseId = widget.courseId;
    announcementDto.annex = annex;
    TeacherMethod.createAnnouncement(
        userId: Provide
            .value<UserProvide>(context)
            .userId,
        announcementDto: announcementDto)
        .then((onValue) {
      if (onValue != null) {
        setState(() {
          displayLod = false;
        });
        Provide.value<ReplyListProvide>(context).insertAnnouncement(onValue);

        /// insert
      }
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  void _submit_modify(BuildContext context,
      {@required String announceId,
        @required String title,
        String body}) async {
    if (title.isEmpty) {
      Fluttertoast.showToast(msg: '公告标题不能为空');
    }
    setState(() {
      displayLod = true;
    });
    AnnouncementDto announcementDto = AnnouncementDto();
    announcementDto.announceId = int.parse(announceId);
    announcementDto.announceTitle = title;
    announcementDto.announceBody = body;
    announcementDto.courseId = widget.courseId;
    announcementDto.annex = annex;
    TeacherMethod.updateAnnouncement(Provide
        .value<UserProvide>(context)
        .userId,
        announcementDto: announcementDto)
        .then((onValue) {
      if (onValue != null) {
        setState(() {
          displayLod = false;
        });
        Provide.value<ReplyListProvide>(context).updateAnnouncement(
            announceId: int.tryParse(announceId),
            announceTitle: title,
            body: body,
            annex: annex);

        /// insert
      }
    }).whenComplete((){
      Navigator.pop(context);
    });
  }
}
