import 'package:course_app/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/service_url.dart';
import 'package:url_launcher/url_launcher.dart';
///二维码扫描
class ScanViewDemo extends StatefulWidget {
  ScanViewDemo({Key key}) : super(key: key);

  @override
  _ScanViewDemoState createState() => new _ScanViewDemoState();
}

class _ScanViewDemoState extends State<ScanViewDemo> {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: QrcodeReaderView(
        key: _key,
        onScan: onScan,
        headerWidget: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }

  Future onScan(String data) async {
    bool b = RegexUtil.isURL(data);
    bool burl = data.contains('${studentPath.servicePath['joinCourse']}') ||
        data.contains('${userPath.servicePath['getUserFriend']}');
    if (!b) {
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("扫码结果错误,不合法"),
            content: Text(data),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
      _key.currentState.startScan();
    } else if(!burl){
      if(await canLaunch(data)){
        launch(data,);
      }
    }else {
      Navigator.pop(context, data);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
