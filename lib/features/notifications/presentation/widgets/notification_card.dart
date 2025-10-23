import 'package:flutter/material.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            notification.subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 6),
          Text(
            _formatTimestamp(notification.timestamp),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}.${timestamp.month}.${timestamp.year} о ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
