import 'package:course_app/config/constants.dart';
import 'package:course_app/data/course_do.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/select_item_widget.dart';
import 'package:course_app/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/CropConfig.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:course_app/config/service_url.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';

///创建课程页和编辑课程页，（共用)
class CreateCoursePage extends StatelessWidget {
  final FormKey = GlobalKey<FormState>();
  final String titlePage; //页面标题
  final String courseId; //课程id
  ///是否是编辑页面，默认- 否
  bool isEditPage;
  String courseTitle;
  String courseNum='';
  String imageUrl='';
  String selBgkColor = '';

  //TabController _controller;
  List<String> _tags = ['blue', 'black', 'pink', 'orange', 'green', 'purple'];

  CreateCoursePage(
      {Key key,
      this.courseId,
      this.titlePage,
      this.courseTitle,
      this.courseNum,
      this.selBgkColor,
      this.imageUrl,
      this.isEditPage = false})
      : super(key: key);

  String validateCourseTitle(value) {
    //判断用户数据
    if (value.isEmpty || value == "") {
      return "课程名称不能为空";
    }
    return null;
  }

  submitSave(context) async {
    if (FormKey.currentState.validate()) {
      ///保存
      FormKey.currentState.save();
      print(courseTitle);
      if (courseTitle != null && courseTitle.isNotEmpty) {
        ///显示加载按钮
        Provide.value<CreateCourseProvide>(context)
            .changeDisplaySave(status: false);
        CourseDo courseDo = CourseDo();
        courseDo.courseTitle = courseTitle;
        courseDo.number = courseNum;
        String year = Provide.value<CreateCourseProvide>(context).currentYear;
        List<String> strs = year.split('-');
        courseDo.start = int.parse(strs[0]);
        courseDo.end = int.parse(strs[1]);
        courseDo.semester =
            Provide.value<CreateCourseProvide>(context).currentSem;
        courseDo.bgkColor = selBgkColor;
        courseDo.bgkUrl = imageUrl;
        courseDo.teacherId = Provide.value<UserProvide>(context).userId;
        Provide.value<CreateCourseProvide>(context).courseDo = courseDo;
        print(courseDo);
        if(!isEditPage){
          //TODO 创建课程
          Course course = await TeacherMethod.createCourse(context,courseDo: courseDo)
              .catchError((onError) {
            debugPrint(onError);
            Fluttertoast.showToast(
                msg: '创建失败,请稍后重试', gravity: ToastGravity.CENTER);
          }).whenComplete(() {
            ///创建结束，关闭按钮加载状态
            Provide.value<CreateCourseProvide>(context)
                .changeDisplaySave(status: true);
          });
          Navigator.pop(context, course);
        }else{
          //TODO 修改课程
          courseDo.courseId=courseId;
          print("//TODO 修改课程 updateCourse: ${courseDo}");
          Course course = await TeacherMethod.updateCourse(context,userId: Provide.value<UserProvide>(context).userId,courseDo: courseDo)
              .catchError((onError) {
            debugPrint(onError);
            Fluttertoast.showToast(
                msg: '修改失败,请稍后重试', gravity: ToastGravity.CENTER);
          }).whenComplete(() {
            ///结束，关闭按钮加载状态
            Provide.value<CreateCourseProvide>(context)
                .changeDisplaySave(status: true);
          });
          Navigator.pop(context, course);
        }

      } else {
        Fluttertoast.showToast(
          msg: "课程名称不能为空",
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil.screenWidth,
        child: Scaffold(
            appBar: AppBar(
              title: Text('${titlePage}'),
              elevation: 0.0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: <Widget>[
                Provide<CreateCourseProvide>(
                  builder: (context, child, data) {
                    return Container(
                      width: 60,
                      margin: EdgeInsets.all(10),
                      child: FlatButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          disabledColor: Colors.grey.withOpacity(0.7),
                          disabledTextColor: Colors.black45,
                          onPressed: (data.displaySave)
                              ? () => submitSave(context)
                              : null,
                          child: (data.displaySave)
                              ? Text('保存')
                              : SpinKitWave(
                                  color: Colors.white,
                                  type: SpinKitWaveType.start,
                                  size: ScreenUtil.textScaleFactory*15,
                                ) //,
                          ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                Form(
                  key: FormKey,
                  child: Column(
                    children: <Widget>[
                      _itemWidget(
                          title: '课程名称',
                          hintText: '请输入课程名称(必填)',
                          valueStr: 'courseTitle',
                          valid: validateCourseTitle,
                          initialValue: courseTitle),
                      _itemWidget(
                          title: '课号',
                          hintText: '请输入课程课号(选填)',
                          valueStr: 'courseNum',
                          initialValue: courseNum),
                      Container(
                        height: 20,
                        color: Colors.black26,
                      ),
                      _provider_widget(context),
                      Container(
                        height: 30,
                        color: Colors.black12,
                        child: Row(
                          children: <Widget>[Text('选择课程背景(非必选项)')],
                        ),
                      ),
                      TabBarWidget(),
                      Provide<CreateCourseProvide>(
                          builder: (context, child, data) {
                        if (data.currentIndex == 0) {
                          return _bgkImageWidget(context,
                              bgkUrl: data.bgkUrl, displayPro: data.displayPro);
                        } else {
                          return Container(
                            width: ScreenUtil().width,
                            height: 230,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),

                              ///禁止上下拉动出现波纹
                              crossAxisCount: 3,
                              padding: EdgeInsets.all(5.0),
                              children: _tags.map((tag) {
                                return FilterChip(
                                  label: Text(
                                    tag,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Constants.bgkMap[tag],
                                  selectedColor: Constants.bgkMap[tag],
                                  selected: data.selectedBgk.contains(tag),
                                  checkmarkColor: Colors.white,
                                  onSelected: (value) {
                                    selBgkColor = tag;
                                    Provide.value<CreateCourseProvide>(context)
                                        .AddselectedBgk(tag: tag);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                )
              ]),
            )));
  }

  Widget _bgkImageWidget(context,
      {progrees = false, String bgkUrl, bool displayPro}) {
    return Container(
      height: 250,
      child: ListView(
        children: <Widget>[
          (displayPro == true)
              ? SizedBox(
                  height: 30,
                  child: LiquidCircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.grey),
                    borderColor: Colors.white,
                    borderWidth: 5.0,
                    center: Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          _uploadImage(context, bgkUrl: bgkUrl),
        ],
      ),
    );
  }

  ///上传背景图片
  Widget _uploadImage(context, {String bgkUrl}) {
    return Container(
        height: 230,
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: (bgkUrl.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(bgkUrl), fit: BoxFit.cover)
                : null),
        child: InkWell(
          onTap: () async {
            List<Media> _listImagePaths = await ImagePickers.pickerPaths(
                galleryMode: GalleryMode.image,
                selectCount: 1,
                showCamera: true,
                compressSize: 500,
                ///超过500KB 将压缩图片
                uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
                cropConfig: CropConfig(enableCrop: true, width: 1, height: 1));

            ///显示进度条
            Provide.value<CreateCourseProvide>(context)
                .changeProgress(display: true);
            UserHeadImage userHeadImage = await UserMethod.uploadImage(context,
                imagePath: _listImagePaths[0].path,
                onSendProgress: (int count, int total) {
                  print(
                      "count :  ${count}, total: ${total} ${(count / total) * 100}%");
                }).catchError((onError) {
              Fluttertoast.showToast(
                msg: onError.toString(),
                gravity: ToastGravity.BOTTOM,
              );
              print("error ${onError}");
            }).whenComplete(() {
              ///关闭进度条
              Provide.value<CreateCourseProvide>(context)
                  .changeProgress(display: false);
            });
            if (userHeadImage != null) {
              imageUrl = userHeadImage.faceImageBig;
              Provide.value<CreateCourseProvide>(context)
                  .changebgkUrl(imageUrl);
              print("imageUrl :${imageUrl}");
            }
          },
          child: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: ScreenUtil.textScaleFactory*50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      '上传图片',
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                ],
              )),
        ));
  }

  ///学年学期
  Widget _provider_widget(context) {
    return Provide<CreateCourseProvide>(
      builder: (context, child, data) {
        return Column(
          children: <Widget>[
            SelectItemWidget(
              title: '选择学年',
              height: 50,
              widget: Text(data.currentYear),
              onTap: () {
                _openModalBottomSheet(context, title: '学年选择', okCallBack: () {
                  //TODO
                  Provide.value<CreateCourseProvide>(context).changeCurrentYear(
                      Provide.value<CreateCourseProvide>(context)
                          .groupValueYear);
                  Navigator.pop(context);
                });
              },
            ),
            SelectItemWidget(
              title: '选择学期',
              height: 50,
              widget: Text((data.currentSem == 1)
                  ? '第一学期'
                  : (data.currentSem == 2) ? '第二学期' : ''),
              onTap: () {
                _openModalBottomSheet(
                  context,
                  height: 150,
                  title: '学期选择',
                  widget: ListView(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Provide.value<CreateCourseProvide>(context)
                              .changeGroupSem(1);
                          Navigator.pop(context);
                        },
                        child: (data.currentSem != 1)
                            ? Text('第一学期')
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('第一学期'),
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Provide.value<CreateCourseProvide>(context)
                              .changeGroupSem(2);
                          Navigator.pop(context);
                        },
                        child: (data.currentSem != 2)
                            ? Text('第二学期')
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('第二学期'),
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  ///输入框
  Widget _itemWidget(
      {title, hintText, valueStr, Function valid, String initialValue}) {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      alignment: Alignment.centerLeft,
      height: 55,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(Constants.DividerColor),
                  width: Constants.DividerWith))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil.textScaleFactory*20,
                  fontWeight: FontWeight.w500),
            ),
            flex: 1,
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: ScreenUtil.textScaleFactory*18,
                  fontFamily: 'SF-UI-Display-Regular'),
              keyboardType: TextInputType.text,
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              initialValue: initialValue,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
              onSaved: (value) {
                if (valueStr == 'courseTitle') {
                  courseTitle = value;
                } else if (valueStr == 'courseNum') {
                  courseNum = value;
                }
              },
              //validator: valid,
            ),
            flex: 3,
          )
        ],
      ),
    );
  }

  ///学年选择
  Future _openModalBottomSheet(context,
      {double height = 250,
      @required String title,
      Widget widget,
      VoidCallback okCallBack}) async {
    int currentYear = DateTime.now().year;
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: height,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('取消',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: ScreenUtil.textScaleFactory*20,
                            ))),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.w500),
                    ),
                    (okCallBack != null)
                        ? FlatButton(
                            onPressed: okCallBack,
                            child: Text(
                              '确认',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize:  ScreenUtil.textScaleFactory*20,
                              ),
                            ))
                        : FlatButton(
                            onPressed: null,
                            child: Text(
                              '',
                            )),
                  ],
                ),
                Expanded(
                  child: (widget == null)
                      ? Provide<CreateCourseProvide>(
                          builder: (context, child, data) {
                            var groupValue = data.groupValueYear;
                            print(groupValue);
                            return ListView(
                              children: <Widget>[
                                _selectRadio(
                                  context,
                                  currentYear: currentYear - 2,
                                  groupValue: groupValue,
                                ),
                                _selectRadio(
                                  context,
                                  currentYear: currentYear - 1,
                                  groupValue: groupValue,
                                ),
                                _selectRadio(
                                  context,
                                  currentYear: currentYear,
                                  groupValue: groupValue,
                                ),
                                _selectRadio(
                                  context,
                                  currentYear: currentYear + 1,
                                  groupValue: groupValue,
                                ),
                                _selectRadio(
                                  context,
                                  currentYear: currentYear + 2,
                                  groupValue: groupValue,
                                ),
                                _selectRadio(
                                  context,
                                  currentYear: currentYear + 3,
                                  groupValue: groupValue,
                                ),
                                _selectRadio(
                                  context,
                                  currentYear: currentYear + 4,
                                  groupValue: groupValue,
                                ),
                              ],
                            );
                          },
                        )
                      : widget,
                ),
              ],
            ),
          );
        });
    print(option);
    return option;
  }

  ///选择
  Widget _selectRadio(context, {currentYear, groupValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${currentYear}-${currentYear + 1}',
          style: TextStyle(fontSize: ScreenUtil().setSp(35)),
        ),
        Radio(
            value: '${currentYear}-${currentYear + 1}',
            groupValue: groupValue,
            onChanged: (T) {
              Provide.value<CreateCourseProvide>(context).changeGroupValue(T);
            }),
      ],
    );
  }
}
