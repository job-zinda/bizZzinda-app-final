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

  List<dynamic> conversations = [];
  bool isLoading = true;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    getConversations();

    timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => getConversations(showLoader: false),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> getConversations({bool showLoader = true}) async {
    try {
      if (showLoader && mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final headers = await LoggedInUser.getAuthorizationHeader();

      final response = await dio.get(
        Api.listConversations,
        options: Options(
          headers: {
            ...headers,
            "Accept": "application/json",
          },
        ),
      );

      List<dynamic> list = [];

      if (response.data is Map) {
        if (response.data["data"] is List) {
          list = response.data["data"];
        } else if (response.data["conversations"] is List) {
          list = response.data["conversations"];
        } else if (response.data["data"]?["conversations"] is List) {
          list = response.data["data"]["conversations"];
        }
      }

      debugPrint("CHAT LIST STATUS => ${response.statusCode}");
      debugPrint("CHAT LIST COUNT => ${list.length}");

      if (!mounted) return;

      setState(() {
        conversations = list;
        isLoading = false;
      });
    } on DioException catch (e) {
      debugPrint("CHAT LIST STATUS => ${e.response?.statusCode}");
      debugPrint("CHAT LIST ERROR => ${e.response?.data}");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("CHAT LIST ERROR => $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      final headers = await LoggedInUser.getAuthorizationHeader();

      await dio.patch(
        "${AppUrl.baseurl}/api/v1/biz-chat/markAsRead/$conversationId",
        options: Options(
          headers: {
            ...headers,
            "Accept": "application/json",
          },
        ),
      );

      debugPrint("MARK READ SUCCESS => $conversationId");
    } on DioException catch (e) {
      debugPrint("MARK READ STATUS => ${e.response?.statusCode}");
      debugPrint("MARK READ ERROR => ${e.response?.data}");
    } catch (e) {
      debugPrint("MARK READ ERROR => $e");
    }
  }

  String _participantUserId(dynamic participant) {
    if (participant is! Map) return "";

    final userId = participant["userId"];

    if (userId is String) return userId;

    if (userId is Map && userId["_id"] != null) {
      return userId["_id"].toString();
    }

    return "";
  }

  Map<String, dynamic> _participantUser(dynamic participant) {
    if (participant is! Map) return {};

    final userId = participant["userId"];

    if (userId is Map) {
      return Map<String, dynamic>.from(userId);
    }

    if (userId is String) {
      return {
        "_id": userId,
        "name": "User",
        "profileImageUrl": "",
      };
    }

    return {};
  }

  Map<String, dynamic> getOtherUser(dynamic convo) {
    final myId = LoggedInUser.id.toString();

    if (convo is! Map) return {};

    final participants = convo["participants"];

    if (participants is! List || participants.isEmpty) {
      return {};
    }

    for (final participant in participants) {
      final participantId = _participantUserId(participant);

      if (participantId.isNotEmpty && participantId != myId) {
        return _participantUser(participant);
      }
    }

    return _participantUser(participants.first);
  }

  String getName(dynamic convo) {
    final user = getOtherUser(convo);

    final userName = user["name"]?.toString();
    if (userName != null && userName.isNotEmpty && userName != "null") {
      return userName;
    }

    if (convo is Map && convo["shopId"] is Map) {
      final shopName = convo["shopId"]["shopName"]?.toString();
      if (shopName != null && shopName.isNotEmpty && shopName != "null") {
        return shopName;
      }
    }

    return "Chat";
  }

  String getImage(dynamic convo) {
    final user = getOtherUser(convo);

    final profileImage = user["profileImageUrl"]?.toString();
    if (profileImage != null &&
        profileImage.isNotEmpty &&
        profileImage != "null") {
      return profileImage;
    }

    if (convo is Map && convo["shopId"] is Map) {
      final shopImage = convo["shopId"]["profileImage"]?.toString();
      if (shopImage != null && shopImage.isNotEmpty && shopImage != "null") {
        return shopImage;
      }
    }

    return "";
  }

  String getLastMessage(dynamic convo) {
    if (convo is! Map) return "No messages yet";

    final lastMessage = convo["lastMessage"];

    if (lastMessage is! Map) {
      return "No messages yet";
    }

    final content = lastMessage["content"]?.toString() ?? "";
    if (content.isNotEmpty) {
      if (content.startsWith("http")) {
        return "Photo";
      }

      if (content.startsWith("{") && content.contains('"type":"offer"')) {
        return "Offer";
      }

      return content;
    }

    final messageId = lastMessage["messageId"];

    if (messageId is Map) {
      final nestedContent = messageId["content"]?.toString() ?? "";
      if (nestedContent.isNotEmpty) {
        if (nestedContent.startsWith("http")) {
          return "Photo";
        }

        if (nestedContent.startsWith("{") &&
            nestedContent.contains('"type":"offer"')) {
          return "Offer";
        }

        return nestedContent;
      }

      final nestedType = messageId["messageType"]?.toString() ?? "";
      if (nestedType == "image") {
        return "Photo";
      }
    }

    final type = lastMessage["messageType"]?.toString() ?? "";
    if (type == "image") {
      return "Photo";
    }

    return "No messages yet";
  }

  int getUnread(dynamic convo) {
    if (convo is! Map) return 0;

    final unread = convo["unreadCount"];

    if (unread is int) return unread;
    if (unread is String) return int.tryParse(unread) ?? 0;

    return 0;
  }

  Future<void> openChat(dynamic convo) async {
    if (convo is! Map) return;

    final conversationId = convo["_id"]?.toString() ?? "";

    if (conversationId.isEmpty) {
      debugPrint("OPEN CHAT FAILED => conversation id empty");
      return;
    }

    // setState(() {
    //   final index = conversations.indexWhere(
    //         (item) => item is Map && item["_id"]?.toString() == conversationId,
    //   );
    //
    //   if (index != -1 && conversations[index] is Map) {
    //     conversations[index] = {
    //       ...conversations[index],
    //       "unreadCount": 0,
    //     };
    //   }
    // });
    setState(() {
      final index = conversations.indexWhere(
            (item) =>
        item is Map &&
            item["_id"]?.toString() == conversationId,
      );

      if (index != -1) {
        final updatedConversation =
        Map<String, dynamic>.from(conversations[index]);

        updatedConversation["unreadCount"] = 0;

        conversations[index] = updatedConversation;
      }
    });

    // await markConversationAsRead(conversationId);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: conversationId,
          shopName: getName(convo),
          userProfile: getImage(convo),
        ),
      ),
    );

    getConversations(showLoader: false);
  }

  Widget _emptyState() {
    return RefreshIndicator(
      onRefresh: () => getConversations(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 260),
          Center(
            child: Text(
              "No chats yet",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatTile(dynamic convo) {
    final name = getName(convo);
    final image = getImage(convo);
    final lastMessage = getLastMessage(convo);
    final unread = getUnread(convo);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
          child: image.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: unread > 0
            ? CircleAvatar(
          radius: 12,
          backgroundColor: Colors.red,
          child: Text(
            unread.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        )
            : null,
        onTap: () => openChat(convo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : conversations.isEmpty
          ? _emptyState()
          : RefreshIndicator(
        onRefresh: () => getConversations(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            return _chatTile(conversations[index]);
          },
        ),
      ),
    );
  }
}


