import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/chat/chat_info.dart';
import 'package:course_app/data/chat/chat_model.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/pages/chat/pic_view.dart';
import 'package:course_app/pages/chat/video_view_page.dart';
import 'package:course_app/provide/chat/chat_detail_provide.dart';
import 'package:course_app/provide/chat/chat_message_provide.dart';
import 'package:course_app/provide/chat/flush_bar_util.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/service/chat_service.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/test/webrtc_demo.dart';
import 'package:course_app/utils/softwareUtil.dart';
import 'package:course_app/utils/video_image_thumb_util.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:async/async.dart';

class ChatDetailsPage extends StatefulWidget {
  //List<Chat> chatList;
  String myUserId;
  String friendId;
  String friendName;
  String myHeadUrl;
  String friendUrl;
  String myName;

  ChatDetailsPage({
    Key key,
    @required this.friendId,
    this.friendName,
    this.myUserId,
    this.myHeadUrl,
    this.friendUrl,
    this.myName,
  }) : super(key: key);

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage>
    with SingleTickerProviderStateMixin {
//  bool talkFOT = false;
//  bool otherFOT = false;
//  bool diableBtn = false;
  FocusNode fsNode1;
  TextEditingController _textInputController;
  Animation animationTalk;
  AnimationController controller;
  ScrollController _scrollController;
  List<Widget> talkWidgetList = <Widget>[];
  List<Chat> talkHistory = [];
  int localImgId = 0; //-1 上传成功
  AsyncMemoizer _memoizer;

  ///发送的格式
  ChatMessage sendMsg;

  bool isInit = false;

  @override
  void initState() {
    super.initState();
    fsNode1 = new FocusNode();
    _textInputController = new TextEditingController();
    _scrollController = new ScrollController();
    controller = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);
    animationTalk = new Tween(begin: 1.0, end: 1.5).animate(controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    sendMsg = new ChatMessage(
      senderId: widget.myUserId,
      receiverId: widget.friendId,
    );
  }

  @override
  void dispose() {
    fsNode1.dispose();
    _textInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    debugPrint('dea.......');
    Provide.value<ChatMessageProvide>(context).cureentFriendId = '';
    Provide.value<ChatMessageProvide>(context).updateUnRead(widget.friendId, 0);
  }

  Future<List<Media>> getLocalMediaPath(String type) async {
    List<Media> _listImagePaths;
    if (type == 'image') {
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showCamera: true,
        compressSize: 500,

        ///超过500KB 将压缩图片
        //uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
        // cropConfig: CropConfig(enableCrop: true, width: 1, height: 1)
      );
    } else if (type == 'video') {
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.video,
        selectCount: 1,
        showCamera: true,
        compressSize: 1024 * 15,

        ///超过15MB 将压缩图片
      );
    } else if (type == 'camara') {
      Media media = await ImagePickers.openCamera(compressSize: 500);
      _listImagePaths = [];
      _listImagePaths.add(media);
    }
    SoftWareUtil.saveAlunmPermisson(true);
    return _listImagePaths;
  }

  //发送图片
  void sendImage(List<Media> _listImagePaths) {
    int imgId = localImgId++;
    debugPrint('sendImage  ${imgId}');
    UserHeadImage userHeadImage = new UserHeadImage(
        userId: imgId,
        faceImage: _listImagePaths[0].thumbPath,
        faceImageBig: _listImagePaths[0].path);
    //插入本地照片
    Chat chat = new Chat(
        myUserId: '${widget.myUserId}',
        myName: '${widget.myName}',
        myHeadUrl: '${widget.myHeadUrl}',
        friendId: '${widget.friendId}',
        userName: '${widget.friendName}',
        userHeadUrl: '${widget.friendUrl}',
        readAt: 0);
    chat.content = userHeadImage;
    chat.type = 3;
    String time = DateTime.now().toIso8601String().substring(0, 19);
    chat.createAt = time.substring(11, 16);

    //插入本地
    Provide.value<ChatMessageProvide>(context).insertTalk(chat);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: new Duration(seconds: 1),
          curve: Curves.ease);
    }
    //上传图片
    Flushbar bar = FlushBarUtil.getFlushBar(null, //Duration(seconds: 4),
        //title: '温馨提示',
        titleText: Text(
          '温馨提示',
          style: TextStyle(color: Colors.yellow[600], fontSize: 18),
        ),
        messageText: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: FileImage(
                File(_listImagePaths[0].path),
              ),
              maxRadius: 20,
              minRadius: 20,
            ),
            Text(
              '  图片上传中...',
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ],
        ),
        isDismissible: true,
        showProgressIndicator: true)
      ..show(context);
    UserMethod.uploadChatImageBase64(context, _listImagePaths[0].path,
            timeout: 60 * 1000)
        .then((onValue) async {
      if (onValue != null) {
        UserHeadImage n = new UserHeadImage(
            userId: -1,
            faceImage: userHeadImage.faceImage,
            faceImageBig: userHeadImage.faceImageBig); //-1表示上传成功，跟新图片
        n.userId = -1;
        Provide.value<ChatMessageProvide>(context)
            .modifyImgTalk(widget.friendId, imgId, n);
        sendMsg.msgType = 2;
        sendMsg.msg = onValue.faceImageBig;
        sendMsg.createTime = DateTime.now().toIso8601String().substring(0, 19);
        bool suc = await Application.nettyWebSocket
            .getChatService()
            .send(ChatActionEnum.CHAT, sendMsg);
        if (suc == false) {
          Fluttertoast.showToast(msg: '网络失败');
        }
      }
    }).whenComplete(() {
      if (bar.isShowing()) {
        bar.dismiss();
      }
    });
  }

  //获取本地图片
  void getImage() async {
    debugPrint(' getImage');
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    List<Media> _listImagePaths = await getLocalMediaPath('image');
    sendImage(_listImagePaths);
  }

  //获取本地视频
  void getVideo() async {
    List<Media> _listImagePaths = await getLocalMediaPath('video');
    File fp = File('${_listImagePaths[0].path}');
    int length = fp.lengthSync();
    double size = length / (1000000);
    if (size > 150.0) {
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("选择视频失败"),
            content: Text('禁止上传大于300MB的大文件'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
      debugPrint('length :${length} size :${size}');
      return;
    } else {
      //todo 上传视频
      Chat chat = new Chat(
          myUserId: '${widget.myUserId}',
          myName: '${widget.myName}',
          myHeadUrl: '${widget.myHeadUrl}',
          friendId: '${widget.friendId}',
          userName: '${widget.friendName}',
          userHeadUrl: '${widget.friendUrl}',
          readAt: 0);
      chat.type = 5;
      String time = DateTime.now().toIso8601String().substring(0, 19);
      chat.createAt = time.substring(11, 16);
      chat.content = fp.path;
      //插入本地
      Provide.value<ChatMessageProvide>(context).insertTalk(chat);
      //上传
//      MediaInfo info = await videoCompressUtil.getVideoInfo(fp.path);
//      print('${info.title}  : ${info.width}  :${info.height}  :${NumUtil.divide(info.filesize, 1000000)}  :${info.duration} ${info.author}');
      Flushbar bar = FlushBarUtil.getFlushBar(null, //Duration(seconds: 4),
          //title: '温馨提示',
          titleText: Text(
            '温馨提示: 视频上传中...',
            style: TextStyle(color: Colors.yellow[600], fontSize: 18),
          ),
          messageText: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${fp.path}',
                  style: TextStyle(color: Colors.green, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          isDismissible: true,
          showProgressIndicator: true)
        ..show(context);
      UserMethod.uploadChatVideo(context, fp.path,
          onSendProgress: (total, size) {
        debugPrint('sends :${total} ${size}');
      }).then((url) async {
        if (!ObjectUtil.isEmptyString(url)) {
          ChatMessage sendMsg = ChatMessage(
            senderId: widget.myUserId,
            receiverId: widget.friendId,
            msg: url,
            msgType: 5,
            createTime: time,
          );
          bool suc = await Application.nettyWebSocket
              .getChatService()
              .send(ChatActionEnum.CHAT, sendMsg);
        }
      }).whenComplete(() {
        if (bar.isShowing()) {
          bar.dismiss();
        }
      });
    }
  }

  //相机
  getCamara() async {
    List<Media> _listImagePaths = await getLocalMediaPath('camara');
    sendImage(_listImagePaths);
  }

  //刷新界面列表
  getTalkList() {
    debugPrint('getTalkList');
    List<Widget> widgetList = [];
    talkHistory =
        Provide.value<ChatMessageProvide>(context).msgMap[widget.friendId];
    for (var i = 0; i < talkHistory.length; i++) {
      widgetList.add(returnTalkItem(talkHistory[i].toJson()));
    }
    talkWidgetList = widgetList;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 50.0,
          duration: new Duration(seconds: 1),
          curve: Curves.ease);
    }
//    setState(() {
//      talkWidgetList = widgetList;
//      if (_scrollController.hasClients) {
//        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//            duration: new Duration(seconds: 1), curve: Curves.ease);
//      }
//    });
  }

  //发送
  sendTalk(val, type) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String time = DateTime.now().toIso8601String().substring(0, 19);
    Chat chat = new Chat(
      myUserId: '${widget.myUserId}',
      myName: '${widget.myName}',
      myHeadUrl: '${widget.myHeadUrl}',
      friendId: '${widget.friendId}',
      userName: '${widget.friendName}',
      userHeadUrl: '${widget.friendUrl}',
      content: val,
      type: type,
      readAt: 0,
      createAt: time.substring(11, 16),
    );
    ChatMessage sendMsg = ChatMessage(
      senderId: widget.myUserId,
      receiverId: widget.friendId,
      msg: val,
      msgType: type,
      createTime: time,
    );
    //todo send to netty
    bool suc = await Application.nettyWebSocket
        .getChatService()
        .send(ChatActionEnum.CHAT, sendMsg);
    if (suc == false) {
      Fluttertoast.showToast(msg: '网络失败');
    }
    debugPrint('${suc}');
    // history
    Provide.value<ChatMessageProvide>(context).insertTalk(chat);
    getTalkList();
  }

  returnTalkType(type, val) {
    switch (type) {
      case 1:
        {
          return InkWell(
            child: new Text(val,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 100,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  height: 1,
                  fontSize: ScreenUtil().setSp(30),
                )),
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: '${val}'));
              Fluttertoast.showToast(msg: '已复制到粘贴栏');
              var text = Clipboard.getData(Clipboard.kTextPlain);
            },
          );
        }

        break;
      case 2: //加载网络图片
        {
          //userHeadImage.userId
          return new InkWell(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              child: CachedNetworkImage(
//              height: 150,
//              width: 100,
                imageUrl: '${val}',
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return SpinKitFadingFour(
                    color: Colors.grey,
                  );
                },
                cacheManager: DefaultCacheManager(),
                errorWidget: (BuildContext context, String url, Object error) {
                  print("assets/img/网络失败.png${url}");
                  return Image.asset('assets/img/公告-暂无内容.png');
                },
              ),
            ),
            onTap: () {
              NavigatorUtil.goImageViewPage(context, '${val}',
                  isNetUrl: 'true');
            },
          );
        }
        break;
      case 3:
        {
          //本地图片
          UserHeadImage userHeadImage = val;
//          debugPrint('本地图片 3 ${userHeadImage.faceImage} ${userHeadImage.userId}');
          return new InkWell(
            onTap: () {
              //todo
              NavigatorUtil.goImageViewPage(context, userHeadImage.faceImageBig,
                  isNetUrl: 'false');
            },
            child: Container(
              width: 100,
              height: 150,
              child: (userHeadImage.userId != -1)
                  ? CupertinoActivityIndicator()
                  : null,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File('${userHeadImage.faceImage}')),
                    fit: BoxFit.cover),
              ),
            ),
          );
        }
        break;
      case 4:
        {
          //url地址
          return new InkWell(
            onTap: () async {
              if (await canLaunch(val)) {
                launch(val);
              } else {
                Fluttertoast.showToast(msg: '无法打开的网址');
              }
            },
            child: Text(
              val,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  height: 1,
                  fontSize: 30,
                  //ScreenUtil().setSp(30)
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black87,
                  wordSpacing: 2.0,
                  decorationThickness: 2.0),
            ),
          );
        }
        break;
      case 5:
        {
          //视频
          ///生成suolue图
          if (RegexUtil.isURL(val)) {
            //url
            VideoThumbUtil videoThumbUtil = VideoThumbUtil(pathUrl: val);
            return new FutureBuilder<Uint8List>(
                future: videoThumbUtil.genThumbnailDATA(
                    maxWidth: 200, maxHeight: 200), //
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    return SpinKitFadingFour(
                      color: Colors.grey,
                    );
                  }
                  Uint8List bytes = data.data;
                  return InkWell(
                    onTap: () {
                      //todo 打开观看视频
                      NavigatorUtil.goVideoViewPage(context, val);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      width: 160,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(bytes), fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 30.0,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            VideoCompressUtil videoCompressUtil = VideoCompressUtil();
            return FutureBuilder(
                future: videoCompressUtil.getGifFile(val),
                //videoCompressUtil.getGifFile(val),
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    return SpinKitFadingFour(
                      color: Colors.grey,
                    );
                  }
                  return InkWell(
                    onTap: () {
                      //todo 打开观看视频
                      NavigatorUtil.goVideoViewPage(context, val);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      width: 160,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(data.data), fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 30.0,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                });
          }
        }
        break;
      case 6:
        {
          break;
        }
    }
  }

  returnTalkItem(Map item) {
    List<Widget> widgetList = [];
    print(
        '${item['myUserId']}  ${widget.myUserId}  ${item['myUserId'] == widget.myUserId} ${item['friendId']}');
    if (item['myUserId'] == widget.myUserId) {
      // 本人的信息
      widgetList = [
        new Container(
          margin: const EdgeInsets.only(right: 20.0),
          padding: const EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              borderRadius: new BorderRadius.circular(10.0)),
          child: new LimitedBox(
              maxWidth: MediaQuery.of(context).size.width - 120.0,
              child: returnTalkType(
                item['type'],
                item['content'],
              )),
        ),
        new CircleAvatar(
          backgroundImage: new NetworkImage('${item['myHeadUrl']}'),
        ),
      ];
    } else {
      // 非本人的信息
      widgetList = [
        new CircleAvatar(
          backgroundImage: new NetworkImage('${item['userHeadUrl']}'),
        ),
        new Container(
            margin: new EdgeInsets.only(left: 20.0),
            padding: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
                color: Color(0xFFebebf3),
                borderRadius: new BorderRadius.circular(10.0)),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width - 120.0,
                    child: returnTalkType(
                      item['type'],
                      item['content'],
                    )),
                new Container(
                  child: Text(
                    item['createAt'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 200, 200, 200)),
                  ),
                ),
              ],
            )),
      ];
    }
    return new Container(
        width: MediaQuery.of(context).size.width - 120.0,
        margin: new EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
            mainAxisAlignment: widget.myUserId == item['myUserId']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetList));
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build...');
    Provide.value<ChatMessageProvide>(context).cureentFriendId =
        widget.friendId;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.friendName}'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Stack(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              padding: new EdgeInsets.only(bottom: 50.0),
              // width: MediaQuery.of(context).size.width - 40.0,
              child: EasyRefresh.custom(
                scrollController: _scrollController,
                slivers: <Widget>[
                  Provide<ChatMessageProvide>(
                    builder: (_, child, data) {
                      List<Widget> widgetList = [];
                      talkHistory = data.getFriendTalk(widget.friendId);
                      if (talkHistory != null) {
                        for (var i = 0; i < talkHistory.length; i++) {
                          widgetList
                              .add(returnTalkItem(talkHistory[i].toJson()));
                          print(talkHistory[i]);
                        }
                        print('@ ${_scrollController.offset}');
                        print('@max ${_scrollController.position.maxScrollExtent}');
                        if (isInit &&
                            _scrollController.hasClients &&
                            _scrollController.position.maxScrollExtent >
                                _scrollController.offset+150) {
                          debugPrint('jumpTo...');
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent + 100);
                        }
                        talkWidgetList = widgetList;
                      }
                      isInit = true;
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return talkWidgetList[index];
                      }, childCount: talkWidgetList.length));
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                  //SliverFillRemaining(hasScrollBody: false,),
                ],
                header: MaterialHeader(),
                onRefresh: () {},
              ),
            ),
            new Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Color(0xFFebebf3),
                child: Provide<ChatDetailProvide>(
                  builder: (_, child, data) {
                    return new Column(
                      children: <Widget>[
                        new Offstage(
                          offstage: data.talkFOT,
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 10.0),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                width:
                                    MediaQuery.of(context).size.width - 100.0,
                                child: new TextField(
                                  focusNode: fsNode1,
                                  controller: _textInputController,
                                  maxLines: 6,
                                  minLines: 1,
                                  inputFormatters: [
                                    BlacklistingTextInputFormatter(RegExp(
                                        "\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]")),
                                  ],
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '输入你的信息...',
                                      hintStyle:
                                          new TextStyle(color: Colors.black26)),
                                  onSubmitted: (val) {
                                    if (val != '' && val != null) {
                                      getTalkList();
                                    }
                                    _textInputController.clear();
                                  },
                                  onChanged: (ch) {
                                    if (ObjectUtil.isNotEmpty(ch) &&
                                        data.sendBtn == false) {
                                      data.changeSendBtn(true);
                                    } else if (!ObjectUtil.isNotEmpty(ch) &&
                                        data.sendBtn == true) {
                                      data.changeSendBtn(false);
                                    }
                                  },
                                ),
                              ),
                              Flexible(
                                child: new IconButton(
                                  icon: Icon(
                                    Icons.send, //insert_emoticon
                                  ),
                                  color: Colors.blue,
                                  disabledColor: Colors.black26,
                                  onPressed: (data.sendBtn)
                                      ? () {
                                          //todo send
                                          String msg =
                                              _textInputController.value.text;
                                          if (ObjectUtil.isNotEmpty(msg)) {
                                            if (RegexUtil.isURL(msg)) {
                                              sendTalk(msg, 4); //url
                                            } else {
                                              sendTalk(msg, 1);
                                            }
                                            _textInputController.clear();
                                            data.changeSendBtn(false);
                                            fsNode1.unfocus();
//                                            setState(() {
//                                              diableBtn = false;
//                                            });
                                          }
                                        }
                                      : null,
                                ),
                              ),
                              Flexible(
                                  child: new IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Color(0xFF707072)),
                                onPressed: () {
                                  fsNode1.unfocus();
                                  data.changeOtherFOT(!data.otherFOT);
//                                  setState(() {
//                                    fsNode1.unfocus();
//                                    otherFOT = !otherFOT;
//                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        new Offstage(
                            // 录音按钮
                            offstage: !data.talkFOT,
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  height: 30.0,
                                  color: Color(0xFFededed),
                                  alignment: Alignment.centerLeft,
                                  child: new IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      controller.reset();
                                      controller.stop();
                                      data.changeTalkFOT(!data.talkFOT);
//                                      setState(() {
//                                        talkFOT = !talkFOT;
//                                      });
                                    },
                                  ),
                                ),
                                new Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 170.0,
                                  color: Color(0xFFededed),
                                  child: new Center(
                                      child: new AnimatedBuilder(
                                    animation: animationTalk,
                                    builder: (_, child) {
                                      return new GestureDetector(
                                        child: new CircleAvatar(
                                          radius: animationTalk.value * 30,
                                          backgroundColor: Color(0x306b6aba),
                                          child: new Center(
                                            child: Icon(Icons.keyboard_voice,
                                                size: 30.0,
                                                color: Color(0xFF6b6aba)),
                                          ),
                                        ),
                                        onLongPress: () {
                                          controller.forward();
                                        },
                                        onLongPressUp: () {
                                          controller.reset();
                                          controller.stop();
                                        },
                                      );
                                    },
                                  )),
                                ),
                              ],
                            )),
                        new Offstage(
                            // 图片选择
                            offstage: !data.otherFOT,
                            child: new Padding(
                                padding: new EdgeInsets.all(10.0),
                                child: new Column(
                                  children: <Widget>[
                                    new Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 170.0,
                                        color: Color(0xFFededed),
                                        child: Wrap(
                                          spacing: 25.0,
                                          runSpacing: 10.0,
                                          children: <Widget>[
                                            new Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              color: Color(0xFFffffff),
                                              child: new IconButton(
                                                iconSize: 50.0,
                                                icon: Icon(
                                                    Icons
                                                        .photo_size_select_actual,
                                                    color: Colors.orangeAccent),
                                                onPressed: () {
                                                  getImage();
                                                  data.changeOtherFOT(
                                                      !data.otherFOT);
//                                                  setState(() {
//                                                    otherFOT = !otherFOT;
//                                                  });
                                                },
                                              ),
                                            ),
                                            new Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              color: Color(0xFFffffff),
                                              child: new IconButton(
                                                iconSize: 50.0,
                                                icon: Icon(Icons.linked_camera,
                                                    color: Colors.deepPurple),
                                                onPressed: () {
                                                  getCamara();
                                                  fsNode1.unfocus();
                                                  data.changeOtherFOT(
                                                      !data.otherFOT);
//                                                  setState(() {
//                                                    fsNode1.unfocus();
//                                                    otherFOT = !otherFOT;
//                                                  });
                                                },
                                              ),
                                            ),
                                            new Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              color: Color(0xFFffffff),
                                              child: new IconButton(
                                                iconSize: 50.0,
                                                icon: Icon(Icons.video_library,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  //todo
                                                  getVideo();
                                                  data.changeOtherFOT(
                                                      !data.otherFOT);
//                                                Fluttertoast.showToast(
//                                                    msg: '功能在开发中..');
                                                },
                                              ),
                                            ),
                                            new Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              color: Color(0xFFffffff),
                                              child: new IconButton(
                                                iconSize: 50.0,
                                                icon: Icon(Icons.videocam,
                                                    color: Colors.black38),
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg: '暂不支持该功能');
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              new P2PPage()));
                                                  //todo
                                                  Fluttertoast.showToast(
                                                      msg: '功能在开发中..');
                                                  data.changeOtherFOT(
                                                      !data.otherFOT);
                                                },
                                              ),
                                            ),
                                            new Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100) /
                                                  4,
                                              color: Color(0xFFffffff),
                                              child: new IconButton(
                                                iconSize: 50.0,
                                                icon: Icon(Icons.add_location,
                                                    color: Colors.black38),
                                                onPressed: () {
                                                  //todo
                                                  Fluttertoast.showToast(
                                                      msg: '功能在开发中..');
                                                  data.changeOtherFOT(
                                                      !data.otherFOT);
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                )))
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
