import 'package:flutter/material.dart';

class ContainerAllInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ContainerAllInfo({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
