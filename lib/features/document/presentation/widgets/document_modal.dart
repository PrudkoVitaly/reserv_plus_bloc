import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';

class DocumentModal extends StatefulWidget {
  const DocumentModal({super.key});

  @override
  State<DocumentModal> createState() => _DocumentModalState();
}

class _DocumentModalState extends State<DocumentModal> {
  bool _isContainerVisible = false;

  // Функция для показа и скрытия контейнера
  void _toggleContainer() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state is DocumentLoaded && state.isModalVisible) {
          // Устанавливаем состояние видимости контейнера
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isContainerVisible = true;
              });
            }
          });
          return _buildModalContent(context);
        } else if (state is DocumentLoaded &&
            !state.isModalVisible &&
            _isContainerVisible) {
          // Если модальное окно закрыто, но контейнер еще видим, показываем анимацию закрытия
          return _buildModalContent(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildModalContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black
          .withOpacity(0.5), // Полностью затемненный фон на весь экран
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Сначала скрываем контейнер с анимацией
          setState(() {
            _isContainerVisible = false;
          });
          // Затем закрываем модальное окно после анимации
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              // Сбрасываем состояние контейнера
              setState(() {
                _isContainerVisible = false;
              });
              context
                  .read<DocumentBloc>()
                  .add(const DocumentToggleModal(false));
            }
          });
        },
        child: Stack(
          children: [
            // Анимация для контейнера
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isContainerVisible
                  ? 0
                  : -600, // Контейнер появляется снизу и доходит до самого низа
              left: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Ничего не делаем при клике на контейнер
                },
                onPanStart: (details) {
                  // Начинаем отслеживание перетаскивания
                },
                onPanUpdate: (details) {
                  // Обрабатываем вертикальное перетаскивание вниз
                  if (details.delta.dy > 0) {
                    // Перетаскивание вниз - можно добавить визуальную обратную связь
                  }
                },
                onPanEnd: (details) {
                  // Проверяем, достаточно ли быстро перетащили вниз
                  if (details.velocity.pixelsPerSecond.dy > 100) {
                    // Свайп вниз - закрываем контейнер
                    setState(() {
                      _isContainerVisible = false;
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        context
                            .read<DocumentBloc>()
                            .add(const DocumentToggleModal(false));
                      }
                    });
                  }
                },
                // Container with menu items
                child: Container(
                  margin: const EdgeInsets.all(16), // Возвращаем отступы
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          // Сначала скрываем контейнер с анимацией
                          setState(() {
                            _isContainerVisible = false;
                          });
                          // Затем закрываем модальное окно после анимации
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              // Сбрасываем состояние контейнера
                              setState(() {
                                _isContainerVisible = false;
                              });
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentToggleModal(false));
                              // Здесь можно добавить навигацию к полному просмотру документа
                            }
                          });
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.share,
                        title: "Поділитися документом",
                        onTap: () {
                          // Сначала скрываем контейнер с анимацией
                          setState(() {
                            _isContainerVisible = false;
                          });
                          // Затем закрываем модальное окно после анимации
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              // Сбрасываем состояние контейнера
                              setState(() {
                                _isContainerVisible = false;
                              });
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentShareDocument());
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentToggleModal(false));
                            }
                          });
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.refresh,
                        title: "Оновити документ",
                        onTap: () {
                          // Сначала скрываем контейнер с анимацией
                          setState(() {
                            _isContainerVisible = false;
                          });
                          // Затем закрываем модальное окно после анимации
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              // Сбрасываем состояние контейнера
                              setState(() {
                                _isContainerVisible = false;
                              });
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentUpdateData());
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentToggleModal(false));
                            }
                          });
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.add_circle_outline,
                        title: "Розширені дані з реєстру",
                        onTap: () {
                          // Сначала скрываем контейнер с анимацией
                          setState(() {
                            _isContainerVisible = false;
                          });
                          // Затем закрываем модальное окно после анимации
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              // Сбрасываем состояние контейнера
                              setState(() {
                                _isContainerVisible = false;
                              });
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentToggleModal(false));
                              // Здесь можно добавить навигацию к расширенным данным
                            }
                          });
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.medical_services_outlined,
                        title: "Направлення на ВЛК",
                        onTap: () {
                          // Сначала скрываем контейнер с анимацией
                          setState(() {
                            _isContainerVisible = false;
                          });
                          // Затем закрываем модальное окно после анимации
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              // Сбрасываем состояние контейнера
                              setState(() {
                                _isContainerVisible = false;
                              });
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentToggleModal(false));
                              // Здесь можно добавить навигацию к направлению на ВЛК
                            }
                          });
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.edit_outlined,
                        title: "Уточнити контактні дані",
                        onTap: () {
                          // Сначала скрываем контейнер с анимацией
                          setState(() {
                            _isContainerVisible = false;
                          });
                          // Затем закрываем модальное окно после анимации
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              // Сбрасываем состояние контейнера
                              setState(() {
                                _isContainerVisible = false;
                              });
                              context
                                  .read<DocumentBloc>()
                                  .add(const DocumentToggleModal(false));
                              // Здесь можно добавить навигацию к редактированию контактов
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 24,
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
}
