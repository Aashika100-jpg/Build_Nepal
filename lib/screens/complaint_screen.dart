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
