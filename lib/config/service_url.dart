const serviceUrl = 'http://192.168.200.104:11001/';

class studentPath {
  static const servicePath = {
    'getCoursePage': 'student/getCoursePage',
    'joinCourse': 'student/joinCourse',

  };
}

class userPath{
  //static String userId="2";
  static const servicePath = {
    'getUserHeadImage': 'getUserHeadImage',
    'getUserInfo':'getUserInfo',
    'updateUser':'updateUser',
    'uploadFaceFile':'uploadFaceFile',
    'uploadImage':'uploadImage'
  };
}

class teacherPath{

  static const servicePath = {
    'createCourse':'teacher/createCourse',
    'getCreateCoursesPage':'teacher/getCreateCoursesPage',
  };
}
