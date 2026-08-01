import 'package:flutter/material.dart';
import '../data/user_model.dart';
import 'sos_countdown_screen.dart'; // IMPORTANT: Import the new screen

class PassportScannerScreen extends StatelessWidget {
  const PassportScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode for scanning
      appBar: AppBar(
        title: const Text(
          'Verify Identity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // --- ADD THIS FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SOSCountdownScreen()),
          );
        },
        backgroundColor: Colors.red[800],
        icon: const Icon(Icons.emergency, color: Colors.white),
        label: const Text(
          'SOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      // ---------------------------------------
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for the Camera Preview
          Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Camera Feed goes here\n(Align Passport MRZ)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              // Simulate scanning and retrieving user data
              String scannedPassportNumber = '1234567'; // Example
              User? user = usersDatabase[scannedPassportNumber];

              if (user != null) {
                _showUserDetails(context, user);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Passport not found in database."),
                  ),
                );
              }
            },
            icon: const Icon(Icons.document_scanner),
            label: const Text("Scan Passport"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Passport Number: ${user.passportNumber}'),
            Text('Location: ${user.location}'),
            Text(
              'Visa Valid Until: ${user.visaValidUntil.toLocal()}'.split(
                ' ',
              )[0],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
