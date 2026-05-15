import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/chat_message_model.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/audio_widget.dart';

class OtherUserChatWidget extends StatelessWidget {
  final ChatMessageModel message;
  const OtherUserChatWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    print(message.messageType);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.messageType == "text" || message.messageType == 'text')
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.all(10.0),
                constraints: BoxConstraints(
                  minWidth: 50,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                 decoration: BoxDecoration(
                    color: PColors.black2,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child:  textWidget(
                    text: message.content,
                    color: PColors.white,
                    fontsize: 12,
                    fontweight: FontWeight.w600),
              ),
            ),
              // Container(
              //   alignment: Alignment.centerRight,
              //     constraints: BoxConstraints(
              //        minWidth: 50,
              //       maxWidth: 200), // 
              //   width: size.width / 1.4,
              //   padding: const EdgeInsets.only(
              //       left: 10, right: 10, top: 10, bottom: 10),
              //   decoration: BoxDecoration(
              //       color: PColors.black2,
              //       borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(20),
              //         topLeft: Radius.circular(20),
              //         topRight: Radius.circular(20),
              //       )),
              //   child: textWidget(
              //       text: message.content,
              //       color: PColors.white,
              //       fontsize: 12,
              //       fontweight: FontWeight.w600),
              // ),
            if (message.messageType == "image" ||
                message.messageType == 'image')
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: PColors.imageBorderColor,
                    width: 3,
                  ),
                ),
                height: size.height * 0.25,
                width: size.width * 0.34,

                 child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:message.content==null || message.content!.isEmpty?const CircularProgressIndicator(): Image.network(message.content!,fit: BoxFit.fill,)),
              ),
            if (message.messageType == "audio" ||
                message.messageType == 'audio')
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: PColors.imageBorderColor,
                    width: 3,
                  ),
                ),
                height: size.height * 0.3,
                child: AudioWidget(audioUrl: message.content!),
              ),
            textWidget(
            text:    DateFormat('hh:mm a')
                    .format(
                        DateTime.parse(message.createdAt.toString()).toLocal())
                    .toString(),
                fontsize: 10,
                color: PColors.whiteOff.withOpacity(0.4))
          ],
        ),
      ],
    );
  }
}
