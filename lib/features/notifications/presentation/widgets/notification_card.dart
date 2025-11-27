import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/notifications/presentation/pages/request_sent_detail_page.dart';
import 'package:reserv_plus/features/notifications/presentation/pages/data_received_detail_page.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_event.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? const Color.fromARGB(255, 243, 241, 233)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
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
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    // Отправляем событие о прочтении уведомления
    context.read<NotificationBloc>().add(
          NotificationMarkAsRead(notification.id),
        );

    Widget? detailPage;

    switch (notification.title) {
      case 'Запит на інформацію з реєстру відправлено':
        detailPage = const RequestSentDetailPage();
        break;
      case 'Дані з реєстру Оберіг отримано':
        detailPage = const DataReceivedDetailPage();
        break;
      default:
        return; // Не открываем детали для неизвестных типов
    }

    NavigationUtils.pushWithHorizontalAnimation(
      context: context,
      page: detailPage,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}.${timestamp.month}.${timestamp.year} о ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
