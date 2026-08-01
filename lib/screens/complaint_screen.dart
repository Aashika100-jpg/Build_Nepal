import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vendorNameController = TextEditingController();

  String? _selectedCategory;
  String? _base64Image;
  bool _isLoading = false;

  // Added Icons to categories for a richer UI experience
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Overcharged',
      'icon': Icons.attach_money_rounded,
      'color': Colors.orange,
    },
    {
      'name': 'Dirty / Unhygienic',
      'icon': Icons.sanitizer_rounded,
      'color': Colors.brown,
    },
    {
      'name': 'Scammer / Fraud',
      'icon': Icons.money_off_csred_rounded,
      'color': Colors.red,
    },
    {
      'name': 'Harassment',
      'icon': Icons.pan_tool_rounded,
      'color': Colors.purple,
    },
    {
      'name': 'Safety Hazard',
      'icon': Icons.warning_rounded,
      'color': Colors.amber[700],
    },
  ];

  Future<void> _pickAndCompressImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 15,
        maxWidth: 600,
      );

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        List<int> imageBytes = await file.readAsBytes();
        String base64String = base64Encode(imageBytes);

        if (base64String.length > 900000) {
          if (!mounted) return;
          _showCustomSnackBar(
            'Photo is too large or detailed. Try snapping a simpler picture.',
            Colors.orange[800]!,
            Icons.photo_size_select_large_rounded,
          );
          return;
        }


