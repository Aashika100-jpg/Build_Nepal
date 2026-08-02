import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'emergency_active_screen.dart';

class SOSCountdownScreen extends StatefulWidget {
  const SOSCountdownScreen({super.key});

  @override
  State<SOSCountdownScreen> createState() => _SOSCountdownScreenState();
}

class _SOSCountdownScreenState extends State<SOSCountdownScreen>
    with SingleTickerProviderStateMixin {
  int _timeLeft = 5;
  Timer? _timer;
  bool _isSending = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Setup pulsing animation for urgency
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      HapticFeedback.heavyImpact(); // Vibrate phone on each tick
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _triggerEmergency();
      }
    });
  }

  // --- NEW: SMS Dispatch Engine ---
  Future<void> _sendEmergencySMS(double lat, double lng) async {
    const String emergencyNumber = "+9779863635324";
    final String message =
        "🚨 URGENT SOS! I am in danger and require immediate assistance. "
        "My current GPS location is: Lat: $lat, Lng: $lng. "
        "Please send help!";

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: emergencyNumber,
      queryParameters: <String, String>{'body': message},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        debugPrint("Warning: Device cannot launch SMS app.");
      }
    } catch (e) {
      debugPrint("SMS Error: $e");
    }
  }

  Future<void> _triggerEmergency() async {
    setState(() {
      _isSending = true;
    });

    _pulseController.stop();
    HapticFeedback.vibrate(); // Final strong vibration

    try {
      final userId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_traveler_01';

      // Mock coordinates for Kathmandu
      double mockLat = 27.7172;
      double mockLng = 85.3240;

      // 1. Send Firebase Database Alert
      DocumentReference emergencyRef = await FirebaseFirestore.instance
          .collection('emergencies')
          .add({
            'user_id': userId,
            'latitude': mockLat,
            'longitude': mockLng,
            'status': 'dispatching',
            'timestamp': FieldValue.serverTimestamp(),
          });

      // 2. Trigger the SMS to the Emergency Contact
      await _sendEmergencySMS(mockLat, mockLng);

      if (!mounted) return;

      // 3. Route to the Active Emergency Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EmergencyActiveScreen(emergencyId: emergencyRef.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'System Error: $e',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red[900],
        ),
      );
    }
  }

  void _cancelSOS() {
    _timer?.cancel();
    _pulseController.dispose();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Center(
          child: _isSending
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'ESTABLISHING SECURE CONNECTION\n& DISPATCHING SMS...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'SENDING SOS IN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '$_timeLeft',
                      style: const TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: Text(
                        'Unless canceled, local police will be dispatched and an emergency SMS will be sent to +977 9863635324.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _cancelSOS,
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red[900],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            _timer?.cancel();
                            _triggerEmergency();
                          },
                          child: const Text(
                            'SEND NOW',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
  
  Future<void> launchUrl(Uri smsUri) async {
    final bool launched = await url_launcher.launchUrl(
      smsUri,
      mode: url_launcher.LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Could not launch SMS app.');
    }
  }

  Future<bool> canLaunchUrl(Uri smsUri) async {
    return url_launcher.canLaunchUrl(smsUri);
  }
}
