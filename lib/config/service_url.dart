const serviceUrl = 'http://192.168.200.114:11001/';  //'http://192.168.200.104:11001/'

class studentPath {
  static const servicePath = {
    'getCoursePage': 'student/getCoursePage',
    'joinCourse': 'student/joinCourse',
     'removeCourse':'student/removeCourse',
  };
}

class userPath{
  //static String userId="2";
  static const servicePath = {
    'getUserHeadImage': 'getUserHeadImage',
    'getUserInfo':'getUserInfo',
    'updateUser':'updateUser',
    'uploadFaceFile':'uploadFaceFile',
    'uploadImage':'uploadImage',
    'getAnnouncementPage':'getAnnouncementPage',
    'getEveryUserInfo':'getEveryUserInfo',
    'getReplyListPage':'getCommentAnnPage',
  };
}

class teacherPath{

  static const servicePath = {
    'createCourse':'teacher/createCourse',
    'getCreateCoursesPage':'teacher/getCreateCoursesPage',
    'updateCourse':'teacher/updateCourse',
    'deleteCourse':'teacher/deleteCourse',
    'createAnnouncement':'createAnnouncement',
    'updateAnnouncement':'updateAnnouncement',
    'delAnnouncement':'delAnnouncement',
  };
}
