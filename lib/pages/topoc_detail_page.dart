import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/topic_comement_dto.dart';
import 'package:course_app/data/topic_vo.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/ui/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:weui/weui.dart';
import 'package:course_app/provide/topic_provide.dart';

class TopicDetalPage extends StatefulWidget {
  TopicDetalPage(
      {Key key, @required this.dataSource, this.userInfoVo, this.annexes})
      : super(key: key);
  TopicVo dataSource;
  final UserInfoVo userInfoVo;
  final List annexes;

  @override
  _TopicDetalPageState createState() => _TopicDetalPageState();
}

class _TopicDetalPageState extends State<TopicDetalPage> {
  TextEditingController _textInputController;
  FocusNode _focusNode;
  List dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textInputController = new TextEditingController();
    _focusNode = new FocusNode();
    //getData();
  }

  @override
  void dispose() {
    _textInputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  getData() async {
    var res =
        await UserMethod.getTopicCommentList(context, widget.dataSource.id);
    if (res != null) {
//      setState(() {
//        dataList = res;
//      });
      dataList = res;
    }
    return dataList;
  }

  Future<UserInfoVo> getUserInfo(userId) async {
    if (userId == null) return null;
    return await UserMethod.getUserInfo(context, userId: userId);
  }

  sendComment({message, replayId = ''}) async {
    TopicCommentDto dto = new TopicCommentDto(
        topicId: widget.dataSource.id,
        content: message,
        replayId: replayId,
        publisher: Provide.value<UserProvide>(context).userId,
        createTime: DateTime.now().toIso8601String());
    var b =
        await UserMethod.createTopicComment(context, dto).catchError((onError) {
      Fluttertoast.showToast(msg: '${onError.toString()}');
    });
    if (b == true) {
      Fluttertoast.showToast(msg: '留言成功');
      setState(() {
        dataList.add(dto);
      });
      Provide.value<TopicProvide>(context).increamentCom(widget.dataSource.id);
    } else {
      Fluttertoast.showToast(msg: '留言失败');
    }
    return b;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('详情'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil.screenWidth,
              height: ScreenUtil.screenHeight,
              margin: new EdgeInsets.symmetric(horizontal: 10.0),
              padding: new EdgeInsets.only(bottom: 55.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 80,
                    width: ScreenUtil.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    '${widget.userInfoVo.faceImage}',
                                    cacheManager: DefaultCacheManager()),
                                minRadius: 20,
                                maxRadius: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${widget.userInfoVo.nickname}'),
                                        Text('${widget.dataSource.createTime}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: RichText(
                      text: TextSpan(
                          text:
                              (ObjectUtil.isEmptyString(widget.dataSource.tag))
                                  ? ''
                                  : '#${widget.dataSource.tag}\r\n',
                          children: [
                            TextSpan(
                              text: '${widget.dataSource.content}',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )
                          ],
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent)),
                      maxLines: 30,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Visibility(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.8,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      children: widget.annexes,
                    ),
                    visible: widget.annexes.isNotEmpty,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black26, width: 1.0))),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Provide<TopicProvide>(
                          builder: (_, child, data) {
                            int i = data.data.indexWhere((element) =>
                                element.id == widget.dataSource.id);
                            widget.dataSource.likeNums = data.data[i].likeNums;
                            return Row(
                              children: <Widget>[
                                LikeButton(
                                  width: 50,
                                  onIconClicked: (value) {
                                    UserMethod.commendationTop(
                                            context, widget.dataSource.id,
                                            like: value)
                                        .then((v) {
                                      if (v == true) {
                                        data.updateLikeNums(
                                            value, widget.dataSource.id,
                                            userId: Provide.value<UserProvide>(
                                                    context)
                                                .userId);
//                                        if (value) {
//                                          widget.dataSource.likeNums.add(
//                                              Provide.value<UserProvide>(
//                                                      context)
//                                                  .userId);
//                                        } else {
//                                          widget.dataSource.likeNums
//                                              .removeWhere((e) =>
//                                                  e ==
//                                                  Provide.value<UserProvide>(
//                                                          context)
//                                                      .userId);
//                                        }
//                                        setState(() {});
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  ' ${widget.dataSource.likeNums.length}',
                                  style: TextStyle(color: Colors.black26),
                                ),
                                SizedBox(width: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.message,
                                          color: Colors.black26,
                                        ),
                                        onPressed: () {
                                          if (!_focusNode.hasFocus) {
                                            FocusScope.of(context)
                                                .requestFocus(_focusNode);
                                          } else {
                                            _focusNode.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(_focusNode);
                                          }
                                        }),
                                    Text(
                                      '${widget.dataSource.commentNums}',
                                      style: TextStyle(color: Colors.black26),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //////////
                  pinlun(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.white,
//                height: 50,
                child: sendMessage(),
              ),
            ),
          ],
        ));
  }

  ///发送
  Widget sendMessage() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: TextField(
            focusNode: _focusNode,
            controller: _textInputController,
            maxLines: 6,
            minLines: 1,
            inputFormatters: [
              BlacklistingTextInputFormatter(
                  RegExp("[\uDF00-\uDFFF]|[\uDC00-\uDE4F]")),
            ],
            decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: '评论...',
                hintStyle: new TextStyle(color: Colors.black26)),
            onSubmitted: (val) {},
          ),
        ),
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () async {
                var message = _textInputController.value.text.trim();
                if (message.isEmpty) {
                  WeNotify.show(context)(
                      color: Colors.black,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.info_outline,
                                    color: Colors.yellow)),
                            Text(
                              '内容不能为空',
                              style: TextStyle(color: Colors.red),
                            )
                          ]));
                  return;
                }
                var b = await sendComment(message: message);
                if (b == true) {
                  _textInputController.clear();
                }
              },
              child: Text(
                '评论',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
            )),
      ],
    );
  }

  ///评论
  Widget pinlun() {
    return FutureBuilder(
        future: getData(),
        builder: (_, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.data.length,
            itemBuilder: (_, index) {
              return detail(data.data[index]);
            },
          );
        });
  }

  Widget detail(data) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder<UserInfoVo>(
          future: getUserInfo(data['publisher']),
          builder: (_, d) {
            if (d.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            print(d.data);
            return Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 2.0),
                    child: CircleAvatar(
                      backgroundImage: (ObjectUtil.isNotEmpty(d.data.faceImage))
                          ? CachedNetworkImageProvider('${d.data.faceImage}',
                              cacheManager: DefaultCacheManager())
                          : AssetImage('assets/img/user.png'),
                      minRadius: 20,
                      maxRadius: 20,
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${d.data.nickname}',
                              maxLines: 3,
                              style: TextStyle(color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${'${data['content']}'}',
                                style: TextStyle(fontSize: 20),
                                maxLines: 30,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          onLongPress: () {
                            Clipboard.setData(
                                ClipboardData(text: '${data['content']}'));
                            Fluttertoast.showToast(msg: '已复制到粘贴栏');
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${data['createTime']}',
                              style: TextStyle(color: Colors.black26),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            );
          }),
    );
  }
}
