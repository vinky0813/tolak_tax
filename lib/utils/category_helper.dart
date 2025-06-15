import 'package:flutter/material.dart';

class CategoryHelper {

  static String getDisplayName(String categoryKey) {
    switch (categoryKey) {
      case 'food':
        return 'Makan (Food)';
      case 'shopping':
        return 'Shopping';
      case 'utilities':
        return 'Utilities & Bills';
      case 'entertainment':
        return 'Entertainment';
      case 'transport':
        return 'Transportation';
      default:
        return 'General';
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.green;
      case 'shopping':
        return Colors.purple;
      case 'utilities':
        return Colors.blue;
      case 'entertainment':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }

  static IconData getIcon(String categoryKey) {
    switch (categoryKey) {
      case 'food':
        return Icons.fastfood_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'utilities':
        return Icons.receipt_long_rounded;
      case 'entertainment':
        return Icons.movie_filter_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      default:
        return Icons.category_rounded;
    }
  }

}

