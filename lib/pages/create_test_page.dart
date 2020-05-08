import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/pages/upload_question_page.dart';
import 'package:course_app/utils/toast_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tip_dialog/tip_dialog.dart';

///创建试题
class CreateTestPage extends StatefulWidget {
  final courseId;

  CreateTestPage({Key key, @required this.courseId}) : super(key: key);

  @override
  _CreateTestPageState createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController headController;
  TextEditingController scoreController;
  TextEditingController parsingController;
  var initialValue = '';
  bool isLetter = true; //true-字母编号,false-数字
  bool isSingle = true; //单选
  num score = 0;
  var parsing = '';

  //////////////////////
  var questionList = [];
  Map item = {
    'index': 1,
    'topic': '',
    'answer': [],
    'parsing': '无',
    'isSingle': true,
    'score': 0,
  };
  var selItem = [
    {'tag': 'A', 'content': ''},
    {'tag': 'B', 'content': ''},
  ];

  ///答案
  var answer = [];
  int currentIndex = 1; //当前第几题
  initData({index = 1, it, isLett = true}) {
    isLetter = isLett; //true-字母编号,false-数字
    //currentIndex = index; //当前第几题
    if (it == null) {
      item = {
        'index': index,
        'topic': '',
        'answer': [],
        'parsing': '无',
        'isSingle': true,
        'score': 5,
      };
      isSingle = true; //单选
      answer = [];
      selItem = [
        {'tag': 'A', 'content': ''},
        {'tag': 'B', 'content': ''},
      ];
      headController.clear();
      scoreController.text = '5';
      parsingController.clear();
    } else {
      item = it;
      isSingle = item['isSingle']; //单选
      answer = item['answer'];
      selItem = questionList[index - 1]['selectItem'];
      headController.text = item['topic'];
      scoreController.text = '${item['score']}';
      parsingController.text = item['parsing'];
      print('item : ${item}');
    }
    //print('headController:  ${item['topic']}');
  }

  bool check() {
    if (item['topic'].toString().trim().length < 2) {
      ToastWeb.showInfoTip(context, tip: '题目内容必须2-1000字');
      return true;
    } else if (selItem[0]['content'].isEmpty || selItem[1]['content'].isEmpty) {
      ToastWeb.showInfoTip(context, tip: '选项不能为空');
      return true;
    } else if (answer.length == 0) {
      ToastWeb.showInfoTip(context, tip: '答案不能为空');
      return true;
    } else if (scoreController.value.text.trim().isEmpty) {
      ToastWeb.showInfoTip(context, tip: '分数不能为空');
      return true;
    }
    return false;
  }

  void _finish() {
    _formKey.currentState.save();
    if (check()) {
      return;
    }
    item.putIfAbsent('selectItem', () => selItem);
    item['isSingle'] = isSingle;
    item['answer'] = answer;
    item['index'] = currentIndex;
    if (!questionList.contains(item)) {
      questionList.add(item);
    }
    if (questionList.length == 0) {
      ToastWeb.showInfoTip(context, tip: '试题不能为空');
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => UploadQuestPage(
                  questionList: questionList,
                  courseId: widget.courseId,
                )));
  }

  void _forSubmitted() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      if (check()) {
        return;
      }
      //selItem.removeWhere((element) => element['content'].trim().isEmpty);
//      item.putIfAbsent('selectItem', () => selItem);
//      item['isSingle'] = isSingle;
//      item['answer'] = answer;
      var temp;
      if (currentIndex < questionList.length) {
        int i = questionList
            .indexWhere((element) => element['index'] == (currentIndex + 1));
        temp = questionList[i];
        initData(index: currentIndex, it: questionList[currentIndex]);
        //print('temp  ${temp}');
      } else {
        //_form.reset();
        item.putIfAbsent('selectItem', () => selItem);
        item['isSingle'] = isSingle;
        item['answer'] = answer;
        item['index'] = currentIndex;
        if (!questionList.contains(item)) {
          questionList.add(item);
        }
        initData(index: currentIndex, it: null);
      }

