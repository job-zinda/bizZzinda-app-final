import 'package:url_launcher/url_launcher.dart';
import '../../../../../model/course_purchase_model.dart';

Future<void> shareReceiptOnWhatsApp(CoursePurchaseModel purchase, {required String phone}) async {
  final message = _formatReceiptMessage(purchase);
  final url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

String _formatReceiptMessage(CoursePurchaseModel purchase) {
  return '''Hi Zinda, here is my receipt:\n\n*Course Purchase Receipt*\nCourse: Zinda Promoter\nAmount Paid: ₹200\nPayment ID: ${purchase.paymentId ?? ''}\nStatus: ${purchase.paymentStatus ?? ''}\nThank you for your purchase!''';
}
