import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reserv_plus/features/support/presentation/bloc/support_bloc.dart';
import 'package:reserv_plus/features/support/presentation/bloc/support_event.dart';
import 'package:reserv_plus/features/support/data/repositories/support_repository_impl.dart';
import 'package:reserv_plus/features/support/presentation/pages/support_page.dart';
import 'package:reserv_plus/features/faq/presentation/pages/faq_list_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/document/presentation/utils/modal_utils.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_state.dart';
import 'package:reserv_plus/features/menu/presentation/pages/fix_data/fix_data_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(
        repository: SupportRepositoryImpl(),
      ),
      child: const MenuScreenView(),
    );
  }
}

class MenuScreenView extends StatefulWidget {
  const MenuScreenView({super.key});

  @override
  State<MenuScreenView> createState() => _MenuScreenViewState();
}

class _MenuScreenViewState extends State<MenuScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showSuccessIcon = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Анимация масштаба: быстрое появление, задержка 0.8 сек, быстрое исчезновение
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 16.7,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 66.6,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 16.7,
      ),
    ]).animate(_animationController);

    // Анимация прозрачности: быстрое появление и исчезновение
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 12.5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 75.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 12.5,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
      });
    }
  }

  void _onCopyDeviceNumber() {
    setState(() {
      _showSuccessIcon = true;
    });

    _animationController.forward().then((_) {
      setState(() {
        _showSuccessIcon = false;
      });
      _animationController.reset();
    });

    // Отправляем событие в BLoC
    context.read<SupportBloc>().add(const SupportCopyDeviceNumber());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фиксированный заголовок
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
              ),
              child: _buildHeader(),
            ),
            // Прокручиваемый список
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      _buildMenuItems(context),
                      const SizedBox(height: 16),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Меню',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Версія $_appVersion',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(106, 103, 88, 1),
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, mainState) {
        return Column(
          children: [
            // Группа 1: Виправити дані, Штрафи
            _buildMenuCard([
              MenuItem(
                imagePath: 'images/fix_data_icon.png',
                title: 'Виправити дані\nонлайн',
                onTap: () {
                  NavigationUtils.pushWithHorizontalAnimation(
                    context: context,
                    page: const FixDataPage(),
                  );
                },
              ),
              MenuItem(
                imagePath: 'images/fines_icon.png',
                title: 'Штрафи',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 8),
            // Группа 2: Активні сесії, Налаштування
            _buildMenuCard([
              MenuItem(
                imagePath: 'images/sessions_icon.png',
                title: 'Активні сесії',
                onTap: () {},
              ),
              MenuItem(
                imagePath: 'images/settings_icon.png',
                title: 'Налаштування',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 8),
            // Группа 3: Питання та відповіді
            _buildMenuCard([
              MenuItem(
                imagePath: 'images/faq_icon.png',
                title: 'Питання та відповіді',
                onTap: () {
                  NavigationUtils.pushWithHorizontalAnimation(
                    context: context,
                    page: const FaqListPage(),
                  );
                },
              ),
              MenuItem(
                imagePath: 'images/support_icon.png',
                title: 'Служба підтримки',
                onTap: () {
                  NavigationUtils.pushWithHorizontalAnimation(
                    context: context,
                    page: const SupportPage(),
                  );
                },
              ),
              MenuItem(
                imagePath: 'images/copy_device_icon.png',
                title: 'Копіювати номер пристрою',
                isCopyButton: true,
                onTap: _onCopyDeviceNumber,
              ),
            ]),
            const SizedBox(height: 8),
            // Группа 4: Сканувати документ
            _buildMenuCard([
              MenuItem(
                imagePath: 'images/scan_document_icon.png',
                title: 'Сканувати документ',
                hideChevron: true,
                onTap: () {
                  ModalUtils.showDocumentScanOptions(context);
                },
              ),
            ]),
            const SizedBox(height: 20),
            _buildButtonLogout(),
            const SizedBox(height: 12),
            _textPersonalData(context),
          ],
        );
      },
    );
  }

  Widget _buildMenuCard(List<MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildMenuItem(item),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            // Для кнопки копирования: иконка copy или анимированная галочка
            if (item.isCopyButton)
              _showSuccessIcon
                  ? AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : item.imagePath != null
                      ? Image.asset(
                          item.imagePath!,
                          width: 32,
                          height: 32,
                        )
                      : Icon(
                          item.icon,
                          size: 32,
                          color: Colors.black87,
                        )
            // Для остальных пунктов - иконка или изображение с notification badge
            else
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (item.imagePath != null)
                    Image.asset(
                      item.imagePath!,
                      width: 30,
                      height: 30,
                    )
                  else
                    Icon(
                      item.icon,
                      size: 30,
                      color: Colors.black87,
                    ),
                  if (item.hasNotification)
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
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1,
                ),
              ),
            ),
            // Для обычных пунктов показываем chevron
            if (!item.isCopyButton && !item.hideChevron)
              const Icon(
                CupertinoIcons.chevron_right,
                size: 23,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonLogout() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(200, 0, 0, 0),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Text(
        'Вийти',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _textPersonalData(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationUtils.pushWithHorizontalAnimation(
          context: context,
          page: const FaqListPage(),
        );
      },
      child: const Text(
        'Повідомлення про обробку персональних даних',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black,
          decorationThickness: 1,
          height: 1,
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final VoidCallback onTap;
  final bool hasNotification;
  final bool isCopyButton;
  final bool hideChevron;

  MenuItem({
    this.icon,
    this.imagePath,
    required this.title,
    required this.onTap,
    this.hasNotification = false,
    this.isCopyButton = false,
    this.hideChevron = false,
  });
}
