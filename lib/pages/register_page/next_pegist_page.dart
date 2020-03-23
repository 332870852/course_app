import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/pages/register_page/register_user_page.dart';
import 'package:course_app/provide/register_page_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

///完善个人信息注册页
class NextRegistPage extends StatefulWidget {
  NextRegistPage({Key key}) : super(key: key);

  //final String username;

  @override
  _NextRegistPageState createState() => _NextRegistPageState();
}

class _NextRegistPageState extends State<NextRegistPage> {
  TextEditingController schoolController;
  TextEditingController realNameController;

  ///身份 2-教师，3-学生 默认2
  int role;
  bool schoolRadio;
  bool realRadio;
  bool displayBtn;

  //bool displayLoding;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schoolController = TextEditingController();
    realNameController = TextEditingController();
    role = 3;
    schoolRadio = false;
    realRadio = false;
    displayBtn = false;
    // displayLoding = false;
    //print(widget.username);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    schoolController.dispose();
    realNameController.dispose();
    super.dispose();
  }

  ///处理状态
  doState(String realName, String school) {
    if (ObjectUtil.isNotEmpty(realName)) {
      realRadio = true;
      if(ObjectUtil.isNotEmpty(school)){
        schoolRadio = true;
        displayBtn=true;
      }else{
        schoolRadio = false;
      }
    } else if (ObjectUtil.isNotEmpty(school)) {
      schoolRadio = true;
      if (ObjectUtil.isNotEmpty(realName)) {
        realRadio = true;
        displayBtn=true;
      }else{
        realRadio = false;
      }
    }else {
      realRadio = false;
      schoolRadio = false;
      displayBtn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Provide<RegisteProvide>(builder: (context, child, data) {
            // print('调用');
            doState(data.realName,data.school);
//            schoolController.text = data.school;
//            realNameController.text = data.realName;
            role = data.role;
            return Column(
              children: <Widget>[
                BackBtn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '完善个人信息',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                  ],
                ),
                InputItem(schoolValue: data.school,realValue: data.realName),
                RadioSelect(),
                lableItem(),
                nextBtn(),
              ],
            );
          })),
    );
  }

  ///下一步按钮
  Widget nextBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Expanded(
              child: CupertinoButton(
            onPressed: (displayBtn)
                ? () async {
                    //TODO 点击下一步
                    NavigatorUtil.goFinalRegisterPage(context);
                  }
                : null,
            disabledColor: Colors.blue.withOpacity(0.2),
            child: Text(
              '下一步',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ))
        ],
      ),
    );
  }

  ///tip
  Widget lableItem() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Radio(
                  value: true,
                  activeColor: Colors.green,
                  groupValue: schoolRadio,
                  onChanged: (T) {},
                ),
                Text(
                  '学校名称不能为空',
                  style: TextStyle(
                      color: (schoolRadio) ? Colors.green : Colors.grey,
                      fontSize: ScreenUtil.textScaleFactory*15),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Radio(
                  activeColor: Colors.green,
                  value: true,
                  groupValue: realRadio,
                  onChanged: (T) {},
                ),
                Text(
                  '真实姓名必须限制在1-10位',
                  style: TextStyle(
                      color: (realRadio) ? Colors.green : Colors.grey,
                      fontSize: ScreenUtil.textScaleFactory*15),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///输入框
  Widget InputItem({@required String schoolValue,@required String realValue}) {
    return Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
            // color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    color: Color(Constants.DividerColor),
                    width: Constants.DividerWith))),
        child: Column(
          children: <Widget>[
            Container(
              child: textField(Icons.school, hint: '学校名称',initValue: schoolValue,
                  onChanged: (value) {
                ///radio
//                if (schoolRadio) {
//                  if (ObjectUtil.isEmptyString(value.trim())) {
//                    setState(() {
//                      schoolRadio = false;
//                    });
//                  }
//                } else {
//                  if (!ObjectUtil.isEmptyString(value.trim())) {
//                    setState(() {
//                      schoolRadio = true;
//                    });
//                  }
//                }
                Provide.value<RegisteProvide>(context)
                    .changeSchool(value.trim());
              }, inputFormatters: [
                LengthLimitingTextInputFormatter(32),
                WhitelistingTextInputFormatter(
                    RegExp("[[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")),
                //黑名单
              ]),
            ),
            Container(
              child: textField(Icons.near_me, hint: '真实姓名', initValue: realValue,
                  onChanged: (value) {
                ///radio
                if (realRadio) {
                  if (ObjectUtil.isEmptyString(value.trim())) {
                    setState(() {
                      realRadio = false;
                    });
                  }
                } else {
                  if (!ObjectUtil.isEmptyString(value.trim())) {
                    setState(() {
                      realRadio = true;
                    });
                  }
                }
                ///
                Provide.value<RegisteProvide>(context)
                    .changeRealName(value.trim());
              }, inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                WhitelistingTextInputFormatter(
                    RegExp("[[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")),
                //黑名单
              ]),
            ),
          ],
        ));
  }

  ///身份选择
  Widget RadioSelect() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  '选择身份',
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil.textScaleFactory*15),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Radio(
                    value: 2,
                    groupValue: role,
                    onChanged: (T) {
                      setState(() {
                        role = T;
                        //displayBtn = false;
                      });
                      Provide.value<RegisteProvide>(context).changeRole(T);
                    }),
                Text(
                  '教师',
                  style: TextStyle(
                      color: (role == 2) ? Colors.blue : Colors.grey,
                      fontSize: ScreenUtil.textScaleFactory*15),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Radio(
                    value: 3,
                    groupValue: role,
                    onChanged: (T) {
                      setState(() {
                        role = T;
                        //displayBtn = false;
                      });
                      Provide.value<RegisteProvide>(context).changeRole(T);
                    }),
                Text(
                  '学生',
                  style: TextStyle(
                      color: (role == 3) ? Colors.blue : Colors.grey,
                      fontSize: ScreenUtil.textScaleFactory*15),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
