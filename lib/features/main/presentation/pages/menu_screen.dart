import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/pages/notification_page.dart';
import 'package:reserv_plus/features/shared/services/user_data_service.dart';
import 'package:reserv_plus/features/support/presentation/bloc/support_bloc.dart';
import 'package:reserv_plus/features/support/presentation/bloc/support_event.dart';
import 'package:reserv_plus/features/support/data/repositories/support_repository_impl.dart';
import 'package:reserv_plus/features/support/presentation/pages/support_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

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

  @override
  void initState() {
    super.initState();

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
    final userData = UserDataService();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(userData),
                const SizedBox(height: 26),
                _buildMenuItems(context),
                const Divider(
                  color: Color.fromARGB(255, 189, 189, 189),
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                _buildAdditionalActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(UserDataService userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Вітаємо,',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
        Text(
          userData.firstName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      MenuItem(
        icon: CupertinoIcons.bell,
        title: 'Сповіщення',
        hasNotification: true,
        onTap: () {
          NavigationUtils.pushWithHorizontalAnimation(
            context: context,
            page: const NotificationPage(),
          );
        },
      ),
      MenuItem(
        icon: CupertinoIcons.question_circle,
        title: 'Питання та відповіді',
        onTap: () {},
      ),
      MenuItem(
        icon: CupertinoIcons.search_circle,
        title: 'Штрафи онлайн',
        onTap: () {},
      ),
      MenuItem(
        icon: CupertinoIcons.exclamationmark_circle,
        title: 'Виправити дані онлайн',
        onTap: () {},
      ),
      MenuItem(
        icon: CupertinoIcons.device_phone_portrait,
        title: 'Активні сесії',
        onTap: () {},
      ),
      MenuItem(
        icon: CupertinoIcons.gear_alt,
        title: 'Налаштування',
        onTap: () {},
      ),
      MenuItem(
        icon: CupertinoIcons.arrow_right_square,
        title: 'Вийти',
        onTap: () {},
      ),
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(item)).toList(),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    item.icon,
                    size: 24,
                    color: Colors.black87,
                  ),
                  if (item.hasNotification)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromRGBO(226, 223, 204, 1),
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
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedCopyButton(),
        const SizedBox(height: 30),
        _buildAdditionalAction(
          'Служба підтримки',
          () {
            NavigationUtils.pushWithHorizontalAnimation(
              context: context,
              page: const SupportPage(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedCopyButton() {
    return GestureDetector(
      onTap: _onCopyDeviceNumber,
      child: Row(
        children: [
          const Text(
            'Копіювати номер пристрою',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),

          // Анимированная иконка успеха
          if (_showSuccessIcon)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAdditionalAction(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool hasNotification;

  MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.hasNotification = false,
  });
}
