import 'package:common_utils/common_utils.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weui/weui.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as ale;

///作业批改页面
class RevisePage extends StatefulWidget {
  final bool teacher;
  final String endTime;
  final Map map;
  final num tscore;
  int status;

  RevisePage(
      {Key key,
      @required this.teacher,
      @required this.endTime,
      this.tscore,
      this.status = 0,
      this.map})
      : super(key: key);

  @override
  _RevisePageState createState() => _RevisePageState();
}

class _RevisePageState extends State<RevisePage> {
  List<String> files = [];
  int score = -1;
  String comment = '';

  Future<List> getFileList() async {
    if (files.isEmpty) {
      return null;
    }
    print(files);
    List list = await UserMethod.getClassWorkFileList(context, files);
    print(list);
    return list;
  }

  void commitRevise(BuildContext context, reviseId, score, {comment}) async {
    var map = await TeacherMethod.reviseStudentWork(context, reviseId, score,
        comment: comment);
    if (map != null) {
      Fluttertoast.showToast(msg: '提交成功');
      setState(() {
        widget.map['status'] = 2;
        widget.map['score'] = score;
        widget.map['comment'] = comment;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    files = widget.map['fids'].cast<String>();
    print(widget.map['rscore']);
  }

  @override
  Widget build(BuildContext context) {
    bool isComment = (ObjectUtil.isNotEmpty(widget.map['comment']));
    return Scaffold(
      appBar: AppBar(
        title: Text('作业批改'),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            margin: const EdgeInsets.only(bottom: 70),
            child: ListView(
              children: <Widget>[
                head(context),
                tip(),
                body(context),
                (isComment) ? commentWidget(context) : SizedBox(),
              ],
            ),
          ),
          (widget.teacher)
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 60,
                    color: Colors.black26,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: WeButton(
                            Text('批改'),
                            size: WeButtonSize.acquiescent,
                            onClick: () async {
                              //todo
                              var aler = await ale.Alert(
                                  context: context,
                                  title: "作业批改",
                                  content: Column(
                                    children: <Widget>[
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: '分数',
                                          hintText: '批改作业分数',
                                        ),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(5),
                                          //  WhitelistingTextInputFormatter白名单
                                          WhitelistingTextInputFormatter(
                                              RegExp("[0-9]")),
                                        ],
                                        onChanged: (value) {
                                          score = num.tryParse(value);
                                        },
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          labelText: '留言',
                                          hintText: '批改留言',
                                        ),
                                        maxLength: 200,
                                        maxLines: 3,
                                        inputFormatters: [],
                                        onChanged: (value) {
                                          comment = value;
                                        },
                                      ),
                                    ],
                                  ),
                                  buttons: [
                                    ale.DialogButton(
                                      child: Text(
                                        "提交",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        if (score == -1 ||
                                            ObjectUtil.isEmpty(score) ||
                                            score > widget.tscore) {
                                          showTip(context, '分数不能为空,且不能大于题目分数');
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
                              if (aler == true) {
                                debugPrint('id    ${widget.map['id']}');
                                commitRevise(context, widget.map['id'], score,
                                    comment: comment);
                              }
                            },
                            theme: WeButtonType.primary,
                          ),
                        )
                      ],
                    ),
                  ))
              : SizedBox(),
        ],
      ),
    );
  }

  Widget head(context) {
    String mess = '未提交';
    print(widget.map);
    if (widget.map['status'] == 2) {
      mess = '已批改';
    } else if (widget.map['status'] == 1) {
      mess = '未批改';
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 200,
      width: ScreenUtil.screenWidth,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black26, width: 1.0))),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(' 截止:${widget.endTime} | 个人作业'))
                ],
              )),
          Expanded(
              child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2)),
                alignment: Alignment.center,
                child: Text(
                  '${widget.tscore}分',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          )),
          Expanded(
              flex: 4,
              child: (widget.map['status'] == 2)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${mess}',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '批改分数: ${(widget.teacher) ? widget.map['score'] : widget.map['rscore']}',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${mess}',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
        ],
      ),
    );
  }

  Widget tip() {
    return Container(
      height: 30,
      width: ScreenUtil.screenWidth,
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text(
            '  作业详情',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget body(head) {
    return FutureBuilder(
        future: getFileList(),
        builder: (_, scope) {
          if (scope.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List list = scope.data;
          if (ObjectUtil.isEmpty(list)) {
            return NoDataWidget(title: '无作业文件', path: 'assets/img/nodata2.png');
          }

          List<String> image = [];
          list.forEach((element) {
            image.add(element['urlPath']);
          });

          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (_, index) {
                return InkWell(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 50,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/img/缺省-图片-加载.png',
                                  image: '${list[index]['urlPath']}'),
                            )),
                        Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('${list[index]['fileName']}'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('${list[index]['fsize'] / 1000} kb'),
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  onTap: () {
                    //todo
                    weImagePreview(context)(
                        images: image,
                        defaultIndex: image.indexWhere(
                            (element) => element == list[index]['urlPath']));
                  },
                );
              });
        });
  }

  Widget commentWidget(context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 200,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                Text(
                  '  教师留言',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  '  ${widget.map['comment']}',
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showTip(context, tip, {Color color = Colors.redAccent}) {
  WeNotify.show(context)(
      color: Colors.black,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.info_outline, color: color)),
        Text(
          '${tip}',
          style: TextStyle(color: color),
        )
      ]));
}
