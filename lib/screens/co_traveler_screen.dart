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
      ),
      // Smooth animated transition between the list and chat
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _inChatMode ? _buildChatInterface() : _buildMatchList(),
      ),
    );
  }

  // ==========================================
  // VIEW 1: THE PREMIUM MATCH LIST
  // ==========================================
  Widget _buildMatchList() {
    return ListView.builder(
      key: const ValueKey("MatchList"),
      padding: const EdgeInsets.all(16),
      itemCount: _invitations.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "People heading your way",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Verified travelers looking to split costs & share experiences.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          );
        }

        final buddy = _invitations[index - 1];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Avatar, Name, Trust Badge, Match %
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: buddy["color"].withOpacity(0.15),
                      child: Icon(
                        buddy["avatar"],
                        size: 35,
                        color: buddy["color"],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                buddy["name"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (buddy["verified"])
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            buddy["nationality"],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Match Percentage Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[400]!, Colors.green[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "${buddy["match"]}% Match",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                // Destination Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Target Destination",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            buddy["destination"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Shared Interests Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (buddy["interests"] as List).map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.indigo[100]!),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          color: Colors.indigo[800],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Pass",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => _acceptInvite(buddy),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                        label: const Text(
                          "Connect & Chat",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
    );
  }

  // ==========================================
  // VIEW 2: THE IMMERSIVE CHAT INTERFACE
  // ==========================================
  Widget _buildChatInterface() {
    return Column(
      key: const ValueKey("ChatInterface"),
      children: [
        // Premium Chat Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: _activeBuddy!["color"].withOpacity(0.2),
                    child: Icon(
                      _activeBuddy!["avatar"],
                      color: _activeBuddy!["color"],
                      size: 24,
                    ),
                  ),
                  if (_activeBuddy!["status"] == "online")
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeBuddy!["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.g_translate_rounded,
                          size: 12,
                          color: Colors.indigo,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Live Translation Active",
                          style: TextStyle(
                            color: Colors.indigo[700],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.shield_outlined, color: Colors.green),
                tooltip: "Safe & Encrypted",
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Chat Messages List
        Expanded(
          child: Container(
            color: Colors.blueGrey[50],
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final msg = _chatMessages[index];
                return _buildChatBubble(msg["text"], msg["isMe"], msg["time"]);
              },
            ),
          ),
        ),

        // Interactive Input Area
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.indigo[600],
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo[600],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced Chat Bubble Builder
  Widget _buildChatBubble(String message, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.indigo[600] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

