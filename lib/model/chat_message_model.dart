

class ChatMessageModel {
  String? sId;
  String? conversationId;
  SenderId? senderId;
  String? content;
  String? messageType;
  List<String>? attachments;
  String? createdAt;
  int? iV;

  ChatMessageModel(
      {this.sId,
      this.conversationId,
      this.senderId,
      this.content,
      this.messageType,
      this.attachments,
      this.createdAt,
      this.iV});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'] != null
        ? SenderId.fromJson(json['senderId'])
        : null;
    content = json['content'];
    messageType = json['messageType'];
    if (json['attachments'] != null) {
      attachments = <String>[];
      json['attachments'].forEach((v) {
        attachments!.add(v);
      });
    }
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['conversationId'] = conversationId;
    if (senderId != null) {
      data['senderId'] = senderId!.toJson();
    }
    data['content'] = content;
    data['messageType'] = messageType;
     if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v).toList();
    }
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}

class SenderId {
  String? sId;
  String? name;
  String? profileImageUrl;

  SenderId({this.sId, this.name, this.profileImageUrl});

  SenderId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}



