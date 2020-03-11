const serviceUrl = 'http://192.168.200.159:11001/';  //'http://192.168.200.104:11001/'
//const serviceUrl = 'http://192.168.43.186:11001/';
//const webSocketUrl = 'ws://192.168.200.159:10090/ws';//wsServer  47.102.97.30
const webSocketUrl = 'ws://192.168.200.159:11001/wsServer/';
const nettyUrl='ws://192.168.200.159:10090/ws';
class studentPath {
  static const servicePath = {
    'getCoursePage': 'student/getCoursePage',
    'joinCourse': 'student/joinCourse',
     'removeCourse':'student/removeCourse',
    'findAttendanceStudentScore':'findAttendanceStudentScore',
    'AttendanceStudentCheck':'AttendanceStudentCheck',
  };
}

class userPath{
  static const servicePath = {
    'userLongin':'userLongin',
    'registerUser':'registerUser',
    'refreshLogin':'refreshLogin',
    'userlogout':'userlogout',
    'exitsUserName':'exitsUserName',
    'getUserQRcode':'getUserQRcode',
    'getUserHeadImage': 'getUserHeadImage',
    'getUserInfo':'getUserInfo',
    'updateUser':'updateUser',
    'uploadFaceFile':'uploadFaceFile',
    'uploadImage':'uploadImage',
    'getAnnouncementPage':'getAnnouncementPage',
    'getEveryUserInfo':'getEveryUserInfo',
    'getReplyListPage':'getCommentAnnPage',
    'getUserFriend':'getUserFriend',
    'userPwdChange':'userPwdChange',
    'getStudentInfo':'getStudentInfo',
    'getFriendsUserInfo':'getFriendsUserInfo',
    'getAllMyFriends':'getAllMyFriends',
    'IsMyFriend':'IsMyFriend',
    'agreeFriend':'agreeFriend',
    'uploadChatImageBase64':'uploadChatImageBase64',
    'uploadChatVideo':'uploadChatVideo',
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
    'getCourseQRcode':'getCourseQRcode',
    'getAttendanceList':'teacher/getAttendanceList',
    'createAttendance':'teacher/createAttendance',
    'updateAttendanceStudent':'teacher/updateAttendanceStudent',
    'delAttendance':'teacher/delAttendance',
    'getStudentListId':'course/getStudentListId',
  };
}
