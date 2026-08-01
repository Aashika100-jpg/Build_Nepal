import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _warningController = TextEditingController();
  String _selectedAlertRegion = 'Everest Region';
  String _activeFilterRegion = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allTourists = [
    {
      "id": "T-102",
      "name": "Alex D.",
      "loc": "Kathmandu",
      "exactLoc": "27.7172° N, 85.3240° E",
      "status": "Safe",
      "group": "Solo",
      "battery": "85%",
      "history": [
        "Thamel (10:00 AM)",
        "Durbar Square (1:30 PM)",
        "Swayambhunath (Current)",
      ],
    },
    {
      "id": "T-108",
      "name": "Sarah L.",
      "loc": "Everest Region",
      "exactLoc": "27.9860° N, 86.9226° E",
      "status": "SOS",
      "issue": "Avalanche Warning - Lost Signal",
      "action": "Heli-Rescue Dispatched (ETA: 12 Mins)",
      "group": "Group of 3",
      "battery": "12%",
      "history": [
        "Namche Bazaar (Yesterday)",
        "Tengboche (6:00 AM)",
        "Base Camp Trail (Signal Lost)",
      ],
    },
    {
      "id": "T-115",
      "name": "Li Wei",
      "loc": "Pokhara",
      "exactLoc": "28.2096° N, 83.9856° E",
      "status": "Safe",
      "group": "Solo",
      "battery": "92%",
      "history": ["Lakeside (9:00 AM)", "Peace Pagoda (Current)"],
    },
    {
      "id": "T-116",
      "name": "Carlos R.",
      "loc": "Pokhara",
      "exactLoc": "28.2100° N, 83.9800° E",
      "status": "Safe",
      "group": "Solo",
      "battery": "60%",
      "history": ["Sarangkot (5:00 AM)", "Lakeside (Current)"],
    },
    {
      "id": "T-120",
      "name": "Kenji T.",
      "loc": "Everest Region",
      "exactLoc": "27.8000° N, 86.7000° E",
      "status": "Safe",
      "group": "Group of 3",
      "battery": "45%",
      "history": ["Lukla (Yesterday)", "Phakding (Current)"],
    },
    {
      "id": "T-133",
      "name": "Nina K.",
      "loc": "Chitwan",
      "exactLoc": "27.5200° N, 84.4300° E",
      "status": "Safe",
      "group": "Solo",
      "battery": "78%",
      "history": ["Sauraha (8:00 AM)", "Jungle Safari (Current)"],
    },
  ];
  
  Future<void> _sendTargetedAlert() async {
    if (_warningController.text.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('warnings')
          .doc('latest')
          .set({
            'region': _selectedAlertRegion,
            'message': _warningController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });
          if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⚠️ Alert successfully broadcasted to $_selectedAlertRegion!',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _warningController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firebase Error: $e')));
    }
  }

void _showTouristDetails(Map<String, dynamic> tourist) {
    final isSOS = tourist['status'] == 'SOS';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            border: Border.all(
              color: isSOS ? Colors.redAccent : Colors.white12,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${tourist['name']} (${tourist['id']})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      isSOS ? Icons.warning_rounded : Icons.verified_user,
                      color: isSOS ? Colors.redAccent : Colors.greenAccent,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Group Size: ${tourist['group']} • Battery: ${tourist['battery']}",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 20),
                if (isSOS)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CRITICAL ISSUE DETECTED",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Issue: ${tourist['issue']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.redAccent,
                                strokeWidth: 2,
                              ),
                                                          ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Action: ${tourist['action']}",
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.satellite_alt_rounded,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Coordinates (${tourist['loc']})",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tourist['exactLoc'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "MOVEMENT HISTORY",
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: tourist['history'].length,
                    itemBuilder: (context, index) {
                      bool isLast = index == tourist['history'].length - 1;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                isLast ? Icons.location_on : Icons.circle,
                                color: isLast
                                    ? (isSOS
                                          ? Colors.redAccent
                                          : Colors.tealAccent)
                                    : Colors.grey[700],
                                size: isLast ? 24 : 12,
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: Colors.grey[800],
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              tourist['history'][index],
                              style: TextStyle(
                                color: isLast ? Colors.white : Colors.grey[500],
                                fontWeight: isLast
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 void _showEvidenceImage(String base64Str) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.memory(base64Decode(base64Str), fit: BoxFit.contain),
        ),
      ),
    );
  }

  Future<void> _markComplaintResolved(String docId) async {
    await FirebaseFirestore.instance.collection('complaints').doc(docId).update(
      {'status': 'resolved'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTourists = _allTourists.where((t) {
      final matchesRegion =
          _activeFilterRegion == 'All' || t['loc'] == _activeFilterRegion;
      final matchesSearch =
          t['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRegion && matchesSearch;
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          title: const Text(
            'OVERWATCH COMMAND',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.tealAccent,
            indicatorWeight: 3,
            labelColor: Colors.tealAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.radar_rounded), text: "LIVE TRACKING"),
              Tab(icon: Icon(Icons.report_problem_rounded), text: "COMPLAINTS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTrackingTab(filteredTourists),
            _buildComplaintsTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTrackingTab(List<Map<String, dynamic>> filteredTourists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[900]!.withOpacity(0.3), Colors.black],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    "BROADCAST GEO-WARNING",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ],