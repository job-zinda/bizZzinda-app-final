import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/model/course_purchase_model.dart';
import 'package:biz_zinda/view_model/course_purchase_view_model.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'receipt_share_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CoursePurchaseUi extends StatefulWidget {
  const CoursePurchaseUi({super.key});

  @override
  State<CoursePurchaseUi> createState() => _CoursePurchaseUiState();
}

class _CoursePurchaseUiState extends State<CoursePurchaseUi> {
  final TextEditingController _referralController = TextEditingController();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursePurchaseViewModel>().fetchCoursePurchase();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    context.read<CoursePurchaseViewModel>().verifyCoursePayment(
      paymentId: response.paymentId!,
      orderId: response.orderId!,
      razorpaySignature: response.signature!,
      razorpay: _razorpay,
      context: context,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Failed!')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PColors.white,
      child: Consumer<CoursePurchaseViewModel>(
        builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final purchase = vm.coursePurchase;
        if (purchase != null && purchase.paymentStatus == 'success') {
          // Show receipt
          return _buildReceipt(purchase);
        }
        // Show course details and purchase button
        return _buildCourseDetails(vm);
      }),
    );
  }

  Widget _buildCourseDetails(CoursePurchaseViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.school, size: 60, color: PColors.yellow),
          const SizedBox(height: 20),
          Text(
            'Be a Zinda Promoter and Earn More!',
            style: const TextStyle(color:Color(0xFFFB8C00),fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Purchase this course to unlock promoter features and boost your earnings on Job Zinda.',
            textAlign: TextAlign.center,style: TextStyle(color: Color(0xFFFB8C00),),
          ),
          const SizedBox(height: 30),
          Text(
            'Price: ₹300',
            style: TextStyle(fontSize: 20, color: PColors.yellow, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _referralController,
            decoration: const InputDecoration(
              labelText: 'Referral Code (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 40),
          CustomElavatedTextButton(
            text: 'Purchase Course',
            fontSize: 16,
            borderRadius: 12,
            height: 48,
            bgcolor: PColors.yellow,
            textColor: Colors.black,
            onPressed: () {
              vm.createCourseOrder(
                razorpay: _razorpay,
                context: context,
                referralCode: _referralController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatReceiptMessage(CoursePurchaseModel purchase) {
    return '''Hi Zinda, here is my receipt:\n\n
      *Course Purchase Receipt*\n
      Course: Zinda Promoter\n
      Amount Paid: ₹300\n
      Payment ID: ${purchase.paymentId ?? ''}\n
      Status: ${purchase.paymentStatus ?? ''}\n
      Thank you!''';  
  }

  Widget _buildReceipt(CoursePurchaseModel purchase) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Card(
          elevation: 4,
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long, size: 50, color: const Color(0xFFFFD700)),
                const SizedBox(height: 10),
                const Text(
                  'Course Purchase Receipt',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Divider(height: 30, thickness: 1),
                _receiptRow('Course', 'Zinda Promoter'),
                _receiptRow('Amount Paid', '₹300'),
                _receiptRow('Payment ID', purchase.paymentId ?? ''),
                _receiptRow('Status', purchase.paymentStatus ?? ''),
                const Divider(height: 30, thickness: 1),
                Text(
                  'Thank you for your purchase!',
                  style: TextStyle(color: PColors.grad2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                    label: const Text('Share to WhatsApp'),
                    onPressed: () async {
                      await shareReceiptOnWhatsApp(purchase, phone: '917592998150');
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share the receipt to enroll to the course',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
