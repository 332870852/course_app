class AttendanceStudentDto {
  int attendanceStudentId;
  String attendCode;
  double longitude;
  double latitude;
  String address;
  int type;
  String attendanceId;
  String date;

  AttendanceStudentDto(
      {this.attendanceStudentId,
      this.attendCode,
      this.longitude,
      this.latitude,
      this.address,
      this.type,
      this.attendanceId,
      this.date});


  @override
  String toString() {
    return 'AttendanceStudentDto{attendanceStudentId: $attendanceStudentId, attendCode: $attendCode, longitude: $longitude, latitude: $latitude, address: $address, type: $type, attendanceId: $attendanceId, date: $date}';
  }

  AttendanceStudentDto.fromJson(Map<String, dynamic> json) {
    attendanceStudentId = json['attendanceStudentId'];
    attendCode = json['attendCode'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
    type = json['type'];
    attendanceId = json['attendanceId'];
    date=json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendanceStudentId'] = this.attendanceStudentId;
    data['attendCode'] = this.attendCode;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address'] = this.address;
    data['type'] = this.type;
    data['attendanceId'] = this.attendanceId;
    data['date']=this.date;
    return data;
  }
}
