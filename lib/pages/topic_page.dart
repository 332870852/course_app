import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/topic_vo.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/pages/topic_create.dart';
import 'package:course_app/pages/topoc_detail_page.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/ui/like_button.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:course_app/widget/topic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provide/provide.dart';
import 'package:course_app/provide/topic_provide.dart';
import 'chat/pic_view.dart';

class TopicPage extends StatefulWidget {
  final courseId;
  final teacherId;

  TopicPage({Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  // List<TopicVo> _data = [];
  EasyRefreshController _controller = EasyRefreshController();

  ///获取数据
  getData({userId, bool b = true}) async {
    var res = await UserMethod.getTopicList(context,
        courseId: widget.courseId, userId: userId);
    if (res != null) {
      Provide.value<TopicProvide>(context).saveData(res);
//      Future.microtask(
//          () => Provide.value<TopicProvide>(context).saveData(res));
//      if (b) {
//        setState(() {
//          _data = res;
//        });
//      } else {
//        _data = res;
//      }
    }
  }

  Future<UserInfoVo> getUserInfo(userId) async {
    if (userId == null) return null;
    return await UserMethod.getUserInfo(context, userId: userId);
  }

  openPage(topicVo,waiting,list) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TopicDetalPage(
              dataSource: topicVo,
              userInfoVo: waiting,
              annexes: list,
            )));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('话题'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TopicCreatePage(
                          courseId: widget.courseId,
                        )));
                if (ObjectUtil.isNotEmpty(data)) {
                  print(data.toString());
                  TopicVo top = new TopicVo(
                      id: data['id'],
                      tag: data['tag'],
                      content: data['content'],
                      annexes: data['annexes'].cast<String>(),
                      createTime: data['createTime'],
                      publisher: data['publisher'],
                      courseId: data['courseId'],
                      likeNums: data['likeNums'].cast<String>(),
                      commentNums: 0);
                  Provide.value<TopicProvide>(context).addTopoc(top);
                }
              },
              child: Text(
                '创建',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Provide<TopicProvide>(builder: (_, child, data) {
          return EasyRefresh.custom(
            header: BallPulseHeader(backgroundColor: Colors.purple),
            //MaterialHeader(),
            controller: _controller,
            onRefresh: () async {
              await getData();
            },
            //firstRefresh: true,
            emptyWidget: (data.data.isEmpty)
                ? NoDataWidget(
                    title: '赶快发布话题讨论吧~', path: 'assets/img/nodata4.png')
                : null,
            slivers: <Widget>[
              SliverSafeArea(
                //安全区
                sliver: SliverPadding(
                  padding: EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return cardItem(context, topicVo: data.data[index]);
                  }, childCount: data.data.length)
//                    SliverChildListDelegate(
//                  _data.map((e) {
//                    return cardItem(context, topicVo: e);
//                  }).toList(),
//                )
                      ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget cardItem(BuildContext context, {TopicVo topicVo}) {
    print(topicVo.annexes);
    List<Widget> list = [];
    topicVo.annexes.forEach((element) {
      Widget s = InkWell(
        child: Container(
            width: 100,
            height: 100,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/img/pic_error.png',
              image: '${element}',
              fit: BoxFit.cover,
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ImageViewPage(
                        urlPath: element,
                        isNetUrl: true,
                      )));
        },
      );
      list.add(s);
    });
    UserInfoVo waiting;
    return Card(
      // semanticContainer: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400,
          //minHeight: 300,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              width: ScreenUtil.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FutureBuilder<UserInfoVo>(
                      future: getUserInfo(topicVo.publisher),
                      builder: (_, user) {
                        if (user.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          waiting = user.data;
                          return Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: (ObjectUtil.isNotEmpty(
                                          user.data.faceImage))
                                      ? CachedNetworkImageProvider(
                                          '${user.data.faceImage}',
                                          cacheManager: DefaultCacheManager())
                                      : AssetImage('assets/img/user.png'),
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
                                          Text('${user.data.nickname}'),
                                          Text('${topicVo.createTime}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                  Flexible(
                    child: IconButton(
                        icon: Icon(Icons.more_horiz), onPressed: () {}),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  openPage(topicVo,waiting,list);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 8, top: 10, right: 8),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: ScreenUtil.screenWidth,
                          child: RichText(
                            text: TextSpan(
                                text: (ObjectUtil.isEmptyString(topicVo.tag))
                                    ? ''
                                    : '#${topicVo.tag}\r\n',
                                children: [
                                  TextSpan(
                                    text: '${topicVo.content}',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )
                                ],
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent)),
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                          children: list,
                        ),
                        visible: (topicVo.annexes.length > 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      LikeButton(
                        width: 50,
                        onIconClicked: (value) async {
                          var b = await UserMethod.commendationTop(
                              context, topicVo.id,
                              like: value);
                          if (b == true) {
                            Provide.value<TopicProvide>(context).updateLikeNums(
                                value, topicVo.id,
                                userId:
                                    Provide.value<UserProvide>(context).userId);
                          }
                        },
                      ),
                      Text(
                        ' ${topicVo.likeNums.length}',
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Colors.black26,
                        ),
                        onPressed: ()=>openPage(topicVo,waiting,list),
                      ),
                      Text(
                        '${topicVo.commentNums}',
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
