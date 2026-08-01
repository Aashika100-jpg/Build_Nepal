import 'package:flutter/material.dart';
import 'vr_tour_screen.dart';

class VrDestinationsScreen extends StatelessWidget {
  const VrDestinationsScreen({super.key});

  // Maintained your exact asset library data structure
  final List<Map<String, String>> _destinations = const [
    {
      "title": "Everest Base Camp",
      "image": "assets/Everest Base Camp (Solukhumbu).png",
    },
    {
      "title": "Annapurna Base Camp",
      "image": "assets/Annapurna Base Camp Sanctuary.png",
    },
    {
      "title": "Boudhanath Stupa",
      "image": "assets/Boudhanath Stupa Courtyard (.png",
    },
    {
      "title": "Kathmandu Durbar Square",
      "image": "assets/Kathmandu Durbar Square.png",
    },
    {"title": "Phewa Lake", "image": "assets/Phewa Lake Rowing (Pokhara).png"},
    {
      "title": "Chitwan Safari",
      "image": "assets/Chitwan National Park Jungle Safari.png",
    },
    {
      "title": "Lumbini Gardens",
      "image": "assets/Lumbini Sacred Gardens (Birthplace of Buddha).png",
    },
    {
      "title": "Monkey Temple",
      "image": "assets/Swayambhunath Monkey Temple Overlook.png",
    },
    {
      "title": "Bhaktapur Pottery Square",
      "image": "assets/Bhaktapur Pottery Square.png",
    },
    {"title": "Tea Estates of Ilam", "image": "assets/Tea Estates of Ilam.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Premium Dark Slate Canvas
      appBar: AppBar(
        title: const Text(
          'Immersive VR Portals',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: _destinations.length,
        itemBuilder: (context, index) {
          final dest = _destinations[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // 1. Background Preview Image Layer
                  Positioned.fill(
                    child: Image.asset(
                      dest['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback container if asset files aren't physically bundled yet
                        return Container(color: const Color(0xFF334155));
                      },
                    ),
                  ),

                  // 2. Cinematic Dark Gradient Mask
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.85),
                            Colors.black.withOpacity(0.2),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),

                  // 3. Info Content Layer
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.tealAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.tealAccent.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.threesixty_rounded,
                                size: 14,
                                color: Colors.tealAccent,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "360° MOTION EXPERIENCES",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dest['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. Full Card Ripple Button Inkwell
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.tealAccent.withOpacity(0.15),
                        highlightColor: Colors.tealAccent.withOpacity(0.05),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VrTourScreen(
                                title: dest['title']!,
                                imagePath: dest['image']!,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
