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