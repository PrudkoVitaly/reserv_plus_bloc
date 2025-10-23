class NotificationEntity {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isRead = false,
  });
}
