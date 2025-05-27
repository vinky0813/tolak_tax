import 'package:flutter/material.dart';

Widget SummaryCard({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Column(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(color: Colors.black54),
      ),
    ],
  );
}