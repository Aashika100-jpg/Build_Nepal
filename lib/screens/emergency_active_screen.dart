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