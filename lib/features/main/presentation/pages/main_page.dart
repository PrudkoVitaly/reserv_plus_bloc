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
    // Инициализируем BLoC
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

    // Запускаем анимацию для кнопки "Документ" при первой загрузке
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
      const VacanciesScreen(key: ValueKey('vacancies')),
      const DefaultMainScreen(key: ValueKey('document')),
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
            : screens[state.navigationState.selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(state),
    );
  }

  Widget _buildBottomNavigationBar(MainLoaded state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Динамическая высота - 10% от высоты экрана (минимум 90, максимум 100)
    final navBarHeight = (screenHeight * 0.10).clamp(80.0, 100.0);

    // Динамический размер иконок - 5% от ширины экрана
    final iconSize = (screenWidth * 0.05).clamp(24.0, 24.0);

    // Динамический размер текста - 3% от ширины экрана
    final textSize = (screenWidth * 0.03).clamp(12.0, 14.0);

    return SizedBox(
      height: navBarHeight,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: state.navigationState.isContainerVisible
            ? const Color.fromRGBO(106, 105, 94, 1)
            : Colors.white,
        currentIndex: state.navigationState.selectedIndex == -1
            ? 1
            : state.navigationState.selectedIndex.clamp(0, 2),
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          context.read<MainBloc>().add(MainNavigationChanged(index));
        },
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _startAnimation();
                context.read<MainBloc>().add(const MainNavigationChanged(0));
              },
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: state.navigationState.selectedIndex == 0
                              ? Colors.grey[300]
                                  ?.withValues(alpha: _opacityAnimation.value)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: state.navigationState.selectedIndex == 0
                            ? Icon(
                                Icons.work,
                                size: iconSize,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.work_outline,
                                size: iconSize,
                                color: Colors.grey,
                              ),
                      );
                    },
                  ),
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
                          color: (state.navigationState.selectedIndex == 1 ||
                                  state.navigationState.selectedIndex == -1)
                              ? Colors.grey[300]
                                  ?.withValues(alpha: _opacityAnimation.value)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: (state.navigationState.selectedIndex == 1 ||
                                state.navigationState.selectedIndex == -1)
                            ? Icon(
                                Icons.insert_drive_file,
                                size: iconSize,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.insert_drive_file_outlined,
                                size: iconSize,
                                color: Colors.grey,
                              ),
                      );
                    },
                  ),
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
                    children: [
                      AnimatedBuilder(
                        animation: _opacityAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: state.navigationState.selectedIndex == 2
                                  ? Colors.grey[300]?.withValues(
                                      alpha: _opacityAnimation.value)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: state.navigationState.selectedIndex == 2
                                ? Icon(
                                    Icons.menu,
                                    size: iconSize,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.menu_outlined,
                                    size: iconSize,
                                    color: Colors.grey,
                                  ),
                          );
                        },
                      ),
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
                      right: 18,
                      top: 4,
                      child: Container(
                        width: 11,
                        height: 11,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.red,
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
