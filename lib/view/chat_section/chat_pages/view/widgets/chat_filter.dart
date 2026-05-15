import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatFilterUi extends StatelessWidget {
  const ChatFilterUi({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Selector<ChatViewModel, String>(
      selector: (p0, p1) => p1.allUnreadView,
      builder: (context, value, child) => Row(
        children: [
          singleWidget(
              size: size,
              str: "All",
              fun: () {
                context
                    .read<ChatViewModel>()
                    .updateAllAndUnread(ChatViewStatus.all);
              },
              selected: value == ChatViewStatus.all),
          singleWidget(
              size: size,
              str: "Unread",
              fun: () {
                context
                    .read<ChatViewModel>()
                    .updateAllAndUnread(ChatViewStatus.unread);
              },
              selected: value == ChatViewStatus.unread),
        ],
      ),
    );
  }

  Widget singleWidget(
      {required Size size,
      required String str,
      required Function()? fun,
      required bool selected}) {
    return GestureDetector(
      onTap: fun,
      child: SizedBox(
          width: size.width / 4,
          child: Column(
            children: [
              textWidget(
                  text: str,
                  fontsize: 13,
                  color: selected
                      ? Color(0xFF8A4FFF)
                      : Colors.grey,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: selected
                          ? [PColors.grad1, PColors.grad2]
                          : [PColors.black, PColors.black],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: const [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                // width: size.width / 4,
                height: 2,
              )
            ],
          )),
    );
  }
}
