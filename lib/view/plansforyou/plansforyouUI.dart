// freelancer_messages_screen.dart
import 'package:flutter/material.dart';
import 'package:biz_zinda/view/plansforyou/plansforyou_model.dart';
import '../../services/Freelancer_message_service.dart';
import 'PlanDetailsScreen.dart';

class FreelancerMessagesScreen extends StatefulWidget {
  const FreelancerMessagesScreen({super.key});

  @override
  State<FreelancerMessagesScreen> createState() =>
      _FreelancerMessagesScreenState();
}
class _FreelancerMessagesScreenState extends State<FreelancerMessagesScreen> {
  List<FreelancerMessageModel> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    setState(() => isLoading = true);

    try {
      final result =
      await fetchFreelancerMessages(pageNumber: 1, pageSize: 10);

      print("Fetched Messages: ${result.length}");
      for (var m in result) {
        print("Title: ${m.title}, Description: ${m.description}");
      }

      setState(() {
        messages = result;
      });
    } catch (e) {
      print("Error loading messages: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load messages")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }



  // 🔥 ADD THIS HERE
  Future<void> deleteMessage(String id) async {
    setState(() {
      messages.removeWhere((element) => element.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Message Removed from Feed",style: TextStyle(color: Color(0xFF8A4FFF),),)),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans for You'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8A4FFF),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : messages.isEmpty
          ? const Center(
        child: Text(
          'No Messages Available',
          style: TextStyle(fontSize: 16, color: Colors.purple),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF3E9FF),
                  Color(0xFFE6D6FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.campaign,
                              color: Color(0xFF8A4FFF),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                msg.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6A35D4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteMessage(msg.id);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// DATE
                  Text(
                    formatDate(msg.createdAt),
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// DESCRIPTION
                  Text(
                    msg.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// IMAGE
                  if (msg.imageUrl != null && msg.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        msg.imageUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 15),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageDetailsScreen(
                              taskId: msg.taskId ?? '',
                              message: msg,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9C8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Click Here",
                        style: TextStyle(color: Color(0xFF6A35D4),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

