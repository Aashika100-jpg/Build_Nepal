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
      _activeBuddy = buddy;
      _inChatMode = true;
      // Pre-load mock conversation context
      _chatMessages = [
        {
          "text":
              "Hi! I saw we are both heading to ${buddy["destination"]}. Want to share a ride?",
          "isMe": false,
          "time": "10:41 AM",
        },
        {
          "text":
              "Hello! Yes, that would be great. It will save us money and be much safer.",
          "isMe": true,
          "time": "10:42 AM",
        },
        {
          "text":
              "Perfect! My Yatra Sathi app says the fair price should be around 800 NPR total.",
          "isMe": false,
          "time": "10:43 AM",
        },
      ];
    });
  }

  void _leaveChat() {
    setState(() {
      _inChatMode = false;
      _activeBuddy = null;
    });
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      _chatMessages.add({
        "text": _chatController.text.trim(),
        "isMe": true,
        "time": _getCurrentTime(),
      });
      _chatController.clear();
    });

    // Auto-scroll logic would go here in a real app using a ScrollController
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _inChatMode ? 'Secure Chat' : 'Find Travel Buddies',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: _inChatMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: _leaveChat,
              )
            : null,
