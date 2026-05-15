import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/main.dart' as main_app;
import 'package:biz_zinda/model/chat_message_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../model/conversation_model.dart';
import '../utils/api_service.dart';
import '../utils/api_url.dart';

class ChatDetailsViewModel extends ChangeNotifier {
  ConversationModel? conversationModel;
  String _pageType = "from profile";
  String get pageType => _pageType;
  set pageType(String value) {
    _pageType = value;
    notifyListeners();
  }

  String messageType = '';
  String? message;
  String? selectedUrl;
  String? audioUrl;
  String? recieverId;

  final RecorderController recorderController = RecorderController()
    ..androidEncoder = AndroidEncoder.aac
    ..androidOutputFormat = AndroidOutputFormat.mpeg4
    ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    ..bitRate = 44100;
  // ..sampleRate = 44100;

  bool loading = false;
  bool isrecord = false;
  String? error;

  String? audiopath;

  late Directory appDirectory;
  String? path;

  updateISRecord(bool? rec) {
    isrecord = rec!;
    notifyListeners();
  }

  updateAduioFile(BuildContext context, String? audio) async {
    audiopath = audio;
    messageType = 'audio';
    // Convert audio to Uint8List
    Uint8List? audioBytes = await convertAudioToUint8List(audio);
    audioUrl = await context
        .read<FileUploadViewModel>()
        .pickedAudioUpload(audioBytes, 'chat', audiopath!.split('/').last);
    notifyListeners();
    sentmessage(context: context);
  }

  // updateRecieverId(String id) {
  //   recieverId = id;
  //   pageType = "from profile";
  //   print("update reciever id------$recieverId---$pageType");
  //   notifyListeners();
  // }

  final TextEditingController messageController = TextEditingController();

  updateTextContect(String tex) {
    message = tex;
    messageType = 'text';
    notifyListeners();
  }

  updateImageContect(BuildContext contxt, String tex) {
    selectedUrl = tex;
    messageType = 'image';
    print("image");
    notifyListeners();
    if (pageType == "lets plan") {
      sentQuery(context: contxt);
    } else {
      sentmessage(context: contxt);
    }
  }

