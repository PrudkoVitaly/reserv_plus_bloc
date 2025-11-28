import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/document/presentation/bloc/document_bloc.dart';
import 'package:reserv_plus/features/document/presentation/bloc/document_event.dart';
import 'package:reserv_plus/features/document/data/repositories/document_repository_impl.dart';
import 'package:reserv_plus/features/notifications/domain/entities/notification.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_event.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/request_sent/presentation/pages/request_sent_page.dart';
import 'package:reserv_plus/features/document/presentation/pages/update_unavailable_page.dart';

class DocumentUpdateModal extends StatelessWidget {
  const DocumentUpdateModal({super.key});

  Future<void> _onUpdateDocument(BuildContext context) async {
    // 1. Создаем экземпляр репозитория для проверки
    final repository = DocumentRepositoryImpl();

    // 2. Проверяем, можно ли обновить документ
    final canUpdate = await repository.canUpdateDocument();

    // 3. Закрываем модальное окно
    Navigator.of(context).pop();

    // 4. Если нельзя обновить - показываем страницу с предупреждением
    if (!canUpdate) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (context.mounted) {
          NavigationUtils.pushWithHorizontalAnimation(
            context: context,
            page: const UpdateUnavailablePage(),
          );
        }
      });
      return; // Выходим из метода, не выполняя обновление
    }

    // 5. Если можно обновить - выполняем стандартную логику
    // Отправляем событие в DocumentBloc
    context.read<DocumentBloc>().add(const DocumentUpdateData());

    // 6. Создаем первое уведомление (запрос отправлен)
    final now = DateTime.now();
    final firstNotification = NotificationEntity(
      id: '${now.microsecondsSinceEpoch}_1',
      title: 'Запит на інформацію з реєстру відправлено',
      subtitle: 'Очікуйте сповіщення про результат обробки запиту',
      timestamp: now,
    );

    // 7. Создаем второе уведомление (данные получены) - будет добавлено через 5 секунд
    final secondNotification = NotificationEntity(
      id: '${now.microsecondsSinceEpoch}_2',
      title: 'Дані з реєстру Оберіг отримано',
      subtitle: 'Військово-обліковий документ вже доступний',
      timestamp: now,
    );

    // 8. Используем глобальный NotificationBloc и добавляем уведомления
    final notificationBloc = context.read<NotificationBloc>();
    notificationBloc.add(NotificationAddRequestSent(firstNotification));
    notificationBloc.add(NotificationAddDataReceived(secondNotification));

    // 9. Открываем RequestSentPage с небольшой задержкой для корректной навигации
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        NavigationUtils.pushWithHorizontalAnimation(
          context: context,
          page: const RequestSentPage(),
        );
      }
    });
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
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      "images/info_icon.png",
                      width: 60,
                      height: 60,
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
                          color: Colors.black,
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
                        color: Colors.black,
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
