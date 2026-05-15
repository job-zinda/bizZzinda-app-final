class ConversationModel {
  String? sId;
  List<Participants>? participants;
  LastMessage? lastMessage;
  String? createdUser;
  int? unreadCount;

  ConversationModel(
      {this.sId,
      this.participants,
      this.lastMessage,
      this.createdUser,
      this.unreadCount});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    lastMessage = json['lastMessage'] != null
        ? LastMessage.fromJson(json['lastMessage'])
        : null;
    createdUser = json['createdUser'];
    unreadCount = json['unreadCount'];
  }
}

class Participants {
  UserId? userId;
  String? lastReadMessageId;
  String? sId;

  Participants({this.userId, this.lastReadMessageId, this.sId});

  Participants.fromJson(Map<String, dynamic> json) {
    userId =
        json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    lastReadMessageId = json['lastReadMessageId'];
    sId = json['_id'];
  }
}

class UserId {
  String? sId;
  String? name;
  String? profileImageUrl;

  UserId({this.sId, this.name, this.profileImageUrl});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
  }
}

class LastMessage {
  String? sId;
  String? createdAt;
  String? content;
  MessageId? messageId;
  String? senderId;

  LastMessage(
      {this.sId, this.createdAt, this.content, this.messageId, this.senderId});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    content = json['content'];
    messageId = json['messageId'] != null
        ? MessageId.fromJson(json['messageId'])
        : null;
    senderId = json['senderId'];
  }
}

class MessageId {
  String? sId;
  String? conversationId;
  String? senderId;
  String? content;
  String? messageType;
  String? createdAt;
  String? updatedAt;

  MessageId(
      {this.sId,
      this.conversationId,
      this.senderId,
      this.content,
      this.messageType,
      this.createdAt,
      this.updatedAt});

  MessageId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    content = json['content'];
    messageType = json['messageType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
