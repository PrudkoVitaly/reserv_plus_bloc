import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import '../bloc/main_bloc.dart';
import '../bloc/main_event.dart';
import '../bloc/main_state.dart';
import 'vacancies_screen.dart';
import 'default_main_screen.dart';
import 'menu_screen.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(const MainInitialized());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, notificationState) {
        // Когда уведомления загружены или обновлены, обновляем состояние MainBloc
        if (notificationState is NotificationLoaded) {
          context.read<MainBloc>().add(const MainNotificationsUpdated());
        }
      },
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoading) {
            return const Scaffold(
              body: DelayedLoadingIndicator(),
            );
          } else if (state is MainError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Помилка: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainBloc>().add(const MainInitialized());
                      },
                      child: const Text('Спробувати знову'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MainLoaded) {
            return _buildMainContent(state);
          } else {
            return const Scaffold(
              body: DelayedLoadingIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildMainContent(MainLoaded state) {
    final screens = [
      const DefaultMainScreen(key: ValueKey('document')),
      const VacanciesScreen(key: ValueKey('vacancies')),
      const MenuScreen(key: ValueKey('menu')),
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 700),
        reverse: false,
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          // Применяем кастомную кривую для более заметного эффекта
          final curvedPrimaryAnimation = CurvedAnimation(
            parent: primaryAnimation,
            curve: Curves.easeInOut,
          );
          final curvedSecondaryAnimation = CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOut,
          );

          return SharedAxisTransition(
            animation: curvedPrimaryAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: const Color.fromRGBO(226, 223, 204, 1),
            child: child,
          );
        },
        child: state.navigationState.selectedIndex == -1
            ? const DefaultMainScreen(key: ValueKey('document'))
            : screens[state.navigationState.selectedIndex.clamp(0, 2)],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(state),
    );
  }

  Widget _buildBottomNavigationBar(MainLoaded state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final navBarHeight = (screenHeight * 0.10).clamp(80.0, 100.0);
    final iconSize = (screenWidth * 0.06).clamp(24.0, 28.0);
    final textSize = (screenWidth * 0.03).clamp(12.0, 14.0);

    return SizedBox(
      height: navBarHeight,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: state.navigationState.selectedIndex == -1
            ? 0
            : state.navigationState.selectedIndex.clamp(0, 2),
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          context.read<MainBloc>().add(MainNavigationChanged(index));
        },
        items: [
          // Резерв ID (index 0)
          BottomNavigationBarItem(
            icon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _startAnimation();
                context.read<MainBloc>().add(const MainNavigationChanged(0));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: (state.navigationState.selectedIndex == 0 ||
                                  state.navigationState.selectedIndex == -1)
                              ? Colors.grey[300]
                                  ?.withValues(alpha: _opacityAnimation.value)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          (state.navigationState.selectedIndex == 0 ||
                                  state.navigationState.selectedIndex == -1)
                              ? Icons.credit_card
                              : Icons.credit_card_outlined,
                          size: iconSize,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Резерв ID",
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          // Вакансії (index 1)
          BottomNavigationBarItem(
            icon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _startAnimation();
                context.read<MainBloc>().add(const MainNavigationChanged(1));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: state.navigationState.selectedIndex == 1
                              ? Colors.grey[300]
                                  ?.withValues(alpha: _opacityAnimation.value)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          state.navigationState.selectedIndex == 1
                              ? Icons.diamond
                              : Icons.diamond_outlined,
                          size: iconSize,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Вакансії",
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          // Меню (index 2)
          BottomNavigationBarItem(
            icon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _startAnimation();
                context.read<MainBloc>().add(const MainNavigationChanged(2));
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _opacityAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: state.navigationState.selectedIndex == 2
                                  ? Colors.grey[300]
                                      ?.withValues(alpha: _opacityAnimation.value)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.dehaze,
                              size: iconSize,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Меню",
                        style: TextStyle(
                          fontSize: textSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (state.navigationState.hasNotifications)
                    Positioned(
                      right: 14,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            label: '',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
