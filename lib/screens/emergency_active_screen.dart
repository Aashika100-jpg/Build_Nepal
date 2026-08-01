import 'package:flutter/material.dart';

class PricingItem {
  final String name;
  final String location;
  final String category; // 'taxi', 'bus', 'food', 'goods'
  final double minPrice;
  final double maxPrice;
  final String unit;
  final String tip;
  final String pickup;   // Added for advanced routing
  final String dropoff;  // Added for advanced routing

  const PricingItem({
    required this.name,
    required this.location,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.unit,
    required this.tip,
    this.pickup = "",
    this.dropoff = "",
  });
}

class FairPricingScreen extends StatefulWidget {
  const FairPricingScreen({super.key});

  @override
  State<FairPricingScreen> createState() => _FairPricingScreenState();
}

class _FairPricingScreenState extends State<FairPricingScreen> {
  String _searchQuery = "";
  String _selectedTab = "all";
  String _selectedPickup = "All";
  String _selectedDropoff = "All";

  // Robust, locally optimized database
  final List<PricingItem> _pricingDatabase = [
    // --- TAXI ROUTES ---
    PricingItem(
      name: "Prepaid Airport Taxi",
      location: "Kathmandu",
      category: "taxi",
      minPrice: 800,
      maxPrice: 1200,
      unit: "Trip",
      tip: "Use the official prepaid booth inside the arrival gate.",
      pickup: "TIA Airport",
      dropoff: "Thamel",
    ),
    PricingItem(
      name: "Thamel to Bhaktapur Durbar Square",
      location: "Kathmandu Valley",
      category: "taxi",
      minPrice: 1000,
      maxPrice: 1400,
      unit: "Trip",
      tip: "Agree on using the meter or fix the price before boarding.",
      pickup: "Thamel",
      dropoff: "Bhaktapur",
    ),
    PricingItem(
      name: "Lakeside to Sarangkot Sunrise",
      location: "Pokhara",
      category: "taxi",
      minPrice: 1200,
      maxPrice: 1800,
      unit: "Round Trip",
      tip: "Includes waiting time for the sunrise view.",
      pickup: "Lakeside",
      dropoff: "Sarangkot",
    ),
    PricingItem(
      name: "Lagankhel to Ratnapark Commute",
      location: "Kathmandu Valley",
      category: "taxi",
      minPrice: 400,
      maxPrice: 600,
      unit: "Trip",
      tip: "Easily available near the main bus park areas.",
      pickup: "Lalitpur",
      dropoff: "Kathmandu",
    ),

    // --- BUS ROUTES ---
    PricingItem(
      name: "Deluxe Tourist Bus (AC)",
      location: "Intercity",
      category: "bus",
      minPrice: 1000,
      maxPrice: 1600,
      unit: "Seat",
      tip: "Includes a lunch stop at a hygienic highway restaurant.",
      pickup: "Kathmandu",
      dropoff: "Pokhara",
    ),
    PricingItem(
      name: "Local Express Bus",
      location: "Kathmandu Valley",
      category: "bus",
      minPrice: 35,
      maxPrice: 50,
      unit: "Ride",
      tip: "Student discounts are applicable with a valid ID card.",
      pickup: "Kathmandu",
      dropoff: "Bhaktapur",
    ),
    PricingItem(
      name: "Local City Ringroad Bus",
      location: "Kathmandu",
      category: "bus",
      minPrice: 25,
      maxPrice: 40,
      unit: "Ride",
      tip: "Keep small changes handy; ask the conductor for your stop.",
      pickup: "Kathmandu",
      dropoff: "Lalitpur",
    ),

    // --- FOOD & DINING ---
    PricingItem(
      name: "Authentic Thakali Khaja Set",
      location: "Local Eateries",
      category: "food",
      minPrice: 400,
      maxPrice: 750,
      unit: "Plate",
      tip: "Ghee, dal, and vegetable refills are traditionally free.",
    ),
    PricingItem(
      name: "Steam Chicken Momo",
      location: "Anywhere",
      category: "food",
      minPrice: 150,
      maxPrice: 320,
      unit: "Plate (10 pcs)",
      tip: "Local secondary alleys offer the most authentic jhol achar.",
    ),
    PricingItem(
      name: "Bhaktapur Juju Dhau (King Curd)",
      location: "Bhaktapur",
      category: "food",
      minPrice: 80,
      maxPrice: 150,
      unit: "Clay Pot",
      tip: "Look for authentic clay pots near Durbar Square corners.",
    ),
    PricingItem(
      name: "Newari Samay Baji Khaja Set",
      location: "Kirtipur / Patan",
      category: "food",
      minPrice: 250,
      maxPrice: 450,
      unit: "Set",
      tip: "Includes beaten rice, choila, bara, and dynamic local spices.",
    ),

    // --- GOODS & SOUVENIRS ---
    PricingItem(
      name: "Handmade Tibetan Singing Bowl",
      location: "Bazaars",
      category: "goods",
      minPrice: 1500,
      maxPrice: 4500,
      unit: "Item",
      tip: "Test the resonance frequency with the wooden mallet first.",
    ),
    PricingItem(
      name: "Pure Pashmina Shawl",
      location: "Thamel / Pokhara",
      category: "goods",
      minPrice: 2500,
      maxPrice: 7000,
      unit: "Item",
      tip: "Perform the ring test to ensure genuine material thickness.",
    ),
    PricingItem(
      name: "Traditional Bhadgaonle Dhaka Topi",
      location: "Bhaktapur",
      category: "goods",
      minPrice: 350,
      maxPrice: 900,
      unit: "Item",
      tip: "Hand-woven patterns hold significantly higher value.",
    ),
  ];

