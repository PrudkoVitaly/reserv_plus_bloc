import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import '../bloc/main_bloc.dart';
import '../bloc/main_event.dart';
import '../bloc/main_state.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancies_page.dart';
import 'package:reserv_plus/features/document/presentation/pages/document_page.dart';
import 'package:reserv_plus/features/menu/presentation/pages/menu_screen.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_state.dart';
import 'package:reserv_plus/features/shared/services/bottom_nav_bar_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late AnimationController _navBarAnimationController;
  late Animation<double> _navBarSlideAnimation;
  final _bottomNavBarController = BottomNavBarController();

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

    // Анимация для скрытия/показа BottomNavigationBar
    _navBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _navBarSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _navBarAnimationController,
      curve: Curves.easeInOut,
    ));

    // Слушаем изменения видимости BottomNavigationBar
    _bottomNavBarController.addListener(_onNavBarVisibilityChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  void _onNavBarVisibilityChanged() {
    if (_bottomNavBarController.isVisible) {
      _navBarAnimationController.reverse();
    } else {
      _navBarAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _bottomNavBarController.removeListener(_onNavBarVisibilityChanged);
    _animationController.dispose();
    _navBarAnimationController.dispose();
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
      const DocumentPage(key: ValueKey('document')),
      const VacanciesPage(key: ValueKey('vacancies')),
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
            ? const DocumentPage(key: ValueKey('document'))
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

    return AnimatedBuilder(
      animation: _navBarSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, navBarHeight * _navBarSlideAnimation.value),
          child: child,
        );
      },
      child: SizedBox(
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
                        child: Image.asset(
                          (state.navigationState.selectedIndex == 0 ||
                                  state.navigationState.selectedIndex == -1)
                              ? 'images/reserv_id_botom_nav_bar_icon.png'
                              : 'images/reserv_id_botom_nav_bar_roginal_icon.png',
                          width: iconSize,
                          height: iconSize,
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
                      fontWeight: (state.navigationState.selectedIndex == 0 ||
                              state.navigationState.selectedIndex == -1)
                          ? FontWeight.w900
                          : FontWeight.w500,
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
                        child: Image.asset(
                          state.navigationState.selectedIndex == 1
                              ? 'images/vacancies_botom_nav_bar__black_icon.png'
                              : 'images/vacancies_botom_nav_bar_icon.png',
                          width: iconSize,
                          height: iconSize,
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
                      fontWeight: state.navigationState.selectedIndex == 1
                          ? FontWeight.w900
                          : FontWeight.w500,
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
                            child: Image.asset(
                              'images/menu_botom_nav_bar_icon.png',
                              width: iconSize,
                              height: iconSize,
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
                          fontWeight: state.navigationState.selectedIndex == 2
                              ? FontWeight.w900
                              : FontWeight.w500,
                        ),
                      ),
                    ],
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
      ),
    );
  }
}
