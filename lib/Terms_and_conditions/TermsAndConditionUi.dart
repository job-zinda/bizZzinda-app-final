import 'package:flutter/material.dart';

class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  State<TermsConditionsPage> createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '''
📜 JobZinda – Promoter & Freelancer Terms & Conditions

1. Role Classification

Promoter:
- Independent referral partner
- Not an employee of JobZinda
- Earns through referrals and onboarding

Freelancer:
- Independent service provider
- Not an employee of JobZinda
- Responsible for own service delivery

2. No Employment Relationship
Registration does not create employer–employee relationship.
All earnings are performance-based.

3. Earnings & Incentives
Promoters earn through referrals.
Freelancers earn by providing services.

4. Wallet & Payout
Minimum withdrawal: ₹200.
JobZinda may hold payouts for verification or disputes.

5. PAN, TDS & Taxation
Promoters earning below ₹30,000/year:
No TDS. PAN not mandatory.

If PAN not provided and TDS applicable:
20% TDS may be deducted.

Freelancers are responsible for tax filing and GST compliance.

6. Prohibited Activities
Fake referrals, fraud, spam, or illegal activities are strictly prohibited.

7. Governing Law
Governed by laws of India.

Acceptance:
By registering, you agree to these Terms & Conditions.
                ''',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),

          // Checkbox Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "I have read and agree to the Terms & Conditions",
                    style: TextStyle(fontSize: 13),
                  ),
                )
              ],
            ),
          ),

          // Agree Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade50, // Button background
                  foregroundColor: Colors.purple,  // Text color
                ),
                onPressed: isChecked
                    ? () {
                  Navigator.pop(context, true);
                }
                    : null,
                child: const Text("I Agree"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}