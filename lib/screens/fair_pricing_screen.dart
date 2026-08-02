import 'package:flutter/material.dart';

class PricingItem {
  final String name;
  final String location;
  final String category; // 'taxi', 'bus', 'food', 'goods'
  final double minPrice;
  final double maxPrice;
  final String unit;
  final String tip;
  final String pickup; // Added for advanced routing
  final String dropoff; // Added for advanced routing

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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by name, location, or route',
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final tabs = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Taxi', 'value': 'taxi'},
      {'label': 'Bus', 'value': 'bus'},
      {'label': 'Food', 'value': 'food'},
      {'label': 'Goods', 'value': 'goods'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tabs.map((tab) {
          final selected = _selectedTab == tab['value'];
          return ChoiceChip(
            label: Text(tab['label'] as String),
            selected: selected,
            onSelected: (_) {
              setState(() => _selectedTab = tab['value'] as String);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRouteSelector() {
    final pickupOptions = _getUniqueLocations(true);
    final dropoffOptions = _getUniqueLocations(false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPickup,
              decoration: const InputDecoration(
                labelText: 'Pickup',
                border: OutlineInputBorder(),
              ),
              items: pickupOptions
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPickup = value);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedDropoff,
              decoration: const InputDecoration(
                labelText: 'Dropoff',
                border: OutlineInputBorder(),
              ),
              items: dropoffOptions
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDropoff = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No pricing items match your current filters.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPriceCard(PricingItem item) {
    final displayPrice = item.minPrice == item.maxPrice
        ? '${item.minPrice.toStringAsFixed(0)} ${item.unit}'
        : '${item.minPrice.toStringAsFixed(0)}-${item.maxPrice.toStringAsFixed(0)} ${item.unit}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      displayPrice,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.location, style: TextStyle(color: Colors.grey[700])),
              if (item.pickup.isNotEmpty || item.dropoff.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  '${item.pickup.isNotEmpty ? item.pickup : '—'} → ${item.dropoff.isNotEmpty ? item.dropoff : '—'}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                item.tip,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Advanced Multi-Layer Filter Engine
    final filteredItems = _pricingDatabase.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.pickup.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.dropoff.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesTab = _selectedTab == "all" || item.category == _selectedTab;

      // Strict routing filter applied exclusively to transport tabs
      bool matchesRoute = true;
      if (_selectedTab == "taxi" || _selectedTab == "bus") {
        if (_selectedPickup != "All" && item.pickup != _selectedPickup)
          matchesRoute = false;
        if (_selectedDropoff != "All" && item.dropoff != _selectedDropoff)
          matchesRoute = false;
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
          if (_selectedPickup != "All" ||
              _selectedDropoff != "All" ||
              _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: "Reset Filters",
              onPressed: () {
                setState(() {
                  _searchQuery = "";
                  _selectedTab = "all";
                  _selectedPickup = "All";
                  _selectedDropoff = "All";
                });
              },
            ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) =>
                        _buildPriceCard(filteredItems[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
