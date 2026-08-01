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
      body: Stack(
        children: [
          // 1. The Immersive Spatial Rendering Canvas
          PanoramaViewer(
            // Conditionally binds directly to physical phone alignment
            sensorControl: _motionTrackingActive
                ? SensorControl.orientation
                : SensorControl.none,
            child: Image.asset(
              widget.imagePath,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    "Panorama Asset Pending Loaded...",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              },
            ),
          ),

          // 2. Translucent User Instruction Overlay
          if (_showInstructionText)
            Positioned(
              bottom: 60,
              left: 30,
              right: 30,
              child: AnimatedOpacity(
                opacity: _showInstructionText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _motionTrackingActive
                            ? Icons.screen_rotation_rounded
                            : Icons.touch_app_rounded,
                        color: Colors.tealAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _motionTrackingActive
                              ? "Move and rotate your device to explore the horizon live!"
                              : "Swipe across the interface screen canvas space to explore.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
