import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/main_bloc.dart';
import '../bloc/main_event.dart';
import '../bloc/main_state.dart';
import 'vacancies_screen.dart';
import 'default_main_screen.dart';
import 'menu_screen.dart';

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
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
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
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildMainContent(MainLoaded state) {
    final screens = [
      const VacanciesScreen(),
      const DefaultMainScreen(),
      const MenuScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[state.navigationState.selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(state),
    );
  }

  Widget _buildBottomNavigationBar(MainLoaded state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Динамическая высота - 8% от высоты экрана (минимум 60, максимум 80)
    final navBarHeight = (screenHeight * 0.08).clamp(80.0, 80.0);

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
        currentIndex: state.navigationState.selectedIndex,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 2),
                        decoration: BoxDecoration(
                          color: state.navigationState.selectedIndex == 0
                              ? Colors.grey[300]
                                  ?.withOpacity(_opacityAnimation.value)
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
                children: [
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 2),
                        decoration: BoxDecoration(
                          color: state.navigationState.selectedIndex == 1
                              ? Colors.grey[300]
                                  ?.withOpacity(_opacityAnimation.value)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: state.navigationState.selectedIndex == 1
                            ? Icon(
                                Icons.insert_drive_file,
                                size: iconSize,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.insert_drive_file_outlined,
                                size: iconSize,
                                color: state.navigationState.selectedIndex == 1
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                      );
                    },
                  ),
                  Text(
                    "Документ",
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 2),
                            decoration: BoxDecoration(
                              color: state.navigationState.selectedIndex == 2
                                  ? Colors.grey[300]
                                      ?.withOpacity(_opacityAnimation.value)
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
                    const Positioned(
                      right: 7,
                      top: 1,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.red,
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
