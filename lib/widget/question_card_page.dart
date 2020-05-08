import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: InkWell(
                onTap: () {
                  //todo
                },
                child: Text(
                  '题卡 ^',
                  style: TextStyle(color: Colors.green, fontSize: 25),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(),
          ),
        ],
      ),
    );
  }
}
