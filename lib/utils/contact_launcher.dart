import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

const String _defaultCountryCode = '91';

/// Normalises a profile's mobile number into a full international number
/// (digits only, no leading '+') so it can be used in tel:/wa.me links.
///
/// Numbers that already carry a country code are left alone; bare local
/// numbers get [countryCode] (or the default) prefixed.
String internationalNumber(String? mobileNumber, String? countryCode) {
  String number = (mobileNumber ?? '').replaceAll(RegExp(r'\D'), '');
  if (number.isEmpty) return '';

  final String code =
      (countryCode ?? '').replaceAll(RegExp(r'\D'), '');

  // Strip the national trunk prefix people often type, e.g. 09876543210
  if (number.length > 10) number = number.replaceFirst(RegExp(r'^0+'), '');

  // 10 digits or fewer means no country code was typed in
  if (number.length <= 10) {
    return '${code.isEmpty ? _defaultCountryCode : code}$number';
  }

  return number;
}

/// Opens the dialer for [mobileNumber].
/// Shows a message instead when the profile has no number configured.
Future<void> launchPhoneCall(String? mobileNumber, String? countryCode) async {
  final String number = internationalNumber(mobileNumber, countryCode);
  if (number.isEmpty) {
    EasyLoading.showInfo('This user has not configured a mobile number');
    return;
  }

  await _launch(Uri.parse('tel:+$number'), 'Could not start the call');
}

/// Opens a WhatsApp chat with [mobileNumber].
/// Shows a message instead when the profile has no number configured.
Future<void> launchWhatsAppChat(
    String? mobileNumber, String? countryCode,
    {String? message = 'Hi , I found your profile in Biz Zinda'}) async {
  final String number = internationalNumber(mobileNumber, countryCode);
  if (number.isEmpty) {
    EasyLoading.showInfo('This user has not configured a mobile number');
    return;
  }

  final String encodedMessage =
      Uri.encodeComponent(message ?? 'Hi , I found your profile in Biz Zinda');
  await _launch(
      Uri.parse('https://wa.me/$number?text=$encodedMessage'),
      'Could not open WhatsApp');
}

Future<void> _launch(Uri url, String errorMessage) async {
  try {
    final bool launched =
        await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!launched) EasyLoading.showError(errorMessage);
  } catch (e) {
    debugPrint('[contact_launcher] failed to launch $url: $e');
    EasyLoading.showError(errorMessage);
  }
}
