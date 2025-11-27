import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/document/presentation/bloc/document_bloc.dart';
import 'package:reserv_plus/features/document/presentation/bloc/document_event.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_event.dart';

class DocumentUpdateModal extends StatelessWidget {
  const DocumentUpdateModal({super.key});

  void _onUpdateDocument(BuildContext context) {
    // 1. Отправляем событие в DocumentBloc (как было)
    context.read<DocumentBloc>().add(const DocumentUpdateData());

    // 2. Создаем первое уведомление (запрос отправлен)
    final now = DateTime.now();
    final firstNotification = NotificationEntity(
      id: '${now.microsecondsSinceEpoch}_1',
      title: 'Запит на інформацію з реєстру відправлено',
      subtitle: 'Очікуйте сповіщення про результат обробки запиту',
      timestamp: now,
    );

    // 3. Создаем второе уведомление (данные получены) - будет добавлено через 5 секунд
    final secondNotification = NotificationEntity(
      id: '${now.microsecondsSinceEpoch}_2',
      title: 'Дані з реєстру Оберіг отримано',
      subtitle: 'Військово-обліковий документ вже доступний',
      timestamp: now,
    );

    // 4. Используем глобальный NotificationBloc и добавляем уведомления
    final notificationBloc = context.read<NotificationBloc>();
    notificationBloc.add(NotificationAddRequestSent(firstNotification));
    notificationBloc.add(NotificationAddDataReceived(secondNotification));

    // 5. Закрываем модальное окно
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.01),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Иконка "i"
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(253, 135, 12, 1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Текст сообщения
                  const Text(
                    'Поки генеруватиметься нова версія документу, деякі послуги можуть бути недоступні',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Кнопка "Оновити"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _onUpdateDocument(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Оновити',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Кнопка "Скасувати"
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Скасувати',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
