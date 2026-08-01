import 'package:flutter/material.dart';

class CoTravelerScreen extends StatefulWidget {
  const CoTravelerScreen({super.key});

  @override
  State<CoTravelerScreen> createState() => _CoTravelerScreenState();
}

class _CoTravelerScreenState extends State<CoTravelerScreen> {
  // State control
  bool _inChatMode = false;
  Map<String, dynamic>? _activeBuddy;
  final TextEditingController _chatController = TextEditingController();

  // Dynamic chat messages for the active session
  List<Map<String, dynamic>> _chatMessages = [];

  // Rich, Production-Ready Mock Data
  final List<Map<String, dynamic>> _invitations = [
    {
      "name": "Emma Watson",
      "nationality": "UK 🇬🇧",
      "destination": "Pokhara / Lakeside",
      "status": "online",
      "match": 98,
      "avatar": Icons.face_3,
      "color": Colors.purple,
      "verified": true,
      "interests": ["Trekking", "Photography", "Cafes"],
    },
    {
      "name": "Carlos Ruiz",
      "nationality": "Spain 🇪🇸",
      "destination": "Bhaktapur Durbar Square",
      "status": "away",
      "match": 85,
      "avatar": Icons.face,
      "color": Colors.orange,
      "verified": true,
      "interests": ["History", "Architecture", "Local Food"],
    },
    {
      "name": "Li Wei",
      "nationality": "China 🇨🇳",
      "destination": "Everest Base Camp",
      "status": "offline",
      "match": 72,
      "avatar": Icons.face_4,
      "color": Colors.teal,
      "verified": false,
      "interests": ["Hiking", "Nature", "Budget Travel"],
    },
  ];

  void _acceptInvite(Map<String, dynamic> buddy) {
    setState(() {