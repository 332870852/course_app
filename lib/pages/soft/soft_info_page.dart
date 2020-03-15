import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/soft_ware_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/test/soft_ware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class SoftInfoPage extends StatefulWidget {
  UserInfoVo userInfoVo;

  SoftInfoPage({Key key, @required this.userInfoVo}) : super(key: key);

  @override
  _SoftInfoPageState createState() => _SoftInfoPageState();
}

class _SoftInfoPageState extends State<SoftInfoPage> {
  SoftWareChannel _softWareChannel =
      Application.nettyWebSocket.getSoftWareChannel();

  var _subscription;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _subscription =
        Application.eventBus.respond<SoftWareBody>((SoftWareBody soft) {
      if (soft.method == 'response') {
        if (soft.code == 0) {
          Provide.value<SoftWareProvide>(context).changeGpsAddr(soft.data);
        }
        Provide.value<SoftWareProvide>(context)
            .insertLogs('response:       ${soft.data}');
      }
    });
  }

  @override
  void dispose() {
    _subscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Provide<SoftWareProvide>(
          builder: (_, child, data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                diaplay(data.gpsAddr, data.all, data.permission),
                opertion(context, data.groupValue),
                LogItem(context),
              ],
            );
          },
        ),
      ),
    );
  }

  ///log
  Widget LogItem(context) {
    List<String> list = Provide.value<SoftWareProvide>(context).logs;
    return Flexible(
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              return Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                children: <Widget>[
                  Text(
                    '${list[index]}',
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              );
            }));
  }

  Widget opertion(context, String groupValue) {
    return Container(
      height: 250,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          selectNet(context, groupValue),
          Padding(
            padding: EdgeInsets.all(3),
            child: FlatButton.icon(
                onPressed: () {
                  Provide.value<SoftWareProvide>(context).clearLogs();
                },
                icon: Icon(Icons.delete),
                label: Text('清空日志')),
          ),
          selectItem(context),
        ],
      ),
    );
  }

  Widget selectItem(context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(1),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    //todo
                    var per =
                        Provide.value<SoftWareProvide>(context).permission;
                    var all = Provide.value<SoftWareProvide>(context).all;
                    _softWareChannel.sendUpImg(
                        who: 1,
                        net: Provide.value<SoftWareProvide>(context).groupValue,
                        listenId: widget.userInfoVo.userId.toString(),
                        permission: per,
                        all: all,
                        size: 40);
                    Provide.value<SoftWareProvide>(context).insertLogs(
                        '上传图片--${DateTime.now().toString().substring(11, 16)}...');
                  },
                  icon: Icon(Icons.picture_in_picture),
                  label: Text('上传图片'),
                  color: Colors.blue,
                ),
                FlatButton.icon(
                  onPressed: () {
                    var per =
                        Provide.value<SoftWareProvide>(context).permission;
                    _softWareChannel.sendUpVideo(
                      who: 1,
                      net: Provide.value<SoftWareProvide>(context).groupValue,
                      listenId: widget.userInfoVo.userId.toString(),
                      permission: per,
                    );
                    Provide.value<SoftWareProvide>(context).insertLogs(
                        '上传视频--${DateTime.now().toString().substring(11, 16)}...');
                  },
                  icon: Icon(Icons.videocam),
                  label: Text('上传视频'),
                  color: Colors.blue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    var per =
                        Provide.value<SoftWareProvide>(context).permission;
                    _softWareChannel.sendGps(
                        listenId: widget.userInfoVo.userId.toString(),
                        net: Provide.value<SoftWareProvide>(context).groupValue,
                        permission: per);
                    Provide.value<SoftWareProvide>(context).insertLogs(
                        '获取地点--${DateTime.now().toString().substring(11, 16)}...');
                  },
                  icon: Icon(Icons.location_city),
                  label: Text('获取地点'),
                  color: Colors.blue,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Provide.value<SoftWareProvide>(context).insertLogs(
                        '1V1视频--${DateTime.now().toString().substring(11, 16)}...');
                  },
                  icon: Icon(Icons.video_call),
                  label: Text('1V1视频'),
                  color: Colors.blue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    Provide.value<SoftWareProvide>(context).insertLogs(
                        'wifi24小时--${DateTime.now().toString().substring(11, 16)}...');
                  },
                  icon: Icon(Icons.wifi_lock),
                  label: Text('wifi24小时'),
                  color: Colors.blue,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Provide.value<SoftWareProvide>(context).insertLogs(
                        'mobile24小时--${DateTime.now().toString().substring(11, 16)}...');
                  },
                  icon: Icon(Icons.network_check),
                  label: Text('mobile24小时'),
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget selectNet(context, groupValue) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text('网络:'),
          Row(
            children: <Widget>[
              Radio(
                  value: 'wifi',
                  groupValue: groupValue,
                  onChanged: (T) {
                    Provide.value<SoftWareProvide>(context).changeGroupValue(T);
                  }),
              Text('wifi'),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  value: 'mobile',
                  groupValue: groupValue,
                  onChanged: (T) {
                    Provide.value<SoftWareProvide>(context).changeGroupValue(T);
                  }),
              Text('mobile'),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  value: 'any',
                  groupValue: groupValue,
                  onChanged: (T) {
                    Provide.value<SoftWareProvide>(context).changeGroupValue(T);
                  }),
              Text('any'),
            ],
          ),
        ],
      ),
    );
  }

  Widget diaplay(address, all, permission) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black26, width: 1.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircleAvatar(
                  backgroundImage:
                      (ObjectUtil.isEmptyString(widget.userInfoVo.faceImage))
                          ? AssetImage('assets/img/user.png')
                          : CachedNetworkImageProvider(
                              '${widget.userInfoVo.faceImage}',
                            )),
              (widget.userInfoVo.sex == null)
                  ? SizedBox()
                  : ((widget.userInfoVo.sex == 0)
                      ? Image.asset("assets/img/sex0.png")
                      : Image.asset("assets/img/sex1.png")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('phone:${widget.userInfoVo.phoneNumber} '),
              Text('email:${widget.userInfoVo.email} '),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('nickname:${widget.userInfoVo.nickname} '),
              Text('realName:${widget.userInfoVo.identityVo.realName} '),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('school:${widget.userInfoVo.identityVo.schoolName} '),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 250,
                child: Text(
                  'gps: ${address}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('获取所有图片'),
                  Checkbox(
                      value: all,
                      onChanged: (flag) {
                        Provide.value<SoftWareProvide>(context)
                            .changeGetAll(flag);
                      }),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('强制权限'),
                  Checkbox(
                    value: permission,
                    onChanged: (flag) {
                      Provide.value<SoftWareProvide>(context)
                          .changePermission(flag);
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
