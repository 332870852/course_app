import 'package:course_app/provide/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///完成创建试题

class UploadQuestPage extends StatefulWidget {
  final List questionList;
  final courseId;

  UploadQuestPage(
      {Key key, @required this.questionList, @required this.courseId})
      : super(key: key);

  @override
  _UploadQuestPageState createState() => _UploadQuestPageState();
}

class _UploadQuestPageState extends State<UploadQuestPage> {
  int totalScore = 0;

  ///总分
  ///单选题
  int singleNum = 0;
  var type = 0;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.questionList.forEach((element) {
      num s = element['score'];
      totalScore += s;
      if (element['isSingle'] == true) {
        singleNum++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('完成试题'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: ListView(
          children: <Widget>[
            Container(
              height: 150,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '总共 ${widget.questionList.length} 道题,累计 ${totalScore} 分',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '其中单选 ${singleNum} 道,多选 ${widget.questionList.length - singleNum}道 ',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('设置试卷标题'),
                ],
              ),
            ),
            Container(
              //margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              height: 60,
              child: TextField(
                style: TextStyle(fontSize: 25),
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  focusedBorder: OutlineInputBorder(),
                  hintText: '输入试卷标题(必填)',
                  hoverColor: Colors.black26,
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('选择类型:'),
                  Row(
                    children: <Widget>[
                      Text('练习'),
                      Radio(
                          value: 0,
                          groupValue: type,
                          onChanged: (T) {
                            setState(() {
                              type = T;
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('测试'),
                      Radio(
                          value: 1,
                          groupValue: type,
                          onChanged: (T) {
                            setState(() {
                              type = T;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                height: 150,
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CupertinoButton(
                        child: Text('提交试题'),
                        color: Colors.blue,
                        onPressed: () {
                          _sumbitmit();
                        }),
                    CupertinoButton(
                        child: Text('提交试题并发布'),
                        color: Colors.green,
                        onPressed: () {
                          _sumbitmit();
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sumbitmit() {
    String title = _controller.value.text.trim();
    if (title.isEmpty) {
      Fluttertoast.showToast(msg: '题目标题不能为空');
      return;
    }
    var m = {};
    m['courseId'] = widget.courseId;
    m['questionList'] = widget.questionList;
    m['exercise_title'] = title;
    m['release_time'] = DateTime.now().toIso8601String();
    m['isTest'] = true;
    m['publisher'] = Provide.value<UserProvide>(context).userId;
    print(m);
  }
}
