const serviceUrl = 'http://192.168.200.117:11001/';  //'http://192.168.200.104:11001/'
//const serviceUrl = 'http://192.168.43.186:11001/';
//const webSocketUrl = 'ws://192.168.200.117:10090/ws';//wsServer
const webSocketUrl = 'ws://192.168.200.117:11001/wsServer/123';
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
    'userLongin':'userLongin',
    'refreshLogin':'refreshLogin',
    'userlogout':'userlogout',
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
