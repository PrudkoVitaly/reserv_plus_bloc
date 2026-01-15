import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:intl/intl.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';
import '../utils/modal_utils.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/qr_scanner/presentation/pages/qr_scanner_page.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_state.dart';
import 'package:reserv_plus/features/notifications/presentation/pages/notification_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Инициализация контроллера анимации
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Анимация вращения
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация масштабирования
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Загружаем данные документа
    context.read<DocumentBloc>().add(const DocumentLoadData());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Извлекает дату из строки и добавляет 1 год (элегантный подход с intl)
  String _getDateWithAddedYear(String dateString) {
    final dateMatch = RegExp(r'\d{2}\.\d{2}\.\d{4}').firstMatch(dateString);
    if (dateMatch == null) return dateString;

    try {
      final date = DateFormat('dd.MM.yyyy').parse(dateMatch.group(0)!);
      final datePlusYear = DateTime(date.year + 1, date.month, date.day);
      return DateFormat('dd.MM.yyyy').format(datePlusYear);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        // Навигация к QR сканеру
        if (state is DocumentNavigateToScanner) {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const QRScannerPage(),
            ),
          )
              .then((result) {
            // Обработка результата сканирования
            if (result != null) {
              // Здесь можно добавить обработку результата
            }
            // Восстанавливаем предыдущее состояние документа
            if (!mounted) return;
            context.read<DocumentBloc>().add(const DocumentLoadData());
          });
        }

        if (state is DocumentLoaded) {
          if (state.isFlipping) {
            if (state.isFrontVisible) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          } else {
            // Синхронизируем контроллер с текущим состоянием
            if (state.isFrontVisible && _controller.value > 0.5) {
              _controller.reverse();
            } else if (!state.isFrontVisible && _controller.value < 0.5) {
              _controller.forward();
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: BlocBuilder<DocumentBloc, DocumentState>(
          builder: (context, state) {
            if (state is DocumentLoading) {
              // Показываем индикатор только если загрузка длится > 200ms
              return const DelayedLoadingIndicator();
            } else if (state is DocumentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    Text('Помилка: ${state.message}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<DocumentBloc>()
                            .add(const DocumentLoadData());
                      },
                      child: const Text('Спробувати знову'),
                    ),
                  ],
                ),
              );
            } else if (state is DocumentLoaded) {
              return _buildDocumentContent(state, size);
            } else {
              // DocumentInitial - показываем индикатор с задержкой
              return const DelayedLoadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDocumentContent(DocumentLoaded state, Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 60),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildDocumentCard(state, size),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, mainState) {
        final hasNotifications = mainState is MainLoaded
            ? mainState.navigationState.hasNotifications
            : false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Кнопка Сповіщення справа
            GestureDetector(
              onTap: () {
                NavigationUtils.pushWithHorizontalAnimation(
                  context: context,
                  page: const NotificationPage(),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Сповіщення",
                      style: TextStyle(
                        height: 1,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          "images/notification_bell.png",
                          width: 18,
                          height: 18,
                        ),
                        if (hasNotifications)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocumentCard(DocumentLoaded state, Size size) {
    return GestureDetector(
      onTap: () {
        context.read<DocumentBloc>().add(const DocumentFlipCard());
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _rotationAnimation.value * 3.1415926535897932;
          final isFrontVisible = angle <= 3.1415926535897932 / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: isFrontVisible
                  ? _buildFrontCard(state, size)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1415926535897932),
                      child: _buildBackCard(state, size),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(DocumentLoaded state, Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(156, 152, 135, 1),
          width: 1.5,
        ),
        color: const Color.fromRGBO(212, 210, 189, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Резерв ID",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        // height: 1.0,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/logo_main_screen.jpg"),
                          colorFilter: ColorFilter.mode(
                            Color.fromRGBO(212, 210, 189, 1),
                            BlendMode.difference,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
                // Row(
                //   children: [
                //     Image.asset("images/ok_icon.png", width: 18),
                //     const SizedBox(width: 10),
                //     const Text(
                //       "Дані уточнено вчасно",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         height: 1.1,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 6),
                const Text(
                  "Дата народження:",
                  style: TextStyle(
                    color: Color.fromRGBO(106, 103, 88, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.data.birthDate,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    wordSpacing: 0.1,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.28),
          _buildMarqueeStrip(state),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.data.status,
                        style: const TextStyle(
                          color: Color.fromRGBO(106, 103, 88, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          // height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.data.lastName.toUpperCase()}\n${state.data.firstName}\n${state.data.patronymic}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                    shape: const CircleBorder(),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ModalUtils.showDocumentModal(context);
                  },
                  child: const Icon(
                    Icons.add_outlined,
                    size: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarqueeStrip(DocumentLoaded state) {
    // Текст и цвет зависят от состояния обновления
    final isUpdating = state.isUpdating;
    final backgroundColor = isUpdating
        ? const Color.fromRGBO(255, 235, 59, 1) // Жёлтый
        : const Color.fromRGBO(150, 148, 134, 1); // Серый
    final marqueeText = isUpdating
        ? " • Оновлюємо документ • Впораємось за пару годин • Дякуємо за терпіння!"
        : " • ${state.data.formattedLastUpdated}";

    return Container(
      width: double.infinity,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Marquee(
        key: ValueKey(isUpdating),
        text: marqueeText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          height: 0.1,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        velocity: isUpdating ? 40.0 : 20.0,
        startPadding: 10.0,
      ),
    );
  }

  Widget _buildBackCard(DocumentLoaded state, Size size) {
    final displayDate = _getDateWithAddedYear(state.data.formattedLastUpdated);

    return Container(
      width: double.infinity,
      height: size.height * 0.65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(156, 152, 135, 1),
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Код дійсний до $displayDate",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(state.data.qrCode, width: 260),
          ],
        ),
      ),
    );
  }
}
