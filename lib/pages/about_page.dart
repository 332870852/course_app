import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/pages/soft/software_page.dart';
import 'package:course_app/pages/share_download_page.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/test/soft_ware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_bus/flutter_event_bus/Subscription.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Subscription _subscription;
  String Wpwd = '';
  List<String> strs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subscription =
        Application.eventBus.respond<SoftWareBody>((SoftWareBody soft) {
      if (soft.method == 'onlineuser') {
        List list = soft.data;
        list.forEach((item) {
          if (!strs.contains(item.toString())) {
            strs.add(item.toString());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: ScreenUtil.screenWidthDp,
        height: ScreenUtil.screenHeightDp,
        child: Column(
          children: <Widget>[
            appBar(),
            appIcon(),
            Container(
              height: 232,
              child: Ink(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    onclikItem('检查版本', trailing: '已是最新版本', onTap: () {}),
                    onclikItem('推广下载', onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ShareDownLoadPage()));
                    }),
                    onclikItem('关于', onTap: () {}),
                    onclikItem('反馈', onTap: () {}),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '服务协议',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        Text(
                          ' | ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(
                          '隐私协议',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      width: ScreenUtil.screenWidth,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withGreen(222),
          Theme.of(context).primaryColor.withOpacity(0.50),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      padding: EdgeInsets.only(left: 5, top: 30),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          Padding(
            padding: EdgeInsets.only(left: 90),
            child: Text(
              '关于与帮助',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.textScaleFactory * 20),
            ),
          )
        ],
      ),
    );
  }

  Widget appIcon() {
    TextEditingController controller = new TextEditingController();
    return Container(
      height: 200,
      //color: Colors.red,
      padding: EdgeInsets.only(top: 50),
      width: ScreenUtil.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (strs.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => new SoftWarePage(
                                  list: strs,
                                  pwd: Wpwd,
                                )));
                  }
                },
                onLongPress: () async {
                  bool b = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          content: TextField(
                            controller: controller,
                            maxLines: 1,
                          ),
                          elevation: 0.0,
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text('确认'),
                              color: Colors.blue,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('取消'),
                              color: Colors.black26,
                            )
                          ],
                        );
                      });
                  if (b) {
                    String pwd = controller.value.text.trim();
                    if (ObjectUtil.isNotEmpty(pwd)) {
                      Wpwd = pwd;
                      Application.nettyWebSocket
                          .getSoftWareChannel()
                          .sendListenuser(pwd: pwd);
                    }
                  }
                },
                child: Image.asset(
                  'assets/img/appIcon.png',
                  width: 100,
                  height: 100,
                  scale: 0.5,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  'V1.0.0',
                  style: TextStyle(
                      color: Colors.black26, fontSize: ScreenUtil().setSp(40)),
                ),
              )
            ],
          ),
          Text('智慧辅助课堂App'),
        ],
      ),
    );
  }

  Widget onclikItem(String title, {String trailing, GestureTapCallback onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(Constants.DividerColor),
                  width: Constants.DividerWith))),
      child: ListTile(
        title: Text('${title}'),
        trailing: (trailing != null)
            ? Text(
                '${trailing}',
                style: TextStyle(
                  color: Colors.black26,
                ),
              )
            : Icon(
                Icons.chevron_right,
                color: Colors.black26,
              ),
        onTap: onTap,
      ),
    );
  }
}
