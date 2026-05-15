class NotificationModel {
  String? sId;
  String? recipient;
  String? notificationType;
  String? title;
  String? description;
  String? onTapNavigate;
  String? sentOn;
  Sender? sender;
  bool? documentStatus;
  ConnectedProfileId? connectedProfileId;
  ConnectedPostId? connectedPostId;
  bool? viewStatus;
  int? iV;
  String? connectedTaskId;
  String? connectedTransactionId;


  NotificationModel(
      {this.sId,
      this.recipient,
      this.notificationType,
      this.title,
      this.description,
      this.onTapNavigate,
      this.sentOn,this.sender,
      this.documentStatus,
      this.connectedProfileId,
      this.connectedPostId,
           this.viewStatus,
      this.iV,
      this.connectedTaskId,
        this.connectedTransactionId,});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    recipient = json['recipient'];
    notificationType = json['notificationType'];
    title = json['title'];
    description = json['description'];
    onTapNavigate = json['onTapNavigate'];
    sentOn = json['sentOn'];
     sender =
        json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    documentStatus = json['documentStatus'];
    connectedProfileId = json['connectedProfileId'] != null
        ? ConnectedProfileId.fromJson(json['connectedProfileId'])
        : null;
    connectedPostId = json['connectedPostId'] != null
        ? ConnectedPostId.fromJson(json['connectedPostId'])
        : null;
    // connectedCommentId = json['connectedCommentId'];
    // connectedReplyId = json['connectedReplyId'];
    // viewStatus = json['viewStatus'];
    iV = json['__v'];
    connectedTaskId = json['connectedTaskId'];
    connectedTransactionId = json['connectedTransactionId'];
    viewStatus = json['viewStatus'];
  }
}
class Sender {
  String? sId;
  String? name;
  String? profileImageUrl;

  Sender({this.sId, this.name, this.profileImageUrl});

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
  }


}

class ConnectedProfileId {
  String? sId;
  String? name;
  String? profileImageUrl;

  ConnectedProfileId({this.sId, this.name, this.profileImageUrl});

  ConnectedProfileId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
  }
}

class ConnectedPostId {
  String? sId;
  String? mediaUrl;
  String? user;

  ConnectedPostId({this.sId, this.mediaUrl, this.user});

  ConnectedPostId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mediaUrl = json['mediaUrl'];
    user = json['user'];
  }
}
