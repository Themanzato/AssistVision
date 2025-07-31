import 'package:flutter/material.dart';

class CustomInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> options;
  final Function(String) onOptionSelected;

  const CustomInfoCard({super.key, 
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 30.0),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            if (description.isNotEmpty)
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            if (options.isNotEmpty)
              ...options.map((option) => ListTile(
                    title: Text(option),
                    onTap: () => onOptionSelected(option),
                  )),
          ],
        ),
      ),
    );
  }
}