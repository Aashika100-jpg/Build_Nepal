import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login_screen.dart';
import 'sos_countdown_screen.dart';
import 'fair_pricing_screen.dart';
import 'ai_guide_screen.dart';
import 'co_traveler_screen.dart';
import 'vr_destinations_screen.dart';
import 'translation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _visaIssueDate = DateTime(2026, 5, 15);
  final int _visaTotalValidityDays = 90;

  final DateTime _currentSystemTime = DateTime(2026, 6, 27);

  int get _daysRemaining {
    final expiryDate = _visaIssueDate.add(
      Duration(days: _visaTotalValidityDays),
    );
    final difference = expiryDate.difference(_currentSystemTime).inDays;
    return difference < 0 ? 0 : difference;
  }

  double get _validityRatio {
    if (_daysRemaining <= 0) return 0.0;
    final ratio = _daysRemaining / _visaTotalValidityDays;
    return ratio.clamp(0.0, 1.0);
  }

  Future<void> _selectIssueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visaIssueDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.indigo[600]!,
              onPrimary: Colors.white,
              surface: const Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _visaIssueDate) {
      setState(() {
        _visaIssueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = _daysRemaining <= 15;
    final statusColor = isCritical
        ? Colors.redAccent
        : Colors.green[400]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.indigo[800],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo[900]!, Colors.indigo[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Namaste,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.indigo[100],
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Text(
                        'Traveler!',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),