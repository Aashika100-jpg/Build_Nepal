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
                        const Text(
                          'Your Secure Nepal Travel Companion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 60),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _startPassportScan,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo[600]!,
                                    Colors.indigo[800]!,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.document_scanner_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Scan Passport to Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'e-Passport & MRZ Support Active',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'DEVELOPER / DEMO MODE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey[400],
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedProfile,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.indigo[400],
                              ),
                              dropdownColor: Colors.white,
                              items: _profiles.map((String profile) {
                                return DropdownMenuItem<String>(
                                  value: profile,
                                  child: Text(
                                    profile,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedProfile = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _handleDemoLogin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.indigo[700],
                              side: BorderSide(
                                color: Colors.indigo[200]!,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.indigo[700],
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Access Demo Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PassportScannerDialog extends StatefulWidget {
  const PassportScannerDialog({super.key});

  @override
  State<PassportScannerDialog> createState() => _PassportScannerDialogState();
}

class _PassportScannerDialogState extends State<PassportScannerDialog>
    with SingleTickerProviderStateMixin {
  String _scanStatus = "Align passport within frame...";
  double _progress = 0.0;
  late AnimationController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _runScanSequence();
  }

  Future<void> _runScanSequence() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _scanStatus = "Scanning MRZ and biometric data...";
    });

    for (int step = 1; step <= 5; step++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      setState(() {
        _progress = step / 5;
        _scanStatus = "Analyzing passport page ${step + 1}...";
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    setState(() {
      _scanStatus = "Passport verified. Redirecting...";
      _progress = 1.0;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Passport Scanner',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _scannerController,
              builder: (context, child) {
                return Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF7C3AED),
                      width: 2,
                    ),
                    color: Colors.indigo[50],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            20 * (1 - _scannerController.value) * 2,
                          ),
                          child: Container(
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.indigo[400]!,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _scanStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
