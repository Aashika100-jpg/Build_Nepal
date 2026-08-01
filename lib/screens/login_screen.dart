import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../main.dart';
import 'admin_screen.dart';

String currentUserLocation = "Kathmandu";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _selectedProfile = 'Tourist 1: Alex (Kathmandu)';

  final List<String> _profiles = [
    'Tourist 1: Alex (Kathmandu)',
    'Tourist 2: Emma (Pokhara)',
    'Tourist 3: Li (Everest Region)',
    'Security Admin (Control Center)',
  ];

  void _handleDemoLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    if (_selectedProfile.contains('Admin')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else {
      if (_selectedProfile.contains('Kathmandu'))
        currentUserLocation = "Kathmandu";
      if (_selectedProfile.contains('Pokhara')) currentUserLocation = "Pokhara";
      if (_selectedProfile.contains('Everest'))
        currentUserLocation = "Everest Region";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  void _startPassportScan() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const PassportScannerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.travel_explore_rounded,
                            size: 64,
                            color: Colors.indigo[700],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Yatra Sathi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
