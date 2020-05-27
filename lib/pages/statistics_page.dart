import 'package:course_app/service/student_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

///统计
class StatisticsPage extends StatefulWidget {
  final String courseId;
  final String userId;

  StatisticsPage({Key key, @required this.courseId, @required this.userId})
      : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  ///考勤
  List<SalesCircleData> chartCircleData = <SalesCircleData>[
    SalesCircleData(
      '出勤',
      0,
      Colors.blueAccent,
    ),
    SalesCircleData('迟到', 0, Colors.purpleAccent),
    SalesCircleData('早退', 0, Colors.brown),
    SalesCircleData('旷课', 0, Colors.redAccent),
    SalesCircleData('请假', 0, Colors.greenAccent)
  ];
  var kaoqinTip = '暂无数据';
  Map cicirleRate = {'0': 0, '1': 0, '2': 0, '3': 0, '4': 0, 'total': 0};

  getAttendance() async {
//    var map = await StudentMethod.statisticsAttendanceByStuId(
//        context, widget.courseId, widget.userId);
    var map = await StudentMethod.statisticsAttendanceByStuId(
        context, widget.courseId, widget.userId);
    print(map['ViewAttendance']);
    List list = map['ViewAttendance'];
    if (list != null) {
      list.forEach((element) {
        if (element['status'] == 0) {
          cicirleRate['0']++;
        } else if (element['status'] == 1) {
          cicirleRate['1']++;
        } else if (element['status'] == 2) {
          cicirleRate['2']++;
        } else if (element['status'] == 3) {
          cicirleRate['3']++;
        } else if (element['status'] == 4) {
          cicirleRate['4']++;
        }
      });

      setState(() {
        chartCircleData[0].sales = cicirleRate['0'];
        chartCircleData[1].sales = cicirleRate['1'];
        chartCircleData[2].sales = cicirleRate['2'];
        chartCircleData[3].sales = cicirleRate['3'];
        chartCircleData[4].sales = cicirleRate['4'];
        num total = map['total'];
        cicirleRate['total'] = total;
        num d = cicirleRate['0'];
        kaoqinTip =
            '总计考勤次数: ${map['total']}, 出勤: ${cicirleRate['0']}, 得分${((d / total) * 100).toInt()}(满分100)';
      });
    }
  }

  ///课堂测试统计
  var zuoyeTip = '暂无数据';
  List<ChartData> chartData = [

  ];

  getClassworkData() async {
    var map = await StudentMethod.statisticsClasswork(
        context, widget.courseId, widget.userId);
    print(map);
    List list = map['ViewClassWork'];
    int wating = 0, has = 0, uncommit = 0;
    num cur = 0, total = 0;
    if (list != null) {
      list.forEach((element) {
        var text = '';
        if (element['status'] == 1) {
          wating++;
          text = '待批改';
        } else if (element['status'] == 2) {
          has++;
          cur += element['rscore'];
          text = '已批改';
        } else if (element['status'] == 3) {
          uncommit++;
          text = '未提交';
        }
        total += element['score'];
        DateTime date = DateTime.tryParse(element['createTime'].toString());
        chartData.add(ChartData(
          date: '${date.month}-${date.day}\n ${date.hour}:${date.minute}',
          y1: element['score'],
          y2: element['rscore'],
          text: text,
        ));
        zuoyeTip =
            '总计作业次数:${list.length}, 待批改:${wating}, 已批改:${has}, 未提交:${uncommit}, 得分:${(cur / total) * 100}(满分100)';
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendance();
    getClassworkData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('成绩统计'),
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          tip('考勤统计', message: '${kaoqinTip}'),

          ///扇形图
          Fanchart(),

          ///柱状图
          Histogram(),
          tip('课堂作业统计', message: '${zuoyeTip}'),
          classworkHistogram(),
        ],
      ),
    );
  }

  Widget Fanchart() {
    return Container(
      height: 250,
      width: ScreenUtil.screenWidth,
      child: Row(
        children: <Widget>[
          Expanded(
              child: SfCircularChart(
                  title: ChartTitle(text: '考勤扇形图统计'),
                  //primaryXAxis: CategoryAxis(),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <PieSeries<SalesCircleData, String>>[
                PieSeries<SalesCircleData, String>(
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    useSeriesColor: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableSmartLabels: true,
                  dataSource: chartCircleData,
                  xValueMapper: (SalesCircleData sales, _) => sales.text,
                  yValueMapper: (SalesCircleData sales, _) => sales.sales,
                  dataLabelMapper: (SalesCircleData data, _) => '${data.sales}',
//                        sortFieldValueMapper: (SalesCircleData data, _) =>
//                            data.year,
                  //map Color for each dataPoint datasource.
                  pointColorMapper: (SalesCircleData sales, _) => sales.color,
                )
              ])),
        ],
      ),
    );
  }

  Widget Histogram() {
    //柱状图
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.black26, width: 1.0),
      )),
      height: 250,
      child: Row(
        children: <Widget>[
          Expanded(
              child: SfCartesianChart(
                  title: ChartTitle(text: '考勤柱状图统计'),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                ColumnSeries<SalesCircleData, String>(
                    dataSource: chartCircleData,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      useSeriesColor: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    xValueMapper: (SalesCircleData data, _) => data.text,
                    yValueMapper: (SalesCircleData data, _) => data.sales,
                    // Map color for each data points from the data source
                    pointColorMapper: (SalesCircleData data, _) => data.color)
              ]))
        ],
      ),
    );
  }

  ///课堂作业
  Widget classworkHistogram() {
    return Container(
        height: 270,
        child: RepaintBoundary(
          child: SfCartesianChart(
              title: ChartTitle(text: '课堂作业得分统计'),
              tooltipBehavior: TooltipBehavior(
                enable: true,
              ),
              primaryXAxis: CategoryAxis(),
              // Palette colors
              palette: <Color>[
                Colors.teal,
                Colors.orange,
                //Colors.brown
              ],
              legend: Legend(isVisible: true),
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                  name: '作业总分',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.date,
                  yValueMapper: (ChartData data, _) => data.y1,
                  dataLabelMapper: (ChartData data, _) => '${data.text}',
                  markerSettings: MarkerSettings(),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    //useSeriesColor: true,
                    labelPosition: ChartDataLabelPosition.inside,
                  ),
                  //sortFieldValueMapper: (ChartData data, _)=>data.date,
                  emptyPointSettings: EmptyPointSettings(color: Colors.black26),
                ),
                ColumnSeries<ChartData, String>(
                    name: '作业得分',
                    dataSource: chartData,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      showCumulativeValues: true,
                      //useSeriesColor: true,
                      // color: Colors.red,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    xAxisName: '发布时间',
                    yAxisName: '得分',
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.y2),
              ]),
        ));
  }

  Widget tip(title, {message}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 80,
      ),
      child: Container(
          padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    '${title}',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    '${message}',
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                  )),
                ],
              ),
            ],
          )),
    );
  }
}

///zhu
class ChartData {
  ChartData({this.text, this.y1, this.y2, this.date});

  final String text;
  final num y1;
  final num y2;
  final date;
}

///扇形图
class SalesCircleData {
  SalesCircleData(this.text, this.sales, [this.color]);

  final String text;
  num sales;
  final Color color;
}
