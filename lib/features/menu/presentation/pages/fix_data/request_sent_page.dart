import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_event.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';
import 'package:reserv_plus/features/shared/services/fix_data_request_service.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';

class RequestSentPage extends StatelessWidget {
  const RequestSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIcon(),
                      const SizedBox(height: 24),
                      _buildTitle(),
                      const SizedBox(height: 16),
                      _buildSubtitle(),
                      const SizedBox(height: 16),
                      _buildNotificationHint(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      height: 54,
      width: 54,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/logo_main_screen.jpg"),
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(226, 223, 204, 1),
            BlendMode.difference,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Запит надіслано',
      style: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      'Скоро ми повернемося\nдо вас із результатом.',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNotificationHint() {
    return const Text(
      'Увімкніть сповіщення, якщо\nне зробили цього раніше',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        height: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: PrimaryButton(
        text: 'Зрозуміло',
        onPressed: () async {
          // Сохраняем время запроса для блокировки на 1 час
          await FixDataRequestService.saveRequestTime();

          // Добавляем уведомление о запросе
          if (context.mounted) {
            context.read<NotificationBloc>().add(
                  NotificationAddRequestSent(
                    NotificationEntity(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: 'Запит на виправлення даних відправлено',
                      subtitle: 'Скоро ви дізнаєтесь, чи доставлено ваш запит.',
                      timestamp: DateTime.now(),
                    ),
                  ),
                );
            NavigationUtils.popToFirst(context);
          }
        },
      ),
    );
  }
}
