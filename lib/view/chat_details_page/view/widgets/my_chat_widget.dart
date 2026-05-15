import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/chat_message_model.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/audio_widget.dart';

class MyChatWidget extends StatelessWidget {
  final ChatMessageModel message;
  const MyChatWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 10,
            ),
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
                    color: PColors.white,
                     border: Border.all(
                       color: Color(0xFF8A4FFF), // ✅ Purple border
                       width: 2, // border thickness
                     ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),

                    )
                 ),
                child:  textWidget(
                    text: message.content,
                    color: Color(0xFF8A4FFF),
                    fontsize: 12,
                    fontweight: FontWeight.w600),
              ),
            ),
              // Container(
              //     constraints: BoxConstraints(
              //       maxWidth: 200), // 
              //   alignment: Alignment.centerLeft,
              //   // width: size.width / 1.4,
              //   padding: const EdgeInsets.only(
              //       left: 10, right: 10, top: 10, bottom: 10),
              //   decoration: BoxDecoration(
              //       color: PColors.white,
              //       borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(20),
              //         topLeft: Radius.circular(20),
              //         topRight: Radius.circular(20),
              //       )),
              //   child: textWidget(
              //       text: message.content!,
              //       color: PColors.black,
              //       fontsize: 12,
              //       fontweight: FontWeight.w600),
              // ),
            if (message.messageType == "image" ||
                message.messageType == 'image')
              Container(
                
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
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
                alignment: Alignment.centerLeft,
                // width: size.width / 1.4,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: PColors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: AudioWidget(audioUrl: message.content!),
              ),
            textWidget(
                text: DateFormat('hh:mm a')
                    .format(
                        DateTime.parse(message.createdAt.toString()).toLocal())
                    .toString(),
                // text: formatDateFromString(
                //     message.createdAt ?? '', 'yyyy-MM-ddThh:mm:ss', 'HH:mm'),
                fontsize: 10,
                color: Colors.purple.shade200),
          ],
        ),
      ],
    );
  }
}
