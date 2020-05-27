import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///课堂测试详情页

class TestDetailPage extends StatefulWidget {
  final String pageTitle;
  final releaseTime;
  final endTime;
  final num submitted;
  final num unsubmitted;

  TestDetailPage(
      {Key key,
      @required this.pageTitle,
      this.releaseTime,
      this.endTime,
      this.submitted,
      this.unsubmitted})
      : super(key: key);

  @override
  _TestDetailPageState createState() => _TestDetailPageState();
}

class _TestDetailPageState extends State<TestDetailPage> {
  ///status

  //int questionStatus = 0;
  int currenIndex = 0; //当前题目索引
  ///0-刚开始，1-中间，2-最后一题


  var questionList = [];
  bool isLoading = true;

  getData() async {
    questionList = [
      {
        'index': 1,
        'topic': '6555555555asfas 题目内容,adifji十大科技股份滴哦价格粉底攻击的覅哦',
        'answer': 'BC',
        'parsing': '无',
        'isSingle': false,
        'score': 20,
        'correctRate': 95.3,
        'selectItem': [
          {'tag': 'A', 'content': '参加科学研究、科技学术活动或有科技发明', 'num': 12},
          {'tag': 'B', 'content': '课外科技文体竞赛（活动）获奖', 'num': 8},
          {'tag': 'C', 'content': '发表文学、艺术、新闻等作品', 'num': 4},
          {'tag': 'D', 'content': '出版著作', 'num': 1},
        ],
      },
      {
        'index': 2,
        'topic': 'hhh哈哈哈培育',
        'answer': 'B',
        'parsing': '无',
        'isSingle': true,
        'score': 10,
        'correctRate': 50.3,
        'selectItem': [
          {'tag': 'A', 'content': '参加科学研究、科技学术活动或有科技发明', 'num': 12},
          {'tag': 'B', 'content': '课外科技文体竞赛（活动）获奖', 'num': 8},
          {'tag': 'C', 'content': '发表文学、艺术、新闻等作品', 'num': 4},
          {'tag': 'D', 'content': '出版著作', 'num': 1},
        ],
      },
      {
        'index': 3,
        'topic': 'hhh哈faddsd哈哈培育',
        'answer': 'A',
        'parsing': '无',
        'isSingle': true,
        'score': 5,
        'correctRate': 74.33,
        'selectItem': [
          {'tag': 'A', 'content': '参加科学研究、科技学术活动或有科技发明', 'num': 12},
          {'tag': 'B', 'content': '课外科技文体竞赛（活动）获奖', 'num': 8},
          {'tag': 'C', 'content': '发表文学、艺术、新闻等作品', 'num': 4},
          {'tag': 'D', 'content': '出版著作', 'num': 1},
        ],
      },
    ];

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pageTitle}'),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Stack(
          children: <Widget>[
            body(
                correctRate: (isLoading)
                    ? '获取中..'
                    : '${questionList[currenIndex]['correctRate']}',
                releaseTime: '${widget.releaseTime}',
                endTime: '${widget.endTime}',
                commited: widget.submitted,
                uncommit: widget.unsubmitted),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            //todo
                            _openModalBottomSheet(context);
                          },
                          child: Text(
                            '题卡 ^',
                            style: TextStyle(color: Colors.green, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: btnItem(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body(
      {@required correctRate,
      releaseTime,
      endTime = '无',
      commited = 0,
      uncommit = 0}) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      padding: const EdgeInsets.only(bottom: 45.0, top: 5),
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('发布时间: ${releaseTime}'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('结束时间: ${endTime}'),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('本题正确率: '),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${correctRate}%',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  flex: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '提交人数: ${commited}',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      '未提交人数: ${uncommit}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          (isLoading)
              ? Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Wrap(
                  children: <Widget>[
                    subtitle(
                        isSingle: questionList[currenIndex]['isSingle'],
                        index: questionList[currenIndex]['index'],
                        total: questionList.length,
                        score: questionList[currenIndex]['score']),
                    content(
                        selectItem: questionList[currenIndex]['selectItem']),
                  ],
                ),
        ],
      ),
    );
  }

  Widget subtitle(
      {bool isSingle = true,
      int index = 1,
      int score = 10,
      @required int total}) {
    var queType = '';
    if (isSingle) {
      queType = '单选题';
    } else {
      queType = '多选题';
    }
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${index}',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Text(
                '/${total}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Container(
            width: 120,
            height: 30,
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.2)),
            alignment: Alignment.center,
            child: Text(
              '${queType}(${score}分)',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget content({
    @required List<dynamic> selectItem,
  }) {
    num totalNum = 0;
    selectItem.forEach((element) {
      totalNum += element['num'];
    });
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 18, right: 18),
      child: Flexible(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '题目描述:',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: ScreenUtil.screenWidth,
                maxHeight: 280,
                minWidth: ScreenUtil.screenWidth,
                minHeight: 100),
            child: Container(
                alignment: Alignment.topLeft,
                // color: Colors.red,
                child: ListView.builder(
                  itemCount: selectItem.length + 2,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Row(
                        children: <Widget>[
                          Container(
                            width: 300,
                            child: Text(
                              '${questionList[currenIndex]['topic']}',
                              maxLines: 20,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ],
                      );
                    } else if (index == selectItem.length + 1) {
                      return Row(
                        children: <Widget>[
                          Container(
                              width: 300,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '答案: ${questionList[currenIndex]['answer']}',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '解析: ${questionList[currenIndex]['parsing']}',
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${selectItem[index - 1]['tag']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                              flex: 8,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    LinearProgressIndicator(
                                      value: selectItem[index - 1]['num'] /
                                          totalNum,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            '${selectItem[index - 1]['content']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                '${selectItem[index - 1]['num']}(${(selectItem[index - 1]['num'] / totalNum) * 100}%)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.green),
                              )),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ],
      )),
    );
  }

  ///题卡按钮
  Widget btnItem() {
    if (currenIndex == 0) {
      return FlatButton(
        onPressed: () {
          setState(() {
            currenIndex = (currenIndex < questionList.length - 1
                ? currenIndex += 1
                : currenIndex);
          });
        },
        child: Text(
          '下一题',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
      );
    } else if (currenIndex == questionList.length - 1) {
      return FlatButton(
        onPressed: () {
          setState(() {
            currenIndex = (currenIndex > 0 ? currenIndex -= 1 : currenIndex);
          });
        },
        child: Text(
          '上一题',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                currenIndex = (currenIndex < questionList.length - 1
                    ? currenIndex += 1
                    : currenIndex);
              });
            },
            child: Text(
              '下一题',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                currenIndex =
                    (currenIndex > 0 ? currenIndex -= 1 : currenIndex);
              });
            },
            child: Text(
              '上一题',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
        ],
      );
    }
  }

  Future _openModalBottomSheet(
    context,
  ) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: ScreenUtil.screenWidth,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.black26, width: 1.0),
                  )),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                '关闭',
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: GridView.count(
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      crossAxisCount: 6,
                      children: questionList.map((e) {
                        return FlatButton(
                          onPressed: () {
                            num n = e['index'];
                            if (n < questionList.length + 1 && n > -1) {
                              setState(() {
                                currenIndex = n - 1;
                              });
                            }
                          },
                          child: Text(
                            '${e['index']}',
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          color: Colors.green.withOpacity(0.3),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          );
        });
    print(option);
  }
}
