import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the Home screen

class OTPVerificationScreen extends StatelessWidget {
  final String userId;
  final String deviceId;

  OTPVerificationScreen({required this.userId, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final _otpController = TextEditingController();

    void _navigateToHome() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(), // Navigate to the home page
        ),
      );
    }

    Future<void> _resendOTP() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('OTP resent successfully!'),
      ));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToHome,
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resendOTP,
              child: Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
