import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen> {
  File? _image;
  bool _isLoading = false;
  String _resultText = "Snap a photo of a monument to learn its history!";

  // Dynamic IP configuration for your local Python FastAPI Server
  final TextEditingController _ipController = TextEditingController(
    text:
        "192.168.1.XXX", // Update this with the IP printed by your Python server
  );

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800, // Keep it small for faster AI processing
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _resultText = "Image loaded. Tap 'Analyze Monument' to ask AI.";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
      _resultText = "Uploading to Yatra Sathi Server... Please wait.";
    });

    try {
      // 1. Connect to your FastAPI server on port 8000 (NOT Ollama directly)
      final String ip = _ipController.text.trim();
      final Uri backendUrl = Uri.parse("http://$ip:8000/api/analyze-monument");

      // 2. Create a Multipart Request to send the actual file
      var request = http.MultipartRequest('POST', backendUrl);

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );

      // 3. Send the request
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      ); // Give AI time to think

      // 4. Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // FastAPI server returns {"answer": "..."}
          _resultText = data['answer'] ?? "I couldn't identify this monument.";
        });
      } else {
        setState(() {
          _resultText = "Server Error ${response.statusCode}: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _resultText =
            "Connection Failed. Make sure your laptop and phone are on the same WiFi, and the Python server is running.\n\nError: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Monument Guide'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Settings Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wifi_tethering, color: Colors.teal[700]),
                        const SizedBox(width: 8),
                        const Text(
                          "Server Connection",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'Laptop IP Address',
                        hintText: 'e.g. 192.168.1.15',
                        filled: true,
                        fillColor: Colors.teal[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),