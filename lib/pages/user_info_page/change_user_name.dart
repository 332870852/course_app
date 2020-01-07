import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
///修改名字
//class ChangeUserNamePage extends StatefulWidget {
//  final defaultvalue;
//
//  ChangeUserNamePage({
//    Key key,
//    @required this.defaultvalue,
//  }) : super(key: key);
//
//  @override
//  _ChangeUserNamePageState createState() => _ChangeUserNamePageState();
//}
//
//class _ChangeUserNamePageState extends State<ChangeUserNamePage> {
//  TextEditingController _controller;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _controller = TextEditingController(text: widget.defaultvalue);
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('更改姓名'),
//        backgroundColor: Theme.of(context).primaryColor,
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back_ios),
//            onPressed: () {
//              Navigator.of(context).pop();
//            }),
//        elevation: 0.0,
//        actions: <Widget>[
//          Container(
//            width: 60,
//            margin: EdgeInsets.all(10),
//            child: FlatButton(
//              textColor: Colors.white,
//              color: Colors.green,
//              disabledColor: Colors.grey.withOpacity(0.7),
//              disabledTextColor: Colors.black45,
//              onPressed:
//                  _controller.value.text.toString() == widget.defaultvalue
//                      ? null
//                      : () {
//                          //TODO
//                        },
//              child: Text('保存'),
//            ),
//          )
//        ],
//      ),
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.only(top: 30),
//            child: Container(
//              //  color: Colors.red,
//              margin: EdgeInsets.symmetric(horizontal: 16.0),
//              height: 50,
//              child: TextFormField(
//                controller: _controller,
//                textDirection: TextDirection.ltr,
//                maxLines: 1,
//                inputFormatters: [
//                  WhitelistingTextInputFormatter(RegExp(
//                      "[a-zA-Z]|[\u4e00-\u9fa5]")),
//                  LengthLimitingTextInputFormatter(6),
//                ],
//                onChanged: (save) {
//                  if (widget.defaultvalue.toString() != save.trim()) {
//                    print('999999999');
//                    setState(() {});
//                  }
//                },
//              ),
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(left: 0, top: 0),
//            child: Text(
//              '真实姓名可以让同校同学更容易记住你.',
//              style: TextStyle(
//                  color: Colors.black26, fontSize: ScreenUtil().setSp(25)),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