  // Dynamic calculation of unique locations for dropdown menus
  List<String> _getUniqueLocations(bool isPickup) {
    final Set<String> locations = {"All"};
    for (var item in _pricingDatabase) {
      final val = isPickup ? item.pickup : item.dropoff;
      if (val.isNotEmpty) locations.add(val);
    }
    return locations.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    // Advanced Multi-Layer Filter Engine
    final filteredItems = _pricingDatabase.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.pickup.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.dropoff.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesTab = _selectedTab == "all" || item.category == _selectedTab;
      
      // Strict routing filter applied exclusively to transport tabs
      bool matchesRoute = true;
      if (_selectedTab == "taxi" || _selectedTab == "bus") {
        if (_selectedPickup != "All" && item.pickup != _selectedPickup) matchesRoute = false;
        if (_selectedDropoff != "All" && item.dropoff != _selectedDropoff) matchesRoute = false;
      }

      return matchesSearch && matchesTab && matchesRoute;
    }).toList();

    final isTransportMode = _selectedTab == "taxi" || _selectedTab == "bus";

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          'Smart Pricing & Route Hub',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        elevation: 0,
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        actions: [
          if (_selectedPickup != "All" || _selectedDropoff != "All" || _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: "Reset Filters",
              onPressed: () {
                setState(() {
                  _searchQuery = "";
                  _selectedPickup = "All";
                  _selectedDropoff = "All";
                });
              },
            )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilters(),
          if (isTransportMode) _buildRouteSelector(),
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) => _buildPriceCard(filteredItems[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.teal[800],
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Search items, specific locations, or routes...",
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.teal[800]),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 65,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildTab("all", "All Hub", Icons.dashboard_customize_rounded),
          _buildTab("taxi", "Taxi Fares", Icons.local_taxi_rounded),
          _buildTab("bus", "Bus Routes", Icons.directions_bus_rounded),
          _buildTab("food", "Food & Meals", Icons.restaurant_rounded),
          _buildTab("goods", "Local Goods", Icons.shopping_bag_rounded),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label, IconData icon) {
    final isSelected = _selectedTab == id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: ChoiceChip(
        iconTheme: IconThemeData(color: isSelected ? Colors.white : Colors.teal[800]),
        avatar: Icon(icon, size: 18),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.teal[900],
          ),
        ),
        selected: isSelected,
        selectedColor: Colors.teal[700],
        backgroundColor: Colors.teal[50],
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (s) => setState(() {
          _selectedTab = id;
          // Clear route filters if leaving transport context
          if (id != "taxi" && id != "bus") {
            _selectedPickup = "All";
            _selectedDropoff = "All";
          }
        }),
      ),
    );
  }

  Widget _buildRouteSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by Specific Route",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPickup,
                  decoration: _getDropdownDecoration("Pick-up Point"),
                  items: _getUniqueLocations(true).map((String loc) {
                    return DropdownMenuItem<String>(value: loc, child: Text(loc));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedPickup = v ?? "All"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDropoff,
                  decoration: _getDropdownDecoration("Drop-off Point"),
                  items: _getUniqueLocations(false).map((String loc) {
                    return DropdownMenuItem<String>(value: loc, child: Text(loc));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedDropoff = v ?? "All"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _getDropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.teal[800], fontSize: 12, fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      filled: true,
      fillColor: Colors.blueGrey[50]?.withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }

  Widget _buildPriceCard(PricingItem item) {
    final hasRouteInfo = item.pickup.isNotEmpty && item.dropoff.isNotEmpty;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
      ),
      child: ExpansionTile(
        shape: const Border(), // Removes bottom line glitch on expansion
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(item.category).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getCategoryIcon(item.category), color: _getCategoryColor(item.category)),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hasRouteInfo ? "${item.pickup} ➔ ${item.dropoff}" : item.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "NPR ${item.minPrice.toInt()}-${item.maxPrice.toInt()}",
              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.teal, fontSize: 15),
            ),
            Text(
              "per ${item.unit}",
              style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal[50]?.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: Colors.amber[800], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Pro Tip: ${item.tip}",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey[800],
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "No Pricing Info Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              "Try modifying your query or changing the pick-up/drop-off destinations.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'taxi': return Colors.amber[800]!;
      case 'bus': return Colors.blue[700]!;
      case 'food': return Colors.green[700]!;
      default: return Colors.purple[700]!;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'taxi': return Icons.local_taxi_rounded;
      case 'bus': return Icons.directions_bus_rounded;
      case 'food': return Icons.restaurant_rounded;
      default: return Icons.shopping_bag_rounded;
    }
  }
}

