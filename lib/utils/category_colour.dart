import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
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