  updateConversationModel(ConversationModel val) {
    conversationModel = val;

    notifyListeners();
  }

  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
  }

  Future record(
    BuildContext context, {
    // required FlutterSoundRecorder recorder,
    required bool isRecorderReady,
  }) async {
    if (!isRecorderReady) return;

    await recorderController.record(path: path);
    // startRecordTime = DateTime.now();
  }

  Future stop(
    BuildContext context, {
    // required FlutterSoundRecorder recorder,
    required bool isRecorderReady,
  }) async {
    if (!isRecorderReady) return;

    final audioPath = await recorderController.stop();

    await updateAduioFile(context, audioPath);
  }

  List<ChatMessageModel> messages = [];

  Future<void> fetchAllConversations(int page) async {
    pageType = "";
    messages.clear();
    loading = true;
    notifyListeners();
    if (conversationModel != null) {
      EasyLoading.show();
      String api = Api.getAllMessage;
      Response response = await ApiService()
          .get('$api/${conversationModel!.sId}?pageNumber=$page&pageSize=1000');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        print("all msg------$data");

        if (data['status']) {
          messages = (data['data']['messages'] as List)
              .map(
                (e) => ChatMessageModel.fromJson(e),
              )
              .toList();
          main_app.navigatorKey.currentContext!
              .read<BadgeViewModel>()
              .setLastMessageId(messages.last.sId ?? "");
          main_app.navigatorKey.currentContext!
              .read<BadgeViewModel>()
              .setConversationId(messages.last.conversationId ?? "");

          main_app.navigatorKey.currentContext!
              .read<BadgeViewModel>()
              .updatemessage(context: main_app.navigatorKey.currentContext!);
          notifyListeners();
        } else {
          messages.clear();
        }
        notifyListeners();
      }
      loading = false;
      notifyListeners();

      EasyLoading.dismiss();
    }
  }

  Future<void> sentmessage({required BuildContext context}) async {
    // EasyLoading.show();
    loading = true;
    notifyListeners();

    // Capture the profile ID in a local final variable
    final String? id = pageType == "from profile"
        ? recieverId
        : conversationModel?.participants
            ?.firstWhere(
              (participant) => participant.userId?.sId != LoggedInUser.id,
              orElse: () => Participants(),
            )
            .userId
            ?.sId;

    if (id == null) {
      EasyLoading.dismiss();
      log("Error: Recipient ID is null.");
      return;
    }

    Response response = await ApiService().post(Api.sentMessage, {
      "profileId": id,
      "content": messageType == 'image'
          ? selectedUrl
          : messageType == 'audio'
              ? audioUrl
              : message,
      "messageType": messageType,
    });
    EasyLoading.dismiss();
    loading = false;
    notifyListeners();
    // log(response.data.toString());
    if (response.data != null) {
      Map<String, dynamic> data = response.data;

      print("send mesage-------$data");
      if (data['status']) {
        if (pageType == "from profile") {
          if (id != LoggedInUser.id) {
            fetchAllMessageProfile(id);
          }
          print("Fetch from profile: $pageType, $id");
        } else if (pageType == "") {
          fetchAllConversations(1);
        }
      } else {
        EasyLoading.dismiss();
        messageController.clear();
        EasyLoading.showError(data['message']);
      }
    }

    EasyLoading.dismiss();
    messageController.clear();
    message = null;
    selectedUrl = null;
    audioUrl = null;
    notifyListeners();
  }

  Future<void> updatemessage(
      {required String lastMessageId, required BuildContext context}) async {
    EasyLoading.show();
    print("dataa-------${conversationModel!.sId}----$lastMessageId");

    Response response = await ApiService().post(Api.updateChat, {
      "conversationId": conversationModel!.sId,
      "lastMessageId": lastMessageId,
    });
    log(response.data.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        // if (data.containsKey('message')) {
        fetchAllConversations(1);
        // Navigator.pop(context);
        // EasyLoading.showSuccess(data['message']);
        // }
      }
    }
    EasyLoading.dismiss();
  }

  Future<Uint8List?> convertAudioToUint8List(String? audioPath) async {
    if (audioPath == null) return null;

    try {
      File audioFile = File(audioPath);

      // Check if file exists
      if (!await audioFile.exists()) {
        print('Audio file does not exist');
        return null;
      }

      // Read file as Uint8List
      Uint8List audioBytes = await audioFile.readAsBytes();
      return audioBytes;
    } catch (e) {
      print('Error converting audio to Uint8List: $e');
      return null;
    }
  }

  fetchAllMessageProfile(String profileId) async {
    EasyLoading.show();
    pageType = "from profile";
    messages.clear();
    notifyListeners();
    recieverId = profileId;
    print("profile id------$profileId");

    String api = Api.listProfileMessages;
    Response response =
        await ApiService().get('$api/$profileId?pageNumber=1&pageSize=1000');
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        messages = (data['data']['messages'] as List)
            .map(
              (e) => ChatMessageModel.fromJson(e),
            )
            .toList();
        main_app.navigatorKey.currentContext!
            .read<BadgeViewModel>()
            .setLastMessageId(messages.last.sId ?? "");
        main_app.navigatorKey.currentContext!
            .read<BadgeViewModel>()
            .setConversationId(messages.last.conversationId ?? "");

        main_app.navigatorKey.currentContext!
            .read<BadgeViewModel>()
            .updatemessage(context: main_app.navigatorKey.currentContext!);
        print('mmmss---$messages');
      } else {
        messages.clear();
      }

      messages[0].conversationId;

      loading = false;
      notifyListeners();
      notifyListeners();
    }
    EasyLoading.dismiss();
  }

  fetchAllQueryMessages() async {
    EasyLoading.show();
    pageType = "lets plan";
    messages.clear();

    String api = Api.listQueryMessages;
    Response response =
        await ApiService().get('$api?pageNumber=1&pageSize=1000');
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        messages = (data['data']['messages'] as List)
            .map(
              (e) => ChatMessageModel.fromJson(e),
            )
            .toList();

        print('mmmss---$messages');
        main_app.navigatorKey.currentContext!
            .read<BadgeViewModel>()
            .setLastMessageId(messages.last.sId ?? "");
        main_app.navigatorKey.currentContext!
            .read<BadgeViewModel>()
            .setConversationId(messages.last.conversationId ?? "");

        main_app.navigatorKey.currentContext!
            .read<BadgeViewModel>()
            .updatemessage(context: main_app.navigatorKey.currentContext!);
      } else {
        messages.clear();
      }
      loading = false;
      notifyListeners();
      notifyListeners();
    }
    EasyLoading.dismiss();
  }

  Future<void> sentQuery({required BuildContext context}) async {
    // EasyLoading.show();
    loading = true;
    notifyListeners();

    Response response = await ApiService().post(Api.sentQuery, {
      "content": messageType == 'image'
          ? selectedUrl
          : messageType == 'audio'
              ? audioUrl
              : message,
      "messageType": messageType,
    });

    // log(response.data.toString());
    if (response.data != null) {
      Map<String, dynamic> data = response.data;

      print("send mesage-------$data");
      if (data['status']) {
        print("Success: $pageType");

        fetchAllQueryMessages();
      }
    }

    EasyLoading.dismiss();
    messageController.clear();
    message = null;
    selectedUrl = null;
    audioUrl = null;
    notifyListeners();
  }
}
