import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/chat_textfeild_sectopn.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChatBottomBarUi extends StatelessWidget {
  const ChatBottomBarUi({super.key});

  @override
  Widget build(BuildContext context) {
    ChatDetailsViewModel chatDetailsViewModel =
        context.watch<ChatDetailsViewModel>();
    return Padding(
      padding: const EdgeInsets.all(0),
      // EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(

        height: 50,
        margin: const EdgeInsets.only(bottom: 14),
        width: MediaQuery.of(context).size.width,

        // color:PColors.seed2,
        child: Row(
          children: [
            const SizedBox(width: 10),
            if (!chatDetailsViewModel.isrecord)
              Expanded(
                child: ChatBottomTextfeildSectopn(),
              ),
            if (chatDetailsViewModel.isrecord)
              AudioWaveforms(
                enableGesture: true,
                size: Size(MediaQuery.of(context).size.width - 120, 50),
                recorderController: chatDetailsViewModel.recorderController,
                waveStyle: WaveStyle(
                  waveColor: PColors.black,
                  waveThickness: 8.0,
                  waveCap: StrokeCap.round,
                  spacing: 24.0,
                  extendWaveform: true,
                  showMiddleLine: false,
                  durationTextPadding: 0,
                  labelSpacing: 0,
                ),
                margin: const EdgeInsets.only(left: 25),
              ),
            const SizedBox(width: 25),
            if (chatDetailsViewModel.message != null &&
                chatDetailsViewModel.message!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  if (chatDetailsViewModel.message != null &&
                      chatDetailsViewModel.message!.isNotEmpty) {
                    print("jfhjsdfh----${chatDetailsViewModel.pageType}");
                    if (chatDetailsViewModel.pageType == "lets plan") {
                      chatDetailsViewModel.sentQuery(context: context);
                    } else {
                      chatDetailsViewModel.sentmessage(context: context);
                    }
                  }
                },
                child: const Icon(Icons.send_outlined,color: Color(0xFF8A4FFF),),
              ),
            if (chatDetailsViewModel.pageType == "lets plan")
              Container()
            else if (chatDetailsViewModel.messageController.text.isNotEmpty)
              Container()
            else if (!chatDetailsViewModel.isrecord)
              // Send Button
              GestureDetector(
                onTap: () async {
                  chatDetailsViewModel.getDir();
                  final status = await Permission.microphone.request();
                  // ignore: use_build_context_synchronously

                  final hasPermission = await chatDetailsViewModel
                      .recorderController
                      .checkPermission();

                  if (status != PermissionStatus.granted ||
                      hasPermission == false) {
                    throw "Microphone Permission not Granted";
                  }
                  chatDetailsViewModel.updateISRecord(true);
                  chatDetailsViewModel.record(context, isRecorderReady: true);
                },
                child: SvgPicture.asset(
                  PSvgs.audio,
                  height: 24,
                  color: Color(0xFF8A4FFF),
                ),
              ),
            if (chatDetailsViewModel.isrecord)
              GestureDetector(
                onTap: () {
                  chatDetailsViewModel.updateISRecord(false);
                  chatDetailsViewModel.stop(context, isRecorderReady: true);
                },
                child: const Icon(Icons.send_outlined,color: Color(0xFF8A4FFF),),
              ),
            const SizedBox(width: 20)
          ],
        ),
      ),
    );
  }
}
