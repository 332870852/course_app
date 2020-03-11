
class FriendItem {
  String fiendId;
  String headUrl;
  String username;
  int state;

  FriendItem({this.fiendId, this.headUrl, this.username, this.state});

  @override
  String toString() {
    return 'FriendItem{fiendId: $fiendId, headUrl: $headUrl, username: $username, state: $state}';
  }

}

class ConcactItem{

   String title;
   String numToal;
   List<FriendItem> friends;
   ConcactItem({this.title, this.numToal, this.friends});

   @override
   String toString() {
     return 'ConcactItem{title: $title, numToal: $numToal, friends: $friends}';
   }
}

//好友表
class MyFriendsVo{
   String id;
   String myUserId;
   String myFriendUserId;
   int state=1;

   MyFriendsVo({this.id, this.myUserId, this.myFriendUserId,
     this.state});

   @override
   String toString() {
     return 'MyFriendsVo{id: $id, myUserId: $myUserId, myFriendUserId: $myFriendUserId, state: $state}';
   } //禁用0，正常1

   MyFriendsVo.fromJson(Map<String, dynamic> json) {
     id = json['id'];
     myUserId = json['myUserId'];
     myFriendUserId = json['myFriendUserId'];
     state = json['state'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['id'] = this.id;
     data['myUserId'] = this.myUserId;
     data['myFriendUserId'] = this.myFriendUserId;
     data['state'] = this.state;
     return data;
   }

}

