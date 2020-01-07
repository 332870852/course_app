class UserDto {
  String phoneNumber;
  String password;
  String email;
  UserSubDto userSubDto;

  UserDto({this.phoneNumber, this.password, this.email, this.userSubDto});

  @override
  String toString() {
    return 'UserDto{phoneNumber: $phoneNumber, password: $password, email: $email, userSubDto: $userSubDto}';
  }

  UserDto.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    email = json['email'];
    userSubDto = json['userSubDto'] != null
        ? new UserSubDto.fromJson(json['userSubDto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['email'] = this.email;
    if (this.userSubDto != null) {
      data['userSubDto'] = this.userSubDto.toJson();
    }
    return data;
  }
}

class UserSubDto {
  String schoolName;
  String realName;
  int role;
  String nickname;
  int sex;
  String faceImage;
  String faceImageBig;
  String stuId;
  String workId;
  String classId;
  DateTime time;

  UserSubDto(
      {this.schoolName,
        this.realName,
        this.role,
        this.nickname,
        this.sex,
        this.faceImage,
        this.faceImageBig,
        this.stuId,
        this.workId,
        this.classId,
        this.time});

  @override
  String toString() {
    return 'UserSubDto{schoolName: $schoolName, realName: $realName, role: $role, nickname: $nickname, sex: $sex, faceImage: $faceImage, faceImageBig: $faceImageBig, stuId: $stuId, workId: $workId, classId: $classId, time: $time}';
  }

  UserSubDto.fromJson(Map<String, dynamic> json) {
    schoolName = json['schoolName'];
    realName = json['realName'];
    role = json['role'];
    nickname = json['nickname'];
    sex = json['sex'];
    faceImage = json['faceImage'];
    faceImageBig = json['faceImageBig'];
    stuId = json['stuId'];
    workId = json['workId'];
    classId = json['classId'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schoolName'] = this.schoolName;
    data['realName'] = this.realName;
    data['role'] = this.role;
    data['nickname'] = this.nickname;
    data['sex'] = this.sex;
    data['faceImage'] = this.faceImage;
    data['faceImageBig'] = this.faceImageBig;
    data['stuId'] = this.stuId;
    data['workId'] = this.workId;
    data['classId'] = this.classId;
    data['time'] = this.time;
    return data;
  }
}