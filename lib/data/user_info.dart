class UserInfoVo {
  int userId;
  String phoneNumber;
  String nickname;
  int sex;
  String faceImage;
  String faceImageBig;
  String email;
  String cid;
  num role;
  IdentityVo identityVo;


  UserInfoVo(this.userId, this.phoneNumber, this.nickname, this.sex,
      this.faceImage, this.faceImageBig, this.email, this.cid, this.role,
      this.identityVo);


  @override
  String toString() {
    return 'UserInfoVo{userId: $userId, phoneNumber: $phoneNumber, nickname: $nickname, sex: $sex, faceImage: $faceImage, faceImageBig: $faceImageBig, email: $email, cid: $cid, role: $role, identityVo: $identityVo}';
  }

  UserInfoVo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phoneNumber = json['phoneNumber'];
    nickname = json['nickname'];
    sex = json['sex'];
    role=json['role'];
    faceImage = json['faceImage'];
    faceImageBig = json['faceImageBig'];
    email = json['email'];
    cid = json['cid'];
    identityVo = json['identityVo'] != null
        ? new IdentityVo.fromJson(json['identityVo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['phoneNumber'] = this.phoneNumber;
    data['nickname'] = this.nickname;
    data['sex'] = this.sex;
    data['role']=this.role;
    data['faceImage'] = this.faceImage;
    data['faceImageBig'] = this.faceImageBig;
    data['email'] = this.email;
    data['cid'] = this.cid;
    if (this.identityVo != null) {
      data['identityVo'] = this.identityVo.toJson();
    }
    return data;
  }
}

class IdentityVo {
  int identityId;
  String schoolName;
  int role;
  String realName;
  String stuId;
  String workId;
  String classId;
  String time;
  String faculty; //院系
  String teach; //所授课程
  String profession; //专业
  IdentityVo(
      {this.identityId,
        this.schoolName,
        this.role,
        this.realName,
        this.stuId,
        this.workId,
        this.classId,
        this.time});

  @override
  String toString() {
    return 'IdentityVo{identityId: $identityId, schoolName: $schoolName, role: $role, realName: $realName, stuId: $stuId, workId: $workId, classId: $classId, time: $time, faculty: $faculty, teach: $teach, profession: $profession}';
  }

  IdentityVo.fromJson(Map<String, dynamic> json) {
    identityId = json['identityId'];
    schoolName = json['schoolName'];
    role = json['role'];
    realName = json['realName'];
    stuId = json['stuId'];
    workId = json['workId'];
    classId = json['classId'];
    time = json['time'];
    faculty=json['faculty'];
    teach=json['teach'];
    profession=json['profession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identityId'] = this.identityId;
    data['schoolName'] = this.schoolName;
    data['role'] = this.role;
    data['realName'] = this.realName;
    data['stuId'] = this.stuId;
    data['workId'] = this.workId;
    data['classId'] = this.classId;
    data['time'] = this.time;
    data['faculty']=this.faculty;
    data['teach']=this.teach;
    data['profession']=this.profession;
    return data;
  }
}