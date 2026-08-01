import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class VrTourScreen extends StatefulWidget {
  final String imagePath;
  final String title;

  const VrTourScreen({super.key, required this.imagePath, required this.title});

  @override
  State<VrTourScreen> createState() => _VrTourScreenState();
}

class _VrTourScreenState extends State<VrTourScreen> {
  bool _motionTrackingActive = true; // Gyroscope tracking toggler
  bool _showInstructionText = true;

  @override
  void initState() {
    super.initState();
    // Automatically hide instructions window after a few seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showInstructionText = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.4),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Dynamic Motion Controller Switch Button
          IconButton(
            icon: Icon(
              _motionTrackingActive
                  ? Icons.screen_rotation_rounded
                  : Icons.touch_app_rounded,
              color: _motionTrackingActive ? Colors.tealAccent : Colors.white,
            ),
            tooltip: _motionTrackingActive
                ? "Disable Gyroscope"
                : "Enable Gyroscope",
            onPressed: () {
              setState(() => _motionTrackingActive = !_motionTrackingActive);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _motionTrackingActive
                        ? "🔄 Gyroscope active! Move your phone to look around."
                        : "👆 Touch control active! Drag with fingers to look around.",
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),