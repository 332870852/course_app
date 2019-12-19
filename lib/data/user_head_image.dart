
class UserHeadImage{

  int userId;
  String faceImage;
  String faceImageBig;

  UserHeadImage({this.userId, this.faceImage, this.faceImageBig});

  UserHeadImage.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    faceImage = json['faceImage'];
    faceImageBig = json['faceImageBig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['faceImage'] = this.faceImage;
    data['faceImageBig'] = this.faceImageBig;
    return data;
  }
}