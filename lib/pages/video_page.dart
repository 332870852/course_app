import 'package:course_app/pages/looking_vio_page.dart';
import 'package:course_app/pages/video_look_page.dart';
import 'package:flutter/material.dart';
import 'package:course_app/widget/swiperdiy_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const APPBAR_SCROLL_OFFSET = 100;

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 180,
              color: Colors.white,
              alignment: Alignment.center,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      '视频',
                    ),
                  ),
                  Tab(
                    child: Wrap(
                      direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text(
                          '直播',
                        ),
                        SpinKitWave(
                          color: Colors.red,
                          type: SpinKitWaveType.start,
                          size: ScreenUtil().setSp(30),
                        )
                      ],
                    ),
                  ),
                ],
                //indicatorWeight: 0.0,
                indicatorColor: Colors.red,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black26,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        VideoLookPage(),
        LookingVioPage(),
      ]),
    );
  }
}
