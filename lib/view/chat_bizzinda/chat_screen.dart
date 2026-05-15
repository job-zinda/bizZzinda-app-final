import 'dart:async';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Dio dio = Dio();
  final TextEditingController controller = TextEditingController();

  List messages = [];
  Timer? timer;

  Map<String, String> get headers => {
    "Authorization": "Bearer ${LoggedInUser.accessToken}",
    "verifyPlatform": "bizzinda",
  };
  String get currentUserId => LoggedInUser.id ?? "";
  @override
  void initState() {
    super.initState();
    getMessages();

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      getMessages();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 📥 Get Messages
  Future<void> getMessages() async {
    try {
      final res = await dio.get(
        "${AppUrl.baseurl}/api/v1/biz-chat/getMessages/${widget.conversationId}",
        options: Options(headers: headers),
      );

      final newMessages = res.data["data"]["messages"];

      setState(() {
        messages = newMessages;
      });

      // ✅ mark as read
      if (messages.isNotEmpty) {
        await markAsRead(messages.last["_id"]);
      }
    } catch (e) {
      print("getMessages error: $e");
    }
  }

  // ✅ Mark as Read
  Future<void> markAsRead(String lastMessageId) async {
    try {
      await dio.post(
        "${AppUrl.baseurl}/api/v1/biz-chat/markAsRead",
        data: {
          "conversationId": widget.conversationId,
          "lastMessageId": lastMessageId,
        },
        options: Options(headers: headers),
      );
    } catch (e) {
      print("markAsRead error: $e");
    }
  }

  // 📤 Send Message
  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    final text = controller.text.trim();
    controller.clear();

    try {
      await dio.post(
        "${AppUrl.baseurl}/api/v1/biz-chat/sendMessage",
        data: {
          "conversationId": widget.conversationId,
          "content": text,
          "messageType": "text",
        },
        options: Options(headers: headers),
      );

      getMessages();
    } catch (e) {
      print("sendMessage error: $e");
    }
  }

  // 💬 Message Bubble
  Widget messageBubble(msg) {
    bool isMe = msg["senderId"] == currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg["content"] ?? "",
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // 💬 Messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return messageBubble(msg);
              },
            ),
          ),

          // ✍️ Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}