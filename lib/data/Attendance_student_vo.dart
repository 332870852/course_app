//
//class AttendanceStudentVo {
//  int attendanceStudentId;
//  String studentId;
//  int status;
//  double longitude;
//  double latitude;
//  num distance;
//  String address;
//  int type;
//  String time;
//  String attendanceId;
//
//
//  AttendanceStudentVo(this.attendanceStudentId, this.studentId, this.status,
//      this.longitude, this.latitude, this.distance, this.address, this.type,
//      this.time, this.attendanceId);
//
//
//  @override
//  String toString() {
//    return 'AttendanceStudentVo{attendanceStudentId: $attendanceStudentId, studentId: $studentId, status: $status, longitude: $longitude, latitude: $latitude, distance: $distance, address: $address, type: $type, time: $time, attendanceId: $attendanceId}';
//  }
//
//  AttendanceStudentVo.fromJson(Map<String, dynamic> json) {
//    attendanceStudentId = json['attendanceStudentId'];
//    studentId = json['studentId'];
//    status = json['status'];
//    longitude = json['longitude'];
//    latitude = json['latitude'];
//    distance = json['distance'];
//    address = json['address'];
//    type=json['type'];
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
//    data['type'] = this.type;
//    data['time'] = this.time;
//    data['attendanceId'] = this.attendanceId;
//    return data;
//  }
//}
