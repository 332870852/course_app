import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'chat_friend_info_page.dart';

///搜索好友页
class SearchFriendPage extends StatelessWidget {
  SearchFriendPage({Key key}) : super(key: key);
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('查找'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            searchItem(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    //todo
                    String username = _controller.text.trim();
                    int type = 1;
                    if (ObjectUtil.isEmptyString(username)) {
                      Fluttertoast.showToast(msg: '搜索内容不能为空!');
                      return;
                    } else if (RegexUtil.isMobileSimple(username)) {
                      type = 1;
                    } else if (RegexUtil.isEmail(username)) {
                      type = 2;
                    } else {
                      Fluttertoast.showToast(msg: '搜索账号格式不正确!');
                      return;
                    }
                    _focusNode.unfocus();
                    UserInfoVo friend = await UserMethod.getUserFriend(
                            context, username,
                            findType: type)
                        .catchError((onError) {
                      Fluttertoast.showToast(msg: '${onError.toString()}!');
                    });
                    if (friend == null) {
                      Fluttertoast.showToast(msg: '搜索不到指定的用户！');
                    } else {
                      bool b = await UserMethod.IsMyFriend(
                          context, friend.userId.toString());
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatFriendInfoPage(
                                    friendInfo: friend,
                                    action: (b) ? 0 : 1,
                                  )));
                    }
                  },
                  child: Text('搜索'),
                  textColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget searchItem() {
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
                  controller: _controller,
                  hint: '手机号/邮箱号查找',
                  focusNode: _focusNode,
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

  ///输入框
  Widget textField({
    TextEditingController controller,
    String hint,
    List<TextInputFormatter> inputFormatters,
    ValueChanged<String> onChanged,
    FocusNode focusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      style: const TextStyle(color: Colors.black, fontSize: 28),
      inputFormatters: inputFormatters,
      onChanged: (value) => onChanged(value),
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black26,
        ),
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 23.0),
        contentPadding: const EdgeInsets.only(
            top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
      ),
    );
  }
}
