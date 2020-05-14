import 'package:course_app/ui/like_button.dart';
import 'package:flutter/material.dart';

class TopicWidget extends StatefulWidget {
  int likeNum;
  int commentNum;

  TopicWidget({Key key, this.likeNum = 0, this.commentNum = 0})
      : super(key: key);

  @override
  _TopicWidgetState createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            LikeButton(
              width: 50,
              onIconClicked: (value) {
                 if(value){
                   widget.likeNum+=1;
                 }else{
                   widget.likeNum-=1;
                 }
              },
            ),
            Text(
              ' ${widget.likeNum}',
              style: TextStyle(color: Colors.black26),
            ),
          ],
        )),
        Expanded(
            child: Row(
          children: <Widget>[
            Icon(
              Icons.message,
              color: Colors.black26,
            ),
            Text(
              '${widget.commentNum}',
              style: TextStyle(color: Colors.black26),
            ),
          ],
        )),
      ],
    );
  }
}
