import 'package:course_app/widget/swiperdiy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoLookPage extends StatefulWidget {
  @override
  _VideoLookPageState createState() => _VideoLookPageState();
}

Future<String> getHome() async {
  return "";
}

class _VideoLookPageState extends State<VideoLookPage> {
  List item = [
    {
      'url':
      'https://img02.sogoucdn.com/net/a/04/link?url=https%3A%2F%2Fi02piccdn.sogoucdn.com%2Febb4736d2d73a30e&appid=122',
      't': '臭姐姐',
      'subTitle': '直播',
      'number': 99
    },
    {
      'url':
      'https://img02.sogoucdn.com/net/a/04/link?url=https%3A%2F%2Fi02piccdn.sogoucdn.com%2F8c540c395563a0e5&appid=122',
      't': '将夜',
      'subTitle': '即将大结局',
      'number': 100
    },
    {
      'url': 'https://i01piccdn.sogoucdn.com/3659dbfe3414752d',
      't': '美女',
      'subTitle': '上次观看到41',
      'number': 11
    },
    {
      'url':
      'https://img03.sogoucdn.com/app/a/100520093/e222e3d1e5293cd2-85cec76a9227617a-c8b5dc33323ac928553d2f7dbf35fbdf.jpg',
      't': '老体',
      'subTitle': '很好',
      'number': 3
    },
    {
      'url': 'https://i01piccdn.sogoucdn.com/c28a939493da88a0',
      't': '博人转',
      'subTitle': '！',
      'number': 2
    },
    {
      'url': 'https://i01piccdn.sogoucdn.com/4d8bc3623d0f8169',
      't': '同老爷',
      'subTitle': '来把',
      'number': 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: EasyRefresh.custom(
        header: MaterialHeader(),
        onRefresh: (){
          return null;
        },
        slivers: <Widget>[

          SliverAppBar(
            title: Icon(
              Icons.settings_input_svideo,
              color: Colors.red,
            ),
            //     pinned: true,
            //固定在顶部
            floating: true,
            elevation: 1.0,
            expandedHeight: 178.0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '视频',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(45)),
              ),
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 100),
              background: SwiperDiy(
                getHomePageContent: getHome(),
              ),
            ),
          ),

          SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                  child: Text(
                    '课堂视频',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(45)),
                  ),
                ),
              ])),
          SliverSafeArea(
            //安全区
            sliver: SliverPadding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0, //// 比例
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    print(item[index]);
                    return Item(
                        item[index]['url'], title: '${item[index]['t']}',
                        subTitle: item[index]['subTitle'],
                        number: item[index]['number']);
                  },
                  childCount: item.length,
                ),
              ),
            ),
          ),
          //////////////////////////////////////////////////////////////////
          SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                  child: Text(
                    '推荐视频',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(45)),
                  ),
                ),
              ])),
          SliverSafeArea(
            //安全区
            sliver: SliverPadding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0, //// 比例
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Item(item[index]['url'], title: item[index]['t'],
                        subTitle: item[index]['subTitle'],
                        number: item[index]['number']);
                  },
                  childCount: item.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Item(String url,
      {String title, String subTitle = '', int number = 0}) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // color: Colors.black26,
                  image: DecorationImage(
                      image: NetworkImage(
                        '${url}',
                      ),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 5),
                    child: Text(
                      '${number}人观看',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          '${title}',
                          style: TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            '${subTitle}',
                            style: TextStyle(color: Colors.black26),
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
