import 'package:flutter/material.dart';

class CategoryHelper {
  static String getDisplayName(String categoryKey) {
    switch (categoryKey) {
      case 'Food & Dining':
        return 'Food & Dining';
      case 'Groceries':
        return 'Groceries';
      case 'Transportation':
        return 'Transportation';
      case 'Utilities':
        return 'Utilities and Bills';
      case 'Shopping':
        return 'Shopping';
      case 'Entertainment':
        return 'Entertainment';
      case 'Office Supplies':
        return 'Office Supplies';
      case 'Travel':
        return 'Travel';
      case 'Healthcare':
        return 'Healthcare';
      case 'Services':
        return 'Services';
      default:
        return 'General';
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Food & Dining':
        return Colors.orangeAccent;
      case 'Groceries':
        return Colors.greenAccent;
      case 'Transportation':
        return Colors.blueAccent;
      case 'Utilities':
        return Colors.purpleAccent;
      case 'Shopping':
        return Colors.pinkAccent;
      case 'Entertainment':
        return Colors.amberAccent;
      case 'Office Supplies':
        return Colors.tealAccent;
      case 'Travel':
        return Colors.lightBlueAccent;
      case 'Healthcare':
        return Colors.redAccent;
      case 'Services':
        return Colors.indigoAccent;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.black87;
    }
  }

  static IconData getIcon(String categoryKey) {
    switch (categoryKey) {
      case 'Food & Dining':
        return Icons.restaurant_rounded;
      case 'Groceries':
        return Icons.shopping_cart_rounded;
      case 'Transportation':
        return Icons.directions_car_rounded;
      case 'Utilities':
        return Icons.lightbulb_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Office Supplies':
        return Icons.business_center_rounded;
      case 'Travel':
        return Icons.airplanemode_active_rounded;
      case 'Healthcare':
        return Icons.local_hospital_rounded;
      case 'Services':
        return Icons.build_rounded;
      case 'Other':
        return Icons.help_outline_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
