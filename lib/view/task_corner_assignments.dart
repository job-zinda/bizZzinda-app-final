import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/logged_in_user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'task_corner_assignments_widgets.dart';
import 'task_corner_admin_doc_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../utils/api_url.dart';

class TaskCornerAssignmentsPage extends StatefulWidget {
  const TaskCornerAssignmentsPage({Key? key}) : super(key: key);

  @override
  State<TaskCornerAssignmentsPage> createState() =>
      _TaskCornerAssignmentsPageState();
}

class _TaskCornerAssignmentsPageState extends State<TaskCornerAssignmentsPage> {
  List<dynamic> assignments = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final userId = LoggedInUser.id;
      final url = Uri.parse(
          '${AppUrl.baseurl}/api/v1/assigned-task/user?userId=$userId');
      final headers = await Api.getAuthorizationHeader();
      final resp = await http.get(url, headers: headers);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        setState(() {
          assignments = data;
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to fetch assignments.';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _uploadEvidence(BuildContext context, String assignedTaskId) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    final uri = Uri.parse('${AppUrl.baseurl}/api/v1/assigned-task/$assignedTaskId/submit-evidence');
    final headers = await Api.getAuthorizationHeader();
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('evidence', file.path));
    final resp = await req.send();
    if (resp.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evidence uploaded successfully')));
      fetchAssignments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload evidence')));
    }
  }

  Future<void> _openWhatsappGroup() async {
    final uri = Uri.parse('https://chat.whatsapp.com/Kbd0WgKv5r9B2C4fpKpfyS?mode=ems_copy_t');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final joinButton = Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8A4FFF), // purple button
          ),
          onPressed: _openWhatsappGroup,
          icon: const Icon(Icons.chat,color: Colors.white,),
          label: const Text('Join our WhatsApp group',style: TextStyle(color: Colors.white),),
        ),
      ),
    );

    Widget content;
    if (loading) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      final inner = error != null
          ? Center(child: Text(error!))
          : assignments.isEmpty
          ? const Center(child: Text('No assigned tasks found.',style: TextStyle(color:Color(0xFF8A4FFF),),))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final a = assignments[i];
          return Card(
            color: Colors.deepPurple.shade50, // light purple background
            shadowColor: Color(0xFF8A4FFF), // purple shadow
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.deepPurple.shade200, width: 1)),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (a['task']?['mediaUrl'] != null &&
                      a['task']['mediaUrl'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AssignmentMediaWidget(
                        url: a['task']['mediaUrl'],
                        height: 180,
                        width: double.infinity,
                      ),
                    ),
                  Text(
                    a['task']?['title'] ?? 'Untitled Task',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF8A4FFF),),
                  ),
                  if (a['task']?['adminDocumentUrl'] != null &&
                      a['task']['adminDocumentUrl'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AdminDocWidget(
                        url: a['task']['adminDocumentUrl'],
                        height: 180,
                        width: double.infinity,
                        caption: a['task']?['caption'],
                        allowDownload: (a['task']?['allowDownload'] is bool)
                            ? a['task']['allowDownload'] as bool
                            : (a['task']?['allowDownload']?.toString().toLowerCase() ==
                            'true'),
                        allowShare: (a['task']?['allowShare'] is bool)
                            ? a['task']['allowShare'] as bool
                            : (a['task']?['allowShare']?.toString().toLowerCase() ==
                            'true'),
                      ),
                    ),
                  if (a['task']?['taskLink'] != null &&
                      a['task']['taskLink'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: TextEditingController(text: a['task']['taskLink']),
                              readOnly: true,
                              enableInteractiveSelection: true,
                              onTap: () async {
                                final link = a['task']['taskLink'].toString();
                                final uri = Uri.tryParse(link);
                                if (uri != null) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              style: const TextStyle(
                                color: Color(0xFF8A4FFF),
                                decoration: TextDecoration.underline,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Task Link',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20, color: Color(0xFF8A4FFF),),
                            tooltip: 'Copy Link',
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: a['task']['taskLink']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Link copied to clipboard')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  if (a['task']?['commissionAmount'] != null &&
                      (a['task']['commissionAmount'] as num) > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Earnings: ₹${a['task']['commissionAmount']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.green),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a['task']?['description'] ?? ''),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${a['status']}',
                    style: const TextStyle(
                      color:Color(0xFF8A4FFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (a['reviewComment'] != null &&
                      a['reviewComment'].toString().isNotEmpty)
                    Text(
                      'Review: ${a['reviewComment']}',
                      style: const TextStyle(
                        color: Color(0xFF8A4FFF),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (a['evidenceUrl'] != null && a['evidenceUrl'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AssignmentMediaWidget(
                          url: a['evidenceUrl'], height: 200, width: double.infinity),
                    ),
                  const SizedBox(height: 12),
                  if (a['status'] == 'assigned' || a['status'] == 'rejected')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8A4FFF),
                        ),
                        icon: const Icon(Icons.upload_file,color: Colors.white,),
                        label: const Text('Upload Evidence',style: TextStyle(color: Colors.white),),
                        onPressed: () => _uploadEvidence(context, a['_id']),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          joinButton,
          const SizedBox(height: 12),
          Expanded(child: inner),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task Assignments'),
        backgroundColor: Color(0xFF8A4FFF), // AppBar purple
      ),
      body: content,
    );
  }
}