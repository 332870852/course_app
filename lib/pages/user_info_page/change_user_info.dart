import 'package:course_app/provide/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

///修改名字
class ChangeUserInfoPage extends StatefulWidget {
  final defaultvalue;
  final appBarText;
  final info;

  final List<TextInputFormatter> textInputFormat;

  ChangeUserInfoPage(
      {Key key,
      @required this.defaultvalue,
      @required this.appBarText,
      this.info,
      this.textInputFormat})
      : super(key: key);

  @override
  _ChangeUserNamePageState createState() => _ChangeUserNamePageState();
}

class _ChangeUserNamePageState extends State<ChangeUserInfoPage> {
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: widget.defaultvalue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarText),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(false);
            }),
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
              onPressed:
                  (_controller.value.text.toString() == widget.defaultvalue ||
                          _controller.value.text.trim().length == 0)
                      ? null
                      : () {
                          //TODO
                          Navigator.pop(context, true);
                          Provide.value<UserProvide>(context).modif=_controller.value.text;
                        },
              child: Text('保存'),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              //  color: Colors.red,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              height: 50,
              child: TextFormField(
                controller: _controller,
                textDirection: TextDirection.ltr,
                maxLines: 1,
                inputFormatters: widget.textInputFormat,
                onChanged: (save) {
                  if (widget.defaultvalue.toString() != save.trim()) {
                    //print('999999999');
                    setState(() {});
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 0),
            child: Text(
              (widget.info != null) ? widget.info : '',
              style: TextStyle(
                  color: Colors.black26, fontSize: ScreenUtil().setSp(25)),
            ),
          )
        ],
      ),
    );
  }
}
