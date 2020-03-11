//agree
class AgreeReq{

  String sid;
  String friendId;
  String requestDateTime;
  bool agree;

  AgreeReq({this.sid, this.friendId, this.requestDateTime, this.agree});

  @override
  String toString() {
    return 'AgreeReq{sid: $sid, friendId: $friendId, requestDateTime: $requestDateTime, agree: $agree}';
  }

}