import 'package:common_utils/common_utils.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/utils/navigatorUtil.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

///修改密码页面
class PwdChangePage extends StatefulWidget {
  PwdChangePage({Key key, @required this.username}) : super(key: key);
  final String username;

  @override
  _PwdChangePageState createState() => _PwdChangePageState();
}

class _PwdChangePageState extends State<PwdChangePage> {
  TextEditingController oldcontroller;
  TextEditingController newcontroller;
  TextEditingController surecontroller;
  FocusNode oldNode;
  FocusNode newNode;
  FocusNode focusNode;
  bool displayLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldcontroller = TextEditingController();
    newcontroller = TextEditingController();
    surecontroller = TextEditingController();
    oldNode = FocusNode();
    newNode = FocusNode();
    focusNode = FocusNode();
    displayLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    oldcontroller.dispose();
    newcontroller.dispose();
    surecontroller.dispose();
    oldNode.dispose();
    newNode.dispose();
    focusNode.dispose();
    super.dispose();
  }

  ///提交请求
  onSubmit() async {
    focusNode.unfocus();
    oldNode.unfocus();
    newNode.unfocus();
    String oldPwd = oldcontroller.value.text.trim();
    String newPwd = newcontroller.value.text.trim();
    String surePwd = surecontroller.value.text.trim();
    if (oldPwd.length < 6 || newPwd.length < 6 || surePwd.length < 6) {
      Fluttertoast.showToast(
        msg: '新旧密码长度至少要大于6位数',
      );
      return null;
    }
    if (newPwd != surePwd) {
      Fluttertoast.showToast(
        msg: '两次输入的新密码不一致',
      );
      return null;
    }
    setState(() {
      displayLoading = true;
    });
    bool b =
        await UserMethod.userPwdChange(context, widget.username, oldPwd, newPwd)
            .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    }).whenComplete(() {
      setState(() {
        displayLoading = false;
      });
    });
    if (b) {
      var sure = await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertionDialog(
              title: '密码修改成功',
              content: '请返回登录页面重新登录',
              onOk: () {
                Navigator.pop(context, true);
              },
              onCancel: () {
                Navigator.pop(context, false);
              },
              isLoding: false,
            );
          });
      if (sure) {
        NavigatorUtil.goLoginPage(context, username: widget.username);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置密码与修改'),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
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
              onPressed: (!displayLoading)?() => onSubmit():null,
              child: (!displayLoading)?Text('完成'):CupertinoActivityIndicator(),
            ),
          )
        ],
      ),
      body: Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Text(
                    '请设置或智慧课堂密码。你可以用绑定的手机号+智慧课堂密码登录。或者绑定的邮箱号+智慧课堂密码登录',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            child: Text(
                              '原密码 ',
                              style: TextStyle(fontSize: 20),
                            ),
                            width: 90,
                          ),
                          Flexible(
                              child: MyTextField(
                            controller: oldcontroller,
                            focusNode: oldNode,
                            hint: '填写原密码',
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            child: Text(
                              '新密码 ',
                              style: TextStyle(fontSize: 20),
                            ),
                            width: 90,
                          ),
                          Flexible(
                              child: MyTextField(
                                  focusNode: newNode,
                                  controller: newcontroller,
                                  hint: '填写新密码')),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            child: Text(
                              '确认密码 ',
                              style: TextStyle(fontSize: 20),
                            ),
                            width: 90,
                          ),
                          Flexible(
                              child: MyTextField(
                                  focusNode: focusNode,
                                  controller: surecontroller,
                                  hint: '再次填写确认')),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Text('密码长度必须大于6位数'),
                      FlatButton(
                        onPressed: () {
                          //todo 忘记密码
                        },
                        child: Text(
                          '忘记密码?',
                          //style: TextStyle(color: Colors.blue.shade300),
                        ),
                        textColor: Colors.blue.shade300,
                        splashColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget MyTextField({
    TextEditingController controller,
    String hint,
    //List<TextInputFormatter> inputFormatters,
    ValueChanged<String> onChanged,
    bool passWordVisible,
    FocusNode focusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: true,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      inputFormatters: [
        LengthLimitingTextInputFormatter(32),
        BlacklistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]")),
      ],
      onChanged: (value) => onChanged(value),
      decoration: new InputDecoration(
        // labelText: '原密码',
        //border: Bor,
        //focusedBorder: InputBorder,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 20),
        contentPadding: const EdgeInsets.only(
            top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
      ),
    );
  }
}
