import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../../../person_info/presentation/utils/person_info_utils.dart';
import '../../../extended_data/presentation/pages/extended_data_request_page.dart';
import '../../../extended_data/presentation/pages/extended_data_review_page.dart';
import '../../../extended_data/domain/entities/extended_data.dart';
import '../pages/vlk_unavailable_page.dart';
import '../utils/modal_utils.dart';

class DocumentModalDialog extends StatefulWidget {
  const DocumentModalDialog({super.key});

  @override
  State<DocumentModalDialog> createState() => _DocumentModalDialogState();
}

class _DocumentModalDialogState extends State<DocumentModalDialog> {
  double _dragStartY = 0.0;
  double _dragCurrentY = 0.0;
  double _dragOffset = 0.0;

  void _closeModal() {
    Navigator.of(context).pop();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragCurrentY = details.globalPosition.dy;
    double rawOffset = _dragCurrentY - _dragStartY;

    // Разрешаем только движение вниз (положительные значения)
    // Если пытаются поднять вверх, оставляем 0
    _dragOffset = rawOffset > 0 ? rawOffset : 0;

    setState(() {}); // Обновляем UI для следования за пальцем
  }

  void _handleDragEnd(DragEndDetails details) {
    double dragDistance = _dragCurrentY - _dragStartY;
    double velocity = details.primaryVelocity ?? 0;

    // Закрываем если перетащили вниз больше чем на 100 пикселей ИЛИ скорость больше 500
    if (dragDistance > 100 || velocity > 500) {
      _closeModal();
    } else {
      // Возвращаем контейнер в исходную позицию
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.01),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _closeModal(); // Закрываем модальное окно при клике вне контейнера
          },
          child: Center(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1), // Начинаем снизу экрана
                end: const Offset(0, 0.35), // Заканчиваем ниже центра
              ).animate(CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeInOut,
              )),
              child: Transform.translate(
                offset:
                    Offset(0, _dragOffset), // Перемещаем контейнер за пальцем
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      () {}, // Пустой обработчик - блокируем клики на контейнере
                  onPanStart: _handleDragStart, // Начало перетаскивания
                  onPanUpdate: _handleDragUpdate, // Обновление позиции
                  onPanEnd: _handleDragEnd, // Окончание перетаскивания
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          context,
                          icon: Icons.info_outline,
                          title: "Переглянути документ",
                          onTap: () {
                            _closeModal();
                            PersonInfoUtils.showPersonInfoModal(context);
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.upload_file_outlined,
                          title: "Завантажити PDF",
                          onTap: () {
                            context
                                .read<DocumentBloc>()
                                .add(const DocumentShareDocument());
                            _closeModal();
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.refresh,
                          title: "Оновити документ",
                          onTap: () {
                            // Закрываем текущий модал
                            _closeModal();
                            // Показываем новый модал с небольшой задержкой
                            Future.delayed(const Duration(milliseconds: 200), () {
                              if (context.mounted) {
                                ModalUtils.showDocumentUpdateModal(context);
                              }
                            });
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.add_circle_outline,
                          title: "Розширені дані з реєстру",
                          onTap: () {
                            // Сохраняем navigator ДО закрытия модала
                            final navigator = Navigator.of(context, rootNavigator: true);
                            _closeModal();

                            // Используем сохраненный navigator
                            Future.delayed(const Duration(milliseconds: 300), () {
                              navigator.push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      const ExtendedDataRequestPage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.horizontal,
                                      fillColor: const Color.fromRGBO(226, 223, 204, 1),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 350),
                                  reverseTransitionDuration: const Duration(milliseconds: 350),
                                ),
                              );
                            });
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.medical_services_outlined,
                          title: "Направлення на ВЛК",
                          onTap: () {
                            final navigator = Navigator.of(context, rootNavigator: true);
                            _closeModal();

                            Future.delayed(const Duration(milliseconds: 300), () {
                              navigator.push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      const VlkUnavailablePage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.horizontal,
                                      fillColor: const Color.fromRGBO(226, 223, 204, 1),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 350),
                                  reverseTransitionDuration: const Duration(milliseconds: 350),
                                ),
                              );
                            });
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.edit_outlined,
                          title: "Уточнити контактні дані",
                          onTap: () {
                            final navigator = Navigator.of(context, rootNavigator: true);
                            final extendedData = ExtendedData.fromUserData();
                            _closeModal();

                            Future.delayed(const Duration(milliseconds: 300), () {
                              navigator.push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      ExtendedDataReviewPage(data: extendedData),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.horizontal,
                                      fillColor: const Color.fromRGBO(226, 223, 204, 1),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 350),
                                  reverseTransitionDuration: const Duration(milliseconds: 350),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Widget _buildMenuItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
