class UserInfoVo {
  int userId;
  String phoneNumber;
  String nickname;
  String realName;
  int sex;
  String faceImage;
  String faceImageBig;
  String email;
  String cid;
  int role;
  String schoolName;

  @override
  String toString() {
    return 'UserInfoVo{userId: $userId, phoneNumber: $phoneNumber, nickname: $nickname, realName: $realName, sex: $sex, faceImage: $faceImage, faceImageBig: $faceImageBig, email: $email, cid: $cid, role: $role, schoolName: $schoolName}';
  }

  UserInfoVo(
      {this.userId,
        this.phoneNumber,
        this.nickname,
        this.realName,
        this.sex,
        this.faceImage,
        this.faceImageBig,
        this.email,
        this.cid,
        this.role,
        this.schoolName});

  UserInfoVo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phoneNumber = json['phoneNumber'];
    nickname = json['nickname'];
    realName = json['realName'];
    sex = json['sex'];
    faceImage = json['faceImage'];
    faceImageBig = json['faceImageBig'];
    email = json['email'];
    cid = json['cid'];
    role = json['role'];
    schoolName = json['schoolName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['phoneNumber'] = this.phoneNumber;
    data['nickname'] = this.nickname;
    data['realName'] = this.realName;
    data['sex'] = this.sex;
    data['faceImage'] = this.faceImage;
    data['faceImageBig'] = this.faceImageBig;
    data['email'] = this.email;
    data['cid'] = this.cid;
    data['role'] = this.role;
    data['schoolName'] = this.schoolName;
    return data;
  }
}