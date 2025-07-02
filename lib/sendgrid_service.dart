import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendOtpToEmail(String email, String otp) async {
  const String sendGridApiKey = "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"; // Replace with your key
  const String sendGridUrl = "https://api.sendgrid.com/v3/mail/send";

  final Map<String, dynamic> emailData = {
    "personalizations": [
      {
        "to": [
          {"email": email}
        ],
        "subject": "Your OTP Code"
      }
    ],
    "from": {"email": "malaika.kaleem4@gmail.com"}, // Must match your SendGrid verified sender
    "content": [
      {
        "type": "text/plain",
        "value": "Your OTP code is: $otp. It is valid for 5 minutes."
      }
    ]
  };

  final response = await http.post(
    Uri.parse(sendGridUrl),
    headers: {
      "Authorization": "Bearer $sendGridApiKey",
      "Content-Type": "application/json"
    },
    body: jsonEncode(emailData),
  );

  if (response.statusCode == 202) {
    print("✅ OTP Sent to $email: $otp");
  } else {
    print("❌ Failed to send OTP: ${response.body}");
  }
}
