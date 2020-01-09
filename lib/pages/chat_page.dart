import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          IconButton(icon: Icon(Icons.access_alarm), onPressed: (){
          })
        ],
      ),
    );
  }
}
