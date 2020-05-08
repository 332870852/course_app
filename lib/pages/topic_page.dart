import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

///话题
class TopicPage extends StatelessWidget {
  final courseId;
  final teacherId;

  TopicPage({Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('话题'),
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: EasyRefresh.custom(
          header: BallPulseHeader(backgroundColor: Colors.purple),
          //MaterialHeader(),
          onRefresh: () {
            return null;
          },
          slivers: <Widget>[
            SliverSafeArea(
              //安全区
              sliver: SliverPadding(
                padding: EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0, //// 比例
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return cardItem();
                    },
                    childCount: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardItem() {
    return Card(
      semanticContainer: false,
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            width: ScreenUtil.screenWidth,
            //                         color: Colors.purple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            'https://img03.sogoucdn.com/net/a/04/link?url=https%3A%2F%2Fi02piccdn.sogoucdn.com%2Fa3ffebbb779e0baf&appid=122',
                            cacheManager: DefaultCacheManager()),
                        minRadius: 20,
                        maxRadius: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('无言以对'),
                                Text(
                                    '${DateTime.now().toString().substring(0, 16)}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: IconButton(
                      icon: Icon(Icons.more_horiz), onPressed: () {}),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 8, top: 10, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: ScreenUtil.screenWidth,
                    child: Text(
                      'asdfsssssssssssdfdsf'
                      '1111111111'
                      '5555555'
                      '1111111111111111111'
                      '1111111111111'
                      '1'
                      '99999999999999999999999999999999999999999999999999'
                      '111111111'
                      '5555555555',
                      style: TextStyle(fontSize: 20),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Visibility(
                    child: Flexible(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.8,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        children: <Widget>[
                          Image.network(
                            'https://img03.sogoucdn.com/net/a/04/link?url=https%3A%2F%2Fi02piccdn.sogoucdn.com%2Fa3ffebbb779e0baf&appid=122',
                          ),
                          Image.network(
                              'https://img03.sogoucdn.com/net/a/04/link?url=https%3A%2F%2Fi02piccdn.sogoucdn.com%2Fa3ffebbb779e0baf&appid=122'),
                          Image.network(
                              'https://img03.sogoucdn.com/net/a/04/link?url=https%3A%2F%2Fi02piccdn.sogoucdn.com%2Fa3ffebbb779e0baf&appid=122'),
                        ],
                      ),
                    ),
                    visible: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
