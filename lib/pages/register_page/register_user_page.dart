import 'package:common_utils/common_utils.dart';
import 'package:course_app/components/InputFields.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/provide/register_page_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:provide/provide.dart';

///注册页面
class RegisterUserPage extends StatefulWidget {
  RegisterUserPage({Key key}) : super(key: key);

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

///返回按钮
Widget BackBtn(context) {
  return Padding(
    padding: EdgeInsets.only(top: 30),
    child: Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black26,
            size: ScreenUtil().setSp(50),
          ),
        ),
      ],
    ),
  );
}

///输入框
Widget textField(
  IconData iconData, {
  TextEditingController controller,
  String initValue,
  String hint,
  List<TextInputFormatter> inputFormatters,
  ValueChanged<String> onChanged,
  FocusNode focusNode,
}) {
  return TextFormField(
    controller: controller,
    initialValue: initValue,
    focusNode: focusNode,
    autofocus: true,
    obscureText: false,
    style: const TextStyle(color: Colors.black, fontSize: 28),
    inputFormatters: inputFormatters,
    onChanged: (value) => onChanged(value),
    decoration: new InputDecoration(
      icon: new Icon(
        iconData,
        color: Colors.black26,
        textDirection: TextDirection.ltr,
      ),
      border: InputBorder.none,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 23.0),
      contentPadding: const EdgeInsets.only(
          top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
    ),
  );
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  int registeType;

  ///注册方式 默认0-手机
  TextEditingController textEditingController;
  bool displayBtn;
  bool displayLoding;
  FocusNode focusNode;

  ///下一步按钮

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registeType = 0;
    textEditingController = TextEditingController();
    displayBtn = false;
    displayLoding = false;
    focusNode = FocusNode();
    initMobileNumberState().then((onValue){
      textEditingController.text=onValue;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  ///获取android手机号码
  Future<String> initMobileNumberState() async {
    String mobileNumber = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = await MobileNumber.mobileNumber;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }
    if (!mounted) return '';
    return mobileNumber;
  }

  clickExitsUserName(context, String username) async {
    setState(() {
      displayLoding = true;
    });
    bool b = await UserMethod.exitsUserName(context, username, registeType)
        .whenComplete(() {
      setState(() {
        displayLoding = false;
      });
    });
    if (!b) {
      //todo 下一页
      NavigatorUtil.goNextRegisterPage(context);
      debugPrint("没有被注册");
    } else {
      Fluttertoast.showToast(
          msg: '该账号已经被注册过',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black.withOpacity(0.3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Provide<RegisteProvide>(
          builder: (context, child, data) {
            // debugPrint('data.username ${data.username}');
            registeType = data.registeType;
            return Column(
              children: <Widget>[
                BackBtn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '注册新用户',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                  ],
                ),
                RegisterType(),
                labelItem(initValue: data.username),
                usernameBtn(),
              ],
            );
          },
        ),
      ),
    );
  }

  ///校验输入内容
  onChange(value) {
    ///改变按钮状态
    if (displayBtn) {
      if (!ObjectUtil.isEmptyString(value.trim())) {
        ///输入不为空
        if (registeType == 0 && !RegexUtil.isMobileSimple(value.trim())) {
          setState(() {
            displayBtn = false;
          });
        } else if (registeType == 1 && !RegexUtil.isEmail(value.trim())) {
          setState(() {
            displayBtn = false;
          });
        }
      } else {
        setState(() {
          displayBtn = false;
        });
      }
    } else {
      ///按钮是禁用状态
      if (registeType == 0 && RegexUtil.isMobileSimple(value.trim())) {
        setState(() {
          displayBtn = true;
        });
        Provide.value<RegisteProvide>(context).username = value.trim();
      } else if (registeType == 1 && RegexUtil.isEmail(value.trim())) {
        setState(() {
          displayBtn = true;
        });
        Provide.value<RegisteProvide>(context).username = value.trim();
      }
    }
  }

  ///下一步按钮
  Widget usernameBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Expanded(
              child: CupertinoButton(
            onPressed: (displayBtn)
                ? () async {
                    //TODO 点击下一步
                    // String username = textEditingController.value.text.trim();
                    focusNode.unfocus();
                    String username =
                        Provide.value<RegisteProvide>(context).username.trim();
                    clickExitsUserName(context, username);
                  }
                : null,
            disabledColor: Colors.blue.withOpacity(0.2),
            child: (!displayLoding)
                ? Text(
                    '下一步',
                    style: TextStyle(color: Colors.white),
                  )
                : CupertinoActivityIndicator(),
            color: Colors.blue,
          ))
        ],
      ),
    );
  }

  ///标签
  Widget labelItem({String initValue}) {
    return Container(
        decoration: BoxDecoration(
            //color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    color: Color(Constants.DividerColor),
                    width: Constants.DividerWith))),
        child: Column(
          children: <Widget>[
            Container(
              child: textField(
                  (registeType == 0) ? Icons.phone_android : Icons.email,
                  controller: textEditingController,
                  hint: (registeType == 0) ? '手机号码注册' : '邮箱号注册',
                  onChanged: (value) => onChange(value),
                  focusNode: focusNode,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(32),
                    //  WhitelistingTextInputFormatter白名单
                    BlacklistingTextInputFormatter(
                        RegExp("[\u4e00-\u9fa5]")), //黑名单
                  ]),
            ),
          ],
        ));
  }

  ///注册方式按钮
  Widget RegisterType() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  ' 选择注册方式',
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil().setSp(30)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Radio(
                    value: 0,
                    groupValue: registeType,
                    onChanged: (T) {
                      setState(() {
//                        registeType = T;
                        Provide.value<RegisteProvide>(context)
                            .changRegisteType(T);
                        displayBtn = false;
                      });
                      textEditingController.clear();
                      Provide.value<RegisteProvide>(context).changUserName('');
                    }),
                Text(
                  '手机注册',
                  style: TextStyle(
                      color: (registeType == 0) ? Colors.blue : Colors.grey,
                      fontSize: ScreenUtil().setSp(30)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Radio(
                    value: 1,
                    groupValue: registeType,
                    onChanged: (T) {
                      setState(() {
                        //registeType = T;
                        Provide.value<RegisteProvide>(context)
                            .changRegisteType(T);
                        displayBtn = false;
                      });
                      Provide.value<RegisteProvide>(context).changUserName('');
                      textEditingController.clear();
                    }),
                Text(
                  '邮箱注册',
                  style: TextStyle(
                      color: (registeType == 1) ? Colors.blue : Colors.grey,
                      fontSize: ScreenUtil().setSp(30)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
