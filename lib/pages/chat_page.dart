import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provide/provide.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          spinkit,
          IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () async{
                Application.router.navigateTo(context, Routes.createCoursePage).whenComplete((){
                  print("staasdss");
                  Provide.value<CreateCourseProvide>(context).InitStatus();
                }).then((onValue){
                  print("ss           :${onValue}");
                });
              }),
        ],
      ),
    );
  }
}

class LiquidLinearProgressIndicatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liquid Linear Progress Indicators"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //_AnimatedLiquidLinearProgressIndicator(),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation(Colors.red),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.pink),
              borderColor: Colors.red,
              borderWidth: 5.0,
              direction: Axis.vertical,
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.grey),
              borderColor: Colors.blue,
              borderWidth: 5.0,
              center: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.lightGreen,
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
              direction: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }
}

//class _AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() =>
//      _AnimatedLiquidLinearProgressIndicatorState();
//}
//
//class _AnimatedLiquidLinearProgressIndicatorState
//    extends State<_AnimatedLiquidLinearProgressIndicator>
//    with SingleTickerProviderStateMixin {
//  AnimationController _animationController;
//
//  @override
//  void initState() {
//    super.initState();
//
//    _animationController = AnimationController(
//      vsync: this,
//      duration: Duration(seconds: 10),
//    );
//
//    _animationController.addListener(() => setState(() {}));
//
//    _animationController.repeat();
//  }
//
//  @override
//  void dispose() {
//    _animationController.dispose();
//
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final percentage = _animationController.value * 100;
//
//    return Center(
//      child: Container(
//        width: double.infinity,
//        height: 75.0,
//        padding: EdgeInsets.symmetric(horizontal: 24.0),
//        child: LiquidLinearProgressIndicator(
//          value: _animationController.value,
//          backgroundColor: Colors.white,
//          valueColor: AlwaysStoppedAnimation(Colors.blue),
//          borderRadius: 12.0,
//          center: Text(
//            "${percentage.toStringAsFixed(0)}%",
//            style: TextStyle(
//              color: Colors.lightBlueAccent,
//              fontSize: 20.0,
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
