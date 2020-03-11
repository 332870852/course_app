import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/widget/bottom_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:video_player/video_player.dart';
///视频播放
class VideoViewPage extends StatefulWidget {
  final String urlPath;
  bool display;
  VideoViewPage({Key key, @required this.urlPath}) : super(key: key);

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> with AutomaticKeepAliveClientMixin{
  VideoPlayerController _controller;
  var _initializeVideoPlayerFuture;

  bool isURL = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.display=true;
    if (RegexUtil.isURL(widget.urlPath)) {
      _controller = VideoPlayerController.network((widget.urlPath));
      isURL = true;
    } else {
      _controller = VideoPlayerController.file(File((widget.urlPath)));
    }
    if (_initializeVideoPlayerFuture == null) {
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: new FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return InkWell(
                onTap: () {
                  bool isPlaying = _controller.value.isPlaying;
                  isPlaying ? _controller.pause() : _controller.play();
                  if (isPlaying) {
                    widget.display = false;
                  } else {
                    widget.display = true;
                  }
                  setState(() {});
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_controller),
                      Offstage(
                        offstage: widget.display,
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white.withOpacity(0.6),
                            size: 50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.transparent,
                          width: ScreenUtil.screenWidth,
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              (isURL)
                                  ? IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _openModalBottomSheet(context, widget.urlPath);
                                  })
                                  : SizedBox(),
                            ],
                          )
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.transparent,
                          width: ScreenUtil.screenWidth,
                          height: 50,
                          child: VideoProgressIndicator(
                            _controller,
                            colors: VideoProgressColors(),
                            allowScrubbing: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future _openModalBottomSheet(context, String urlPath) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 110.0,
            child: Column(
              children: <Widget>[
                bottomItem(context, '保存到本地', 0),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                bottomItem(context, '取消', 2),
              ],
            ),
          );
        });
    switch (option) {
      case 0:
        {
          // if(isURL){
          ImagePickers.saveVideoToGallery(urlPath).then((onValue) {
            Fluttertoast.showToast(msg: '保存成功');
          });
          // }
          ///
          break;
        }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
