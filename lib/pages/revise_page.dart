import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:weui/weui.dart';

///作业批改页面
class RevisePage extends StatefulWidget {
  final bool teacher;
  final String endTime;
  final Map map;
  int status;

  RevisePage(
      {Key key,
      @required this.teacher,
      @required this.endTime,
      this.status = 0,
      this.map})
      : super(key: key);

  @override
  _RevisePageState createState() => _RevisePageState();
}

class _RevisePageState extends State<RevisePage> {
  @override
  Widget build(BuildContext context) {
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
                body(context),
              ],
            ),
          ),
          (widget.status == 0)
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
                            onClick: () {},
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
                  '${widget.map['score']}分',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          )),
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  (widget.map['status'] == 0) ? '未批改' : '已批改',
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

  Widget body(head) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 20,
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
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/img/缺省-图片-加载.png', image: '')),
                  Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('wenjian1'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('110KB'),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
            onTap: () {
              //todo
            },
          );
        });
  }
}
