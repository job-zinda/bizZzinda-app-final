import 'dart:async';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final Dio dio = Dio();

  List conversations = [];
  bool isLoading = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getConversations();

    // 🔄 auto refresh (optional)
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      getConversations();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 📥 API call
  Future<void> getConversations() async {
    try {
      final headers = await LoggedInUser.getAuthorizationHeader();

      final res = await dio.get(
        "${AppUrl.baseurl}/api/v1/biz-chat/listConversations?pageNumber=1&pageSize=10",
        options: Options(headers: {
          ...headers,
          "verifyPlatform": "bizzinda",
        }),
      );

      setState(() {
        conversations = res.data["data"]["conversations"];
        isLoading = false;
      });
    } catch (e) {
      print("Chat list error: $e");
      setState(() => isLoading = false);
    }
  }

  // 🧠 Get other user (not me)
  Map getOtherUser(convo) {
    final myId = LoggedInUser.id;

    return convo["participants"]
        .firstWhere((p) => p["userId"]["_id"] != myId)["userId"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
          ? const Center(child: Text("No chats yet"))
          : ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];

          final user = getOtherUser(convo);

          final lastMsg =
              convo["lastMessage"]?["content"] ?? "No messages yet";

          final unread = convo["unreadCount"] ?? 0;

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user["profileImageUrl"] != null
                  ? NetworkImage(user["profileImageUrl"])
                  : null,
              child: user["profileImageUrl"] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(user["name"] ?? ""),
            subtitle: Text(
              lastMsg,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: unread > 0
                ? CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Text(
                "$unread",
                style: const TextStyle(
                    color: Colors.white, fontSize: 12),
              ),
            )
                : null,

            // 👉 Open Chat
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    conversationId: convo["_id"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}