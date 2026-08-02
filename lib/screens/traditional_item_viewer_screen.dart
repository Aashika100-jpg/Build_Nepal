import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Data model representing each traditional item in the collection
class TraditionalItem {
  final String id;
  final String title;
  final String category;
  final String material;
  final String assetPath;
  final String description;
  final IconData icon;

  const TraditionalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.material,
    required this.assetPath,
    required this.description,
    required this.icon,
  });
}

class TraditionalItemViewerScreen extends StatefulWidget {
  const TraditionalItemViewerScreen({Key? key}) : super(key: key);

  @override
  State<TraditionalItemViewerScreen> createState() =>
      _TraditionalItemViewerScreenState();
}

class _TraditionalItemViewerScreenState
    extends State<TraditionalItemViewerScreen> {
  int _selectedIndex = 0;
  bool _autoRotate = true;

  // List of all 3D products matching your assets folder
  // Note: Check exact filenames in your project if any full extension varies slightly
  final List<TraditionalItem> _items = const [
    TraditionalItem(
      id: 'gagri',
      title: 'Nepali Gagri',
      category: 'Household Vessel',
      material: 'Brass / Copper',
      assetPath: 'assets/product/gagri.glb',
      description:
          'A classic water vessel widely used in Nepali households for fetching and storing water. Its unique bell-shaped brass design keeps water cool naturally.',
      icon: Icons.local_drink_rounded,
    ),
    TraditionalItem(
      id: 'hasiya',
      title: 'Hasiya (Sickle)',
      category: 'Agricultural Tool',
      material: 'Hand-Forged Iron & Wood',
      assetPath: 'assets/product/hasiya_final_model.glb',
      description:
          'An indispensable curved farming tool used throughout rural Nepal for harvesting crops, cutting foliage, and everyday agricultural tasks.',
      icon: Icons.agriculture_rounded,
    ),
    TraditionalItem(
      id: 'dhaka_topi',
      title: 'Dhaka Topi',
      category: 'Traditional Attire',
      material: 'Handwoven Dhaka Fabric',
      assetPath: 'assets/product/nepali_dhaka_topi_3d_model.glb',
      description:
          'The iconic brimless cap of Nepal, woven with intricate geometric Dhaka patterns. It represents national pride, cultural heritage, and identity.',
      icon: Icons.style_rounded,
    ),
    TraditionalItem(
      id: 'halberd_axe',
      title: 'Nepali Halberd Axe',
      category: 'Historical Weaponry',
      material: 'Steel & Wood',
      assetPath: 'assets/product/nepali_halbardaxe.glb',
      description:
          'A traditional ceremonial polearm combining an axe blade and spear point, historically carried by palace guards and royal warriors.',
      icon: Icons.security_rounded,
    ),
    TraditionalItem(
      id: 'karuwa',
      title: 'Nepali Karuwa',
      category: 'Ceremonial Pitcher',
      material: 'Cast Brass / Bronze',
      assetPath: 'assets/product/nepali_karuwa_3d_scan.glb',
      description:
          'An elegant water vessel featuring a distinctive long spout. Karuwas are central to traditional hospitality, worship rituals, and festivals.',
      icon: Icons.sanitizer_rounded,
    ),
    TraditionalItem(
      id: 'khukuri',
      title: 'Gorkha Khukuri',
      category: 'Heritage Weapon',
      material: 'Carbon Steel & Rosewood',
      assetPath: 'assets/product/nepali_khukuri.glb',
      description:
          'The world-famous curved knife of Nepal, renowned as the national weapon and a symbol of bravery associated with the legendary Gorkha soldiers.',
      icon: Icons.sports_martial_arts_rounded,
    ),
    TraditionalItem(
      id: 'muda',
      title: 'Nepali Muda',
      category: 'Handcrafted Furniture',
      material: 'Bamboo & Rope',
      assetPath: 'assets/product/nepali_muda.glb',
      description:
          'A lightweight stool woven from durable bamboo strips and reed rope. A ubiquitous seating piece found in tea stalls and homes across Nepal.',
      icon: Icons.chair_rounded,
    ),
    TraditionalItem(
      id: 'singing_bowl',
      title: 'Nepali Singing Bowl',
      category: 'Meditation & Sound',
      material: 'Seven-Metal Alliance',
      assetPath: 'assets/product/singing_nepali_bowl_-_animation.glb',
      description:
          'A handcrafted musical bowl used in sound meditation and therapy. Striking or rubbing its rim produces rich, soothing harmonic acoustic resonances.',
      icon: Icons.music_note_rounded,
    ),
    TraditionalItem(
      id: 'green_tara',
      title: 'Green Tara (Arya Tara)',
      category: 'Sacred Art',
      material: 'Gilded Bronze',
      assetPath: 'assets/product/the_green_tara_or_sgrol-ljang.glb',
      description:
          'A sacred Buddhist deity representing ultimate compassion, quick action, and protection. Hand-cast with intricate Himalayan iconographic detail.',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  TraditionalItem get _currentItem => _items[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1615), // Elegant dark slate backdrop
      appBar: AppBar(
        title: const Text(
          'Cultural Heritage 3D',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: Color(0xFFF3E5AB), // Warm gold text accent
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B211E),
        elevation: 4,
        actions: [
          IconButton(
            tooltip: _autoRotate ? 'Pause Rotation' : 'Auto Rotate',
            icon: Icon(
              _autoRotate ? Icons.sync : Icons.sync_disabled,
              color: _autoRotate ? const Color(0xFFE5A93C) : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _autoRotate = !_autoRotate;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TOP ITEM SELECTOR CAROUSEL
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _items.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isSelected = index == _selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      avatar: Icon(
                        item.icon,
                        size: 18,
                        color: isSelected
                            ? const Color(0xFF1A1615)
                            : const Color(0xFFE5A93C),
                      ),
                      label: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.white70,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE5A93C),
                      backgroundColor: const Color(0xFF2B211E),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // MAIN 3D DISPLAY STAGE
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFF3D2F2A), Color(0xFF141110)],
                    radius: 0.85,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE5A93C).withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // ModelViewer re-initializes key whenever selection changes
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: ModelViewer(
                        key: ValueKey(_currentItem.assetPath),
                        src: _currentItem.assetPath,
                        alt: '3D model of ${_currentItem.title}',
                        ar: true,
                        autoRotate: _autoRotate,
                        cameraControls: true,
                        disableZoom: false,
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    // Quick Tip Overlay
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.threed_rotation,
                                color: Color(0xFFE5A93C), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Touch & Drag to Rotate',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // DETAILS & METADATA SECTION
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2B211E),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _currentItem.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF3E5AB),
                              ),
                            ),
                          ),
                          Icon(
                            _currentItem.icon,
                            color: const Color(0xFFE5A93C),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Category Chips
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildBadge(
                              _currentItem.category, const Color(0xFF8C3A2B)),
                          _buildBadge(
                              _currentItem.material, const Color(0xFF3D5A45)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Description Header
                      const Text(
                        'Cultural Significance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white54,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Description Text
                      Text(
                        _currentItem.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}