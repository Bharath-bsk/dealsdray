import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_screen.dart';
import 'registration_screen.dart'; // Import the Registration screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileNumberController = TextEditingController();

  Future<void> _sendCode() async {
    final url = 'http://devapiv4.dealsdray.com/api/v2/user/otp';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'mobileNumber': _mobileNumberController.text,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Decoded response body: ${json.encode(responseBody)}'); // Pretty-print the decoded response

      // Check if the mobile number exists and redirect accordingly
      if (responseBody['status'] == 'mobile_number_not_present' || responseBody['error'] == 'Mobile number not found') {
        print('Mobile number not found, redirecting to registration page');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegistrationScreen(
              mobileNumber: _mobileNumberController.text,
            ),
          ),
        );
      } else {
        final userId = responseBody['data']?['userId'] ?? '';
        final deviceId = responseBody['data']?['deviceId'] ?? '';

        if (userId.isNotEmpty && deviceId.isNotEmpty) {
          print('UserId and DeviceId found, redirecting to OTP verification page');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                userId: userId,
                deviceId: deviceId,
              ),
            ),
          );
        } else {
          print('Failed to get userId or deviceId from the response.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to get userId or deviceId from the response.'),
          ));
        }
      }
    } else {
      print('Failed to send code. Status Code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send code.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCode,
              child: Text('Send Code'),
            ),
          ],
        ),
      ),
    );
  }
}
