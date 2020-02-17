import 'package:course_app/animation/loginAnimation.dart';
import 'package:course_app/components/FormContainer.dart';
import 'package:course_app/components/WhiteTick.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/utils/navigatorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provide/provide.dart';

///登陆页
class LoginPage extends StatefulWidget {

  LoginPage({Key key, this.username = '',this.pwd=''}) : super(key: key);
  String username;
  String pwd;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _loginButtonController;

//  var animationStatus = 0;
  TextEditingController usernameController;
  TextEditingController pwdController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 4000), vsync: this);
    usernameController = TextEditingController();
    pwdController = TextEditingController();
    usernameController.text = widget.username;
    pwdController.text=widget.pwd;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loginButtonController.dispose();
    usernameController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Are you sure?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () async {
                  await SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
//    username = (Provide.value<UserModelProvide>(context).user != null)
//        ? Provide.value<UserModelProvide>(context).user.userVo.phoneNumber
//        : '';
    //usernameController.text = username;
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(162, 146, 199, 0.8),
                      const Color.fromRGBO(51, 51, 63, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
                  child: new ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Tick(image: tick),
                              new FormContainer(
                                usernameController: usernameController,
                                pwdController: pwdController,
                              ),
                              //new SignUp()
                              Padding(
                                  padding: const EdgeInsets.only(
                                top: 150.0,
                              )),
                            ],
                          ),
                          new StaggerAnimation(
                              usernameController: usernameController,
                              pwdController: pwdController,
                              buttonController: _loginButtonController.view)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialIcon(
                            colors: [
                              Color(0xFF102397),
                              Color(0xFF187adf),
                              Color(0xFF00eaf8),
                            ],
                            iconData: AppIcons.tencent_qq,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Colors.green,
                              Colors.greenAccent,
                            ],
                            iconData: AppIcons.weixin,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: Text("忘记密码",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins-Bold")),
                              onPressed: () {
                                //todo 忘记密码
                                NavigatorUtil.goAttendanceStuPage(context);
                              },
                            ),
                            Text('|'),
                            FlatButton(
                              child: Text("注册新用户",
                                  style: TextStyle(
                                      color: Color(0xFF5d74e3),
                                      fontFamily: "Poppins-Bold")),
                              onPressed: () {
                                //todo 注册
                                NavigatorUtil.goRegisterPage(context);
                               // NavigatorUtil.goResultRegisterPage(context,isSuccess: true,username: '1213132');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        )));
  }

  DecorationImage backgroundImage = new DecorationImage(
    image: new ExactAssetImage('assets/bgk/backgroud.jpg'),
    fit: BoxFit.cover,
  );

  DecorationImage tick = new DecorationImage(
    image: new ExactAssetImage('assets/img/appIcon.png'),
    fit: BoxFit.cover,
  );
}

//ICON
class SocialIcon extends StatelessWidget {
  final List<Color> colors;
  final IconData iconData;
  final Function onPressed;

  SocialIcon({this.colors, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(left: 14.0),
      child: Container(
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: colors, tileMode: TileMode.clamp)),
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: onPressed,
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}
