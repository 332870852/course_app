import 'package:course_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('关于帮助'),
//        centerTitle: true,
//        elevation: 0.0,
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back_ios),
//            onPressed: () {
//              Navigator.pop(context);
//            }),
//      ),
      body: Column(
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
                  onclikItem('推广下载', onTap: () {}),
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
                Padding(padding: EdgeInsets.only(bottom: 5),child: Row(
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
                ),)
              ],
            ),
          ),
        ],
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
                  color: Colors.white, fontSize: ScreenUtil().setSp(40)),
            ),
          )
        ],
      ),
    );
  }

  Widget appIcon() {
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
              Image.asset(
                'assets/img/appIcon.png',
                width: 100,
                height: 100,
                scale: 0.5,
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
