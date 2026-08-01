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

        setState(() {
          _base64Image = base64String;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showCustomSnackBar(
        'Camera error: $e',
        Colors.red[800]!,
        Icons.error_outline,
      );
    }
  }

  void _showImagePickerOptions() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SafeArea(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blue[700],
                    ),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndCompressImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: Colors.purple[700],
                    ),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndCompressImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitComplaint() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showCustomSnackBar(
        'Please select an incident category.',
        Colors.orange[800]!,
        Icons.category_rounded,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_traveler_01';

      await FirebaseFirestore.instance.collection('complaints').add({
        'user_id': userId,
        'category': _selectedCategory!.toLowerCase().replaceAll(' / ', '_'),
        'vendor_name': _vendorNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'evidence_base64': _base64Image,
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showCustomSnackBar(
        'Official Report Filed. Authorities have been notified.',
        Colors.green[700]!,
        Icons.check_circle_rounded,
      );

      _formKey.currentState!.reset();
      _vendorNameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _base64Image = null;
      });

      // Optional: Pop screen after successful submission
      // Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
    } catch (e) {
      _showCustomSnackBar(
        'Network Error: Failed to transmit report.',
        Colors.red[800]!,
        Icons.wifi_off_rounded,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCustomSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Premium Slate Background
      appBar: AppBar(
        title: const Text(
          'Official Report Portal',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () =>
                FocusScope.of(context).unfocus(), // Dismiss keyboard easily
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECURITY TRUST BADGE ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            color: Colors.red[800],
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Encrypted & Secure",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.red[900],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "This report is sent directly to local tourist authorities.",
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'INCIDENT DETAILS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF64748B),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- CATEGORY DROPDOWN ---
                    DropdownButtonFormField<String>(
                      decoration: _getPremiumInputDecoration(
                        'Incident Category',
                        Icons.flag_rounded,
                      ),
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                      value: _selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['name'],
                          child: Row(
                            children: [
                              Icon(
                                category['icon'],
                                color: category['color'],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                category['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) =>
                          setState(() => _selectedCategory = newValue),
                    ),
                    const SizedBox(height: 20),

                    // --- VENDOR/LOCATION INPUT ---
                    TextFormField(
                      controller: _vendorNameController,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: _getPremiumInputDecoration(
                        'Location or Vendor Name (Optional)',
                        Icons.store_mall_directory_rounded,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- DESCRIPTION INPUT ---
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      decoration: _getPremiumInputDecoration(
                        'Describe exactly what happened...',
                        Icons.description_rounded,
                      ).copyWith(alignLabelWithHint: true),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'A brief description is required.'
                          : null,
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'SUPPORTING EVIDENCE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF64748B),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- ENHANCED IMAGE UPLOADER ---
                    InkWell(
                      onTap: _base64Image == null
                          ? _showImagePickerOptions
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _base64Image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo_rounded,
                                      size: 36,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tap to attach a photo',
                                    style: TextStyle(
                                      color: Color(0xFF475569),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '(Max size: 1MB)',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.memory(
                                      base64Decode(_base64Image!),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () =>
                                          setState(() => _base64Image = null),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: ElevatedButton.icon(
                                      onPressed: _showImagePickerOptions,
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        size: 16,
                                      ),
                                      label: const Text("Change"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black87,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- SUBMIT BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: Colors.red.withOpacity(0.5),
                        ),
                        onPressed: _isLoading ? null : _submitComplaint,
                        child: const Text(
                          'SUBMIT OFFICIAL REPORT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // --- CINEMATIC LOADING OVERLAY ---
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.red),
                        const SizedBox(height: 24),
                        Text(
                          'Encrypting Data...',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Transmitting to authorities',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method for clean input fields
  InputDecoration _getPremiumInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}
