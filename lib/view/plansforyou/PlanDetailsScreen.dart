import 'package:flutter/material.dart';
import 'package:biz_zinda/view/plansforyou/plansforyou_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetailsScreen extends StatelessWidget {
  final FreelancerMessageModel? message;   // optional
  final String taskId;

  const MessageDetailsScreen({
    super.key,
    required this.taskId,
    this.message,
  });

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔹 TOP IMAGE
          if (message?.imageUrl != null && message!.imageUrl!.isNotEmpty)
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                message!.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF8A4FFF),
                  );
                },
              ),
            )
          else
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9C6BFF),
                    Color(0xFF6A1BFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

          /// 🔹 Back Button
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// 🔹 WHITE BOTTOM CONTAINER
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    message?.title ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A4FFF),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    formatDate(message?.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    message?.description ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final whatsappUrl = message?.whatsappLink;

                        if (whatsappUrl != null && whatsappUrl.isNotEmpty) {
                          final uri = Uri.parse(whatsappUrl);

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Could not open WhatsApp"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No WhatsApp link provided"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Pick This Plan",
                        style: TextStyle(color: Color(0xFF8A4FFF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}