class AttendanceVo {
  int attendanceId;
  String courseId;
  String publisherId;
  String attendCode;
  double longitude;
  double latitude;
  int distance;
  String address;
  int type;
  int expire;
  String createTime;
  List<AttendanceStudents> attendanceStudents;
  Map<int, List<AttendanceStudents>> map = Map();

  AttendanceVo(
      {this.attendanceId,
      this.courseId,
      this.publisherId,
      this.attendCode,
      this.longitude,
      this.latitude,
      this.distance,
      this.address,
      this.type,
      this.expire,
      this.createTime,
      this.attendanceStudents,
      this.map});

  @override
  String toString() {
    return 'AttendanceVo{attendanceId: $attendanceId, courseId: $courseId, publisherId: $publisherId, attendCode: $attendCode, longitude: $longitude, latitude: $latitude, distance: $distance, address: $address, type: $type, expire: $expire, createTime: $createTime, attendanceStudents: $attendanceStudents, map: $map}';
  }

  AttendanceVo.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendanceId'];
    courseId = json['courseId'];
    publisherId = json['publisherId'];
    attendCode = json['attendCode'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    distance = json['distance'];
    address = json['address'];
    type = json['type'];
    expire = json['expire'];
    createTime = json['createTime'];
    if (json['attendanceStudents'] != null) {
      attendanceStudents = new List<AttendanceStudents>();
      json['attendanceStudents'].forEach((v) {
        attendanceStudents.add(new AttendanceStudents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendanceId'] = this.attendanceId;
    data['courseId'] = this.courseId;
    data['publisherId'] = this.publisherId;
    data['attendCode'] = this.attendCode;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['distance'] = this.distance;
    data['address'] = this.address;
    data['type'] = this.type;
    data['expire'] = this.expire;
    data['createTime'] = this.createTime;
    if (this.attendanceStudents != null) {
      data['attendanceStudents'] =
          this.attendanceStudents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//class AttendanceStudents {
//  int attendanceStudentId;
//  String studentId;
//  int status;
//  double longitude;
//  double latitude;
//  int distance;
//  String address;
//  String time;
//  String attendanceId;
//
//  AttendanceStudents(
//      {this.attendanceStudentId,
//      this.studentId,
//      this.status,
//      this.longitude,
//      this.latitude,
//      this.distance,
//      this.address,
//      this.time,
//      this.attendanceId});
//
//  @override
//  String toString() {
//    return 'AttendanceStudents{attendanceStudentId: $attendanceStudentId, studentId: $studentId, status: $status, longitude: $longitude, latitude: $latitude, distance: $distance, address: $address, time: $time, attendanceId: $attendanceId}';
//  }
//
//  AttendanceStudents.fromJson(Map<String, dynamic> json) {
//    attendanceStudentId = json['attendanceStudentId'];
//    studentId = json['studentId'];
//    status = json['status'];
//    longitude = json['longitude'];
//    latitude = json['latitude'];
//    distance = json['distance'];
//    address = json['address'];
//    time = json['time'];
//    attendanceId = json['attendanceId'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['attendanceStudentId'] = this.attendanceStudentId;
//    data['studentId'] = this.studentId;
//    data['status'] = this.status;
//    data['longitude'] = this.longitude;
//    data['latitude'] = this.latitude;
//    data['distance'] = this.distance;
//    data['address'] = this.address;
//    data['time'] = this.time;
//    data['attendanceId'] = this.attendanceId;
//    return data;
//  }
//}


class AttendanceStudents {
  int attendanceStudentId;
  String studentId;
  int status;
  double longitude;
  double latitude;
  num distance;
  String address;
  int type;
  String time;
  String attendanceId;


  AttendanceStudents({this.attendanceStudentId, this.studentId, this.status,
    this.longitude, this.latitude, this.distance, this.address, this.type,
    this.time, this.attendanceId});


  @override
  String toString() {
    return 'AttendanceStudents{attendanceStudentId: $attendanceStudentId, studentId: $studentId, status: $status, longitude: $longitude, latitude: $latitude, distance: $distance, address: $address, type: $type, time: $time, attendanceId: $attendanceId}';
  }

  AttendanceStudents.fromJson(Map<String, dynamic> json) {
    attendanceStudentId = json['attendanceStudentId'];
    studentId = json['studentId'].toString();
    status = json['status'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    distance = json['distance'];
    address = json['address'].toString();
    type=json['type'];
    time = json['time'].toString();
    attendanceId = json['attendanceId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendanceStudentId'] = this.attendanceStudentId;
    data['studentId'] = this.studentId;
    data['status'] = this.status;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['distance'] = this.distance;
    data['address'] = this.address;
    data['type'] = this.type;
    data['time'] = this.time;
    data['attendanceId'] = this.attendanceId;
    return data;
  }
}
