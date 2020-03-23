import 'dart:io';

import 'package:course_app/provide/file_opt_provide.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/service/user_method.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provide/provide.dart';

class MenuFloatButton extends StatefulWidget {
  final courseId;

  MenuFloatButton({Key key, @required this.courseId}) : super(key: key);

  @override
  MenuFloatButtonState createState() => new MenuFloatButtonState();
}

class MenuFloatButtonState extends State<MenuFloatButton> {
  bool btnShow = true;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: new Container(
          width: 120.0,
          height: 120.0,
          child: new Stack(
            children: <Widget>[
              new Positioned(
                  width: 50.0,
                  height: 50.0,
                  bottom: 0,
                  right: 0,
                  child: Transform.rotate(
                    child: new FloatingActionButton(
                      child: new Icon(Icons.add),
                      backgroundColor: const Color(0xFF6f69c1),
                      onPressed: () {
                        setState(() {
                          btnShow = !btnShow;
                        });
                      },
                    ),
                    angle: !btnShow ? 0.8 : 0,
                  )),
              new Positioned(
                width: 42.0,
                height: 42.0,
                bottom: 0,
                left: 0,
                child: new Visibility(
                    visible: !btnShow,
                    child: Center(
                      child: CircleAvatar(
                        child: new IconButton(
                          icon: new Icon(Icons.file_upload),
                          color: const Color(0xFFffffff),
                          onPressed: () async {
                            // var file = await FilePicker.getFilePath(type: FileType.any);
                            var map = await FilePicker.getMultiFilePath(
                                type: FileType.any);
                            if (map.isNotEmpty) {
                              Provide.value<FileOptProvide>(context)
                                  .uploadFiles(context, map, widget.courseId);

//                              UserMethod.uploadCourseFile(context, map,
//                                  onSendProgress: (send,total) {
//                                print('send :${total}, total: ${send}');
//                              });
                              NavigatorUtil.goFileOptPage(context,
                                  initValue: 1);
                            }
                          },
                        ),
                        backgroundColor: const Color(0xFF6f69c1),
                      ),
                    )),
              ),
              new Positioned(
                width: 42.0,
                height: 42.0,
                top: 25.0,
                left: 25.0,
                child: new Visibility(
                    visible: !btnShow,
                    child: Center(
                      child: CircleAvatar(
                        child: new IconButton(
                          icon: new Icon(Icons.file_download),
                          color: const Color(0xFFffffff),
                          onPressed: () {
                            NavigatorUtil.goFileOptPage(context, initValue: 0);
                          },
                        ),
                        backgroundColor: const Color(0xFF6f69c1),
                      ),
                    )),
              ),
              new Positioned(
                width: 42.0,
                height: 42.0,
                top: 0,
                right: 0,
                child: new Visibility(
                    visible: !btnShow,
                    child: Center(
                      child: CircleAvatar(
                        child: new IconButton(
                          icon: new Icon(Icons.security),
                          color: const Color(0xFFffffff),
                          onPressed: () {},
                        ),
                        backgroundColor: const Color(0xFF6f69c1),
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
