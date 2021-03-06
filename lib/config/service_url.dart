const serviceUrl =
    'http://47.102.97.30:11001/'; //'http://192.168.200.104:11001/'
const webSocketUrl = 'ws://47.102.97.30:11001/wsServer/';
const nettyUrl = 'ws://47.102.97.30:10090/ws';

//
//const serviceUrl = 'http://192.168.43.186:11001/';
//const webSocketUrl = 'ws://192.168.43.186:10090/ws'; //wsServer  47.102.97.30
//const nettyUrl = 'ws://192.168.43.186:10090/ws';

class studentPath {
  static const servicePath = {
    'getCoursePage': 'student/getCoursePage',
    'joinCourse': 'student/joinCourse',
    'removeCourse': 'student/removeCourse',
    'findAttendanceStudentScore': 'findAttendanceStudentScore',
    'AttendanceStudentCheck': 'AttendanceStudentCheck',
    'getClassWorkListByStudent':'student/getClassWorkListByStudent',
    'uploadClassWorkFile':'student/uploadClassWorkFile',
    'commitCourseWork':'student/commitCourseWork',
    'statisticsAttendanceByStuId':'student/statisticsAttendanceByStuId',
    'statisticsClasswork':'student/statisticsClasswork',
  };
}

class userPath {
  static const servicePath = {
    'userLongin': 'userLongin',
    'registerUser': 'registerUser',
    'refreshLogin': 'refreshLogin',
    'userlogout': 'userlogout',
    'exitsUserName': 'exitsUserName',
    'getUserQRcode': 'getUserQRcode',
    'getUserHeadImage': 'getUserHeadImage',
    'getUserInfo': 'getUserInfo',
    'updateUser': 'updateUser',
    'uploadFaceFile': 'uploadFaceFile',
    'uploadImage': 'uploadImage',
    'getAnnouncementPage': 'getAnnouncementPage',
    'getEveryUserInfo': 'getEveryUserInfo',
    'getReplyListPage': 'getCommentAnnPage',
    'getUserFriend': 'getUserFriend',
    'userPwdChange': 'userPwdChange',
    'getStudentInfo': 'getStudentInfo',
    'getFriendsUserInfo': 'getFriendsUserInfo',
    'getAllMyFriends': 'getAllMyFriends',
    'IsMyFriend': 'IsMyFriend',
    'agreeFriend': 'agreeFriend',
    'uploadChatImageBase64': 'uploadChatImageBase64',
    'uploadChatVideo': 'uploadChatVideo',
    'uploadCourseFile': 'uploadCourseFile',
    'getFileInfoList': 'getFileInfoList',
    'deleteCourseFile': 'deleteCourseFile',
    'getTopicList': 'getTopicList',
    'createTopic': 'createTopic',
    'getTopicCommentList':'getTopicCommentList',
    'createTopicComment':'createTopicComment',
    'commendationTop':'commendationTop',
    'getClassWorkFileList':'getClassWorkFileList',
  };
}

class teacherPath {
  static const servicePath = {
    'createCourse': 'teacher/createCourse',
    'getCreateCoursesPage': 'teacher/getCreateCoursesPage',
    'updateCourse': 'teacher/updateCourse',
    'deleteCourse': 'teacher/deleteCourse',
    'createAnnouncement': 'createAnnouncement',
    'updateAnnouncement': 'updateAnnouncement',
    'delAnnouncement': 'delAnnouncement',
    'getCourseQRcode': 'getCourseQRcode',
    'getAttendanceList': 'teacher/getAttendanceList',
    'createAttendance': 'teacher/createAttendance',
    'updateAttendanceStudent': 'teacher/updateAttendanceStudent',
    'delAttendance': 'teacher/delAttendance',
    'getStudentListId': 'course/getStudentListId',
    'getClassWorkList':'teacher/getClassWorkList',
    'createClassWork':'teacher/createClassWork',
    'reviseStudentWork':'teacher/reviseStudentWork',
  };
}
