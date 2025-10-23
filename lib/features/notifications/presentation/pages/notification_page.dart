import 'package:flutter/material.dart';
import 'package:reserv_plus/features/notifications/data/notification_data.dart';
import 'package:reserv_plus/features/notifications/presentation/widgets/notification_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationData.getAllNotifications();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Сповіщення',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 16 : 0,
                      bottom: 0,
                    ),
                    child: NotificationCard(
                      notification: notifications[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
