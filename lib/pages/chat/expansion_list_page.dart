import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/data/chat/friend_model.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';

class ExpansionListPage extends StatefulWidget {
  final List<FriendItem> items;
  final String title;
  final String numTotal;

  ExpansionListPage(
      {Key key,
      @required this.items,
      @required this.title,
      @required this.numTotal})
      : super(key: key);

  @override
  _ExpansionListPageState createState() => _ExpansionListPageState();
}

class _ExpansionListPageState extends State<ExpansionListPage> {
  bool flag;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flag = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        leading: (flag) ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_right),
        title: Text('${widget.title}'),
        trailing: Text('${widget.numTotal}'),
        onExpansionChanged: (flag) {
          setState(() {
            this.flag = flag;
          });
        },
        children: widget.items
            .map((item) {
              return PersonItem('${item.fiendId}',
                  headUrl: '${item.headUrl}',
                  username: '${item.username}',
                  state: item.state);
            })
            .toList()
            .cast(),
      ),
    );
  }

//  Widget personItem(String friendId,
//      {@required String headUrl,
//      @required String username,
//      int state = 0,
//      String time = '',
//      int unRead = 0}) {
//    if (unRead > 99) {
//      unRead = 99;
//    }
//    if (time.length > 5) {
//      int len = time.length;
//      time = time.substring(len - 5, len);
//    }
//    String stateInfo = '';
//    if (state == 1) {
//      stateInfo = '[在线]';
//    } else {
//      stateInfo = '[离线]';
//    }
//    return ListTile(
//      onTap: () {
//        //todo
//        //friendId;
//      },
//      onLongPress: () {},
//      leading: CircleAvatar(
//          backgroundImage: CachedNetworkImageProvider('${headUrl}',
//              cacheManager: DefaultCacheManager())),
//      title: Padding(
//        padding: EdgeInsets.only(left: 5),
//        child: Wrap(
//          runSpacing: 5,
//          spacing: 5,
//          direction: Axis.vertical,
//          children: <Widget>[
//            Text(
//              '${username}',
//              overflow: TextOverflow.ellipsis,
//            ),
//            Row(
//              children: <Widget>[
//                Text(
//                  '${stateInfo}',
//                  style: TextStyle(
//                      color: Colors.black54, fontSize: ScreenUtil().setSp(28)),
//                  overflow: TextOverflow.ellipsis,
//                ),
//                Icon(
//                  Icons.fiber_manual_record,
//                  color: (state == 1) ? Colors.green : Colors.black26,
//                  size: ScreenUtil().setSp(28),
//                )
//              ],
//            )
//          ],
//        ),
//      ),
//      trailing: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Text('${time}'),
//          (unRead != 0)
//              ? Container(
//                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
//                  decoration: BoxDecoration(
//                      color: Colors.deepOrange,
//                      border: Border.all(width: 2, color: Colors.white),
//                      borderRadius: BorderRadius.circular(12.0)),
//                  child: Text(
//                    '${unRead}',
//                    style: TextStyle(
//                        color: Colors.white, fontSize: ScreenUtil().setSp(20)),
//                  ),
//                )
//              : SizedBox()
//        ],
//      ),
//    );
//  }
}