//      initData(index: currentIndex, it: temp);
      currentIndex += 1;
      setState(() {});
      print(questionList);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    headController = new TextEditingController(text: '');
    scoreController = new TextEditingController(text: '5');
    parsingController = new TextEditingController(text: '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    headController.dispose();
    scoreController.dispose();
    parsingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text('创建试题'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                //todo
                _finish();
              },
              child: Text(
                '完成',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 52.0),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    '第${currentIndex}题',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                head(),
                subtitle(),
                selectItem(),
                tip1(),
                setting(),
                answerAndParsing(),
              ],
            ),
          ),
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
                      child: btnOpt(),
                    ),
                  ],
                ),
              )),

          ///tip
          TipDialogContainer(duration: const Duration(seconds: 2))
        ],
      ),
    );
  }

  ///题卡
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
                            if (n < questionList.length + 1 && n > 0) {
                              currentIndex = n;
                              initData(
                                  index: currentIndex,
                                  it: questionList[currentIndex - 1]);
                              setState(() {});
                            }
                          },
                          child: Text(
                            '${e['index']}',
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          color: (e['index'] == currentIndex)
                              ? Colors.black.withOpacity(0.5)
                              : Colors.green.withOpacity(0.3),
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

  ///下一步
  Widget btnOpt() {
    if (currentIndex == 1) {
      return FlatButton(
        onPressed: () {
          _forSubmitted();
        },
        child: Text(
          '保存并下一题',
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
              _forSubmitted();
            },
            child: Text(
              '保存并下一题',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
          FlatButton(
            onPressed: () {
              currentIndex =
                  (currentIndex > 1 ? currentIndex -= 1 : currentIndex);
              initData(index: currentIndex, it: questionList[currentIndex - 1]);
              setState(() {});
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

  ///答案和解析
  Widget answerAndParsing() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.white),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 200,
          minWidth: 100,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('设置正确答案'),
              ],
            ),
            Flexible(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 0, bottom: 30),
                shrinkWrap: true,
                //解决无限高度问题
                physics: new NeverScrollableScrollPhysics(),
                children: selItem.map((e) {
                  return FilterChip(
                      label: Text(
                        e['tag'],
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey,
                      selectedColor: Colors.green,
                      selected: answer.contains(e['tag']),
                      checkmarkColor: Colors.white,
                      onSelected: (value) {
                        if (isSingle) {
                          answer.clear();
                          int index = selItem.indexWhere(
                              (element) => element['tag'] == e['tag']);
                          if (index != -1 &&
                              selItem[index]['content']
                                      .toString()
                                      .trim()
                                      .length >
                                  0) {
                            answer.add(e['tag']);
                          } else {
                            ToastWeb.showInfoTip(context,
                                tip: '选项${e['tag']} ,内容不能为空');
                            return;
                          }
                        } else {
                          if (!answer.contains(e['tag'])) {
                            answer.add(e['tag']);
                          } else {
                            answer.remove(e['tag']);
                          }
                        }
                        setState(() {});
                      });
                }).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              //alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[Text('设置解析')],
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
                controller: parsingController,
                maxLines: 5,
                maxLength: 800,
                decoration: InputDecoration(
                  hintText: '输入答案解析',
                  hoverColor: Colors.black26,
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  item['parsing'] = value.trim();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///设置题目类型和分数
  Widget setting() {
    return Container(
      height: 110,
      //decoration: BoxDecoration(color: Colors.white),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('题目类型'),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FilterChip(
                          label: Text(
                            '单选',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          selectedColor: Colors.green,
                          selected: isSingle,
                          checkmarkColor: Colors.white,
                          onSelected: (value) {
                            setState(() {
                              isSingle = true;
                            });
                            answer.clear();
                          },
                        ),
                        FilterChip(
                          label: Text(
                            '多选',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          selectedColor: Colors.green,
                          selected: !isSingle,
                          checkmarkColor: Colors.white,
                          onSelected: (value) {
                            setState(() {
                              isSingle = false;
                            });
                            answer.clear();
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('题目分值'),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: scoreController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 25),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '设置题目分值',
                              hoverColor: Colors.black26,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                              //  WhitelistingTextInputFormatter白名单
                              WhitelistingTextInputFormatter(RegExp("[0-9]")),
                              BlacklistingTextInputFormatter(
                                  RegExp("[\u4e00-\u9fa5]")), //黑名
                            ],
                            onSaved: (value) {
                              item['score'] = num.tryParse(value);
                            },
                          ),
                        ),
                        Text(
                          '分',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          //ListTile(),
        ],
      ),
    );
  }

  Widget tip1() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[Text('最多支持10个选项')],
      ),
    );
  }

  ///选择选项
  Widget selectItem() {
    return Container(
      margin: const EdgeInsets.only(
        top: 5,
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: ListView.builder(
          itemCount: selItem.length,
          shrinkWrap: true, //解决无限高度问题
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            String label = '';
            if (isLetter) {
              label = '${String.fromCharCode(65 + index)}';
            } else {
              label = '${index + 1}';
            }
            bool isAdd = (index == selItem.length - 1);
            return Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  (index != 0)
                      ? Container(
                          width: 50,
                          child: IconButton(
                              icon: (isAdd && index != 9)
                                  ? Icon(
                                      Icons.add_circle,
                                      color: Colors.blue,
                                    )
                                  : Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                              onPressed: () {
                                if (isAdd && index != 9) {
                                  if (selItem[index]['content'].trim().length ==
                                      0) {
                                    Fluttertoast.showToast(msg: '该选项不能为空');
                                    return;
                                  }
                                  if (num.tryParse(label) == null) {
                                    label = String.fromCharCode(
                                        label.codeUnitAt(0) + 1);
                                  } else {
                                    label = '${num.parse(label) + 1}';
                                  }
                                  var question = {'tag': label, 'content': ''};
                                  selItem.add(question);
                                  setState(() {});
                                } else {
                                  //print('aaaaaa  ${questionList}');
                                  int i = 0, del = -1;
                                  selItem.forEach((element) {
                                    if (element['tag'] == label) {
                                      // print('    ${element['tag']}');
                                      del = i;
                                    }
                                    i++;
                                  });
                                  if (del != -1) {
                                    selItem.removeAt(del);
                                    if (answer.contains(selItem[del]['tag'])) {
                                      answer.removeWhere((element) =>
                                          element == selItem[del]['tag']);
                                    }
                                    for (int j = 0; j < selItem.length; j++) {
                                      if (isLetter) {
                                        selItem[j]['tag'] =
                                            '${String.fromCharCode(65 + j)}';
                                        print('${selItem[j]}');
                                      } else {
                                        selItem[j]['tag'] = '${j + 1}';
                                      }
                                    }
                                    setState(() {});
                                  }
                                }
                              }),
                        )
                      : Container(
                          width: 50,
                        ),
                  Flexible(
                      child: TextFormField(
                    initialValue: selItem[index]['content'],
                    decoration: InputDecoration(
                      hintText: ' 选项${label}',
                      hoverColor: Colors.black26,
                      prefixIcon: Container(
                        width: 35,
                        color: Colors.black26,
                        child: Text(
                          '${label}',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    onSaved: (value) {
                      if (value.trim().length > 0) {
                        selItem[index]['tag'] = label;
                        selItem[index]['content'] = value;
                      } else if (index > 1 && selItem.length > index) {
                        selItem.removeAt(index);
                        if (answer.contains(selItem[index]['tag'])) {
                          answer.remove(selItem[index]['tag']);
                        }
                      }
                    },
                    onChanged: (value) {
                      selItem[index]['tag'] = label;
                      selItem[index]['content'] = value;
                    },
                  )),
                ],
              ),
            );
            //}
          }),
    );
  }

  Widget subtitle() {
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
      ),
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                  value: true,
                  groupValue: isLetter,
                  onChanged: (T) {
                    for (int j = 0; j < selItem.length; j++) {
                      selItem[j]['tag'] = '${String.fromCharCode(65 + j)}';
                    }
                    answer.clear();
                    setState(() {
                      isLetter = T;
                    });
                  }),
              Text('字母编号,A-Z')
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  value: false,
                  groupValue: isLetter,
                  onChanged: (T) {
                    for (int j = 0; j < selItem.length; j++) {
                      selItem[j]['tag'] = '${j + 1}';
                    }
                    setState(() {
                      isLetter = T;
                    });
                    answer.clear();
                  }),
              Text('数字编号,0,1,2..')
            ],
          ),
        ],
      ),
    );
  }

  ///题目内容
  Widget head() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black26, width: 1.0),
            bottom: BorderSide(color: Colors.black26, width: 1.0),
          )),
      margin: const EdgeInsets.only(top: 10, left: 2, right: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: TextFormField(
        controller: headController,
        maxLength: 1000,
        maxLines: 6,
//        focusNode: FocusNode() ,
        decoration: InputDecoration(
            hintText: '输入题目内容,2-1000字',
            hoverColor: Colors.black26,
            border: InputBorder.none),
        onSaved: (vaule) {
          item['topic'] = vaule.toString();
        },
      ),
    );
  }
}
