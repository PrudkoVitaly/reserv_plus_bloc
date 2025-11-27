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

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
