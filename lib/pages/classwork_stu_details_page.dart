import 'package:course_app/pages/revise_page.dart';
import 'package:course_app/provide/commit_classwork_provide.dart';
import 'package:course_app/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:weui/button/index.dart';
import 'package:weui/image_preview/index.dart';

import 'commit_classwork_page.dart';

class ClassworkStuDetailPage extends StatefulWidget {
  Map dataSource;
  final endTime;

  ClassworkStuDetailPage(
      {Key key, @required this.dataSource, this.endTime = ''})
      : super(key: key);

  @override
  _ClassworkStuDetailPageState createState() => _ClassworkStuDetailPageState();
}

class _ClassworkStuDetailPageState extends State<ClassworkStuDetailPage> {
  List<String> annex = [];
  bool isCommit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    annex = widget.dataSource['annex'].cast<String>();
    isCommit = (widget.dataSource['status'] == 3); //未提交
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dataSource['title']}'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        //margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: ListView(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil.screenWidth,
                      maxHeight: 100,
                      minHeight: 100,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: MyTextAnimate(
                                text: '${widget.dataSource['title']}',
                                colors: [
                                  Colors.blueAccent,
                                  Colors.greenAccent,
                                  Colors.blueAccent
                                ],
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w500),
                              ),
//                            Text(
//                              '${widget.dataSource['title']}',
//                              maxLines: 2,
//                              style: TextStyle(
//                                  fontSize: 23, fontWeight: FontWeight.w500),
//                              overflow: TextOverflow.ellipsis,
//                            ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '截止时间: ${widget.endTime}',
                              style:
                              TextStyle(fontSize: 15, color: Colors.black26),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2)),
                              alignment: Alignment.center,
                              child: Text(
                                '${widget.dataSource['score']}(分)',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Text(
                        '${widget.dataSource['content']}',
                        style: TextStyle(fontSize: 20),
                      ),
                      (annex.isNotEmpty)
                          ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 100,
                            maxWidth: ScreenUtil.screenWidth,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: PageView(
                              children: annex
                                  .map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    weImagePreview(context)(
                                        images: annex,
                                        defaultIndex: annex.indexWhere(
                                                (element) => element == e));
                                  },
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/img/图片加载中.png',
                                    image: '${e}',
                                    fit: BoxFit.fill,
                                  ),
                                );
                              })
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          ))
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 60,
                  color: Colors.black.withOpacity(0.1),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: WeButton(
                          Text((isCommit) ? '提交作业' : '查看批改'),
                          size: WeButtonSize.acquiescent,
                          onClick: () async {
                            //todo
                            if(isCommit){//提交作业
                              Provide.value<CommitClassWorkProvide>(context)
                                  .initData();
                              var b = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CommitClassWorkPage(
                                        endTime: widget.endTime,
                                        map: widget.dataSource,
                                      )));
                              if (b != null && b == true) {
                                print('---${b}');
                                setState(() {
                                  isCommit = false;
                                });
                              }
                            }else{//查看批改
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RevisePage(
                                        teacher:false,
                                        tscore: widget.dataSource['score'],
                                        endTime: widget.endTime,
                                        map: widget.dataSource,
                                      )));
                            }

                          },
                          theme: (isCommit)
                              ? WeButtonType.warn
                              : WeButtonType.primary,
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget head(
    context,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black26, width: 1.0))),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MyTextAnimate(
                            text: '${widget.dataSource['title']}',
                            colors: [
                              Colors.blueAccent,
                              Colors.greenAccent,
                              Colors.blueAccent
                            ],
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w500),
                          ),
//                            Text(
//                              '${widget.dataSource['title']}',
//                              maxLines: 2,
//                              style: TextStyle(
//                                  fontSize: 23, fontWeight: FontWeight.w500),
//                              overflow: TextOverflow.ellipsis,
//                            ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '截止时间: ${widget.endTime}',
                          style: TextStyle(fontSize: 15, color: Colors.black26),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2)),
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.dataSource['score']}(分)',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Flexible(
              flex: 6,
              child: ListView(
                children: <Widget>[
                  Text(
                    '${widget.dataSource['content']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  (annex.isNotEmpty)
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 100,
                            maxWidth: ScreenUtil.screenWidth,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: PageView(
                              children: annex
                                  .map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        weImagePreview(context)(
                                            images: annex,
                                            defaultIndex: annex.indexWhere(
                                                (element) => element == e));
                                      },
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/img/图片加载中.png',
                                        image: '${e}',
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  })
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          ))
                      : Container(),
                ],
              ))
        ],
      ),
    );
  }
}
