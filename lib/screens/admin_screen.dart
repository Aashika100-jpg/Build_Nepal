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