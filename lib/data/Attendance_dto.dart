class AttendanceDto {
  String courseId;
  double longitude;
  double latitude;
  String address;
  int distance;
  int type;
  int expire;
  String createTime;

  AttendanceDto({
    this.courseId,
    this.longitude,
    this.latitude,
    this.distance,
    this.address,
    this.type,
    this.expire,
    this.createTime,
  });

  @override
  String toString() {
    return 'AttendanceDto{courseId: $courseId, longitude: $longitude, latitude: $latitude, address: $address, distance: $distance, type: $type, expire: $expire, createTime: $createTime}';
  }

  AttendanceDto.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    distance = json['distance'];
    address = json['address'];
    type = json['type'];
    expire = json['expire'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['distance'] = this.distance;
    data['address'] = this.address;
    data['type'] = this.type;
    data['expire'] = this.expire;
    data['createTime'] = this.createTime;
    return data;
  }
}
