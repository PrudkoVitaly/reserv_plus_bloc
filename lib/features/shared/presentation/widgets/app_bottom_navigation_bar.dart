import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_event.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_state.dart';
import 'package:reserv_plus/features/shared/services/bottom_nav_bar_controller.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final bool enableHideAnimation;
  final bool enableHighlightAnimation; // Подсветка при нажатии на кнопку

  const AppBottomNavigationBar({
    super.key,
    this.enableHideAnimation = false,
    this.enableHighlightAnimation = true, // По умолчанию включена
  });

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late AnimationController _navBarAnimationController;
  late Animation<double> _navBarSlideAnimation;

  final _bottomNavBarController = BottomNavBarController();

  @override
  void initState() {
    super.initState();
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

    if (widget.enableHideAnimation) {
      _bottomNavBarController.addListener(_onNavBarVisibilityChanged);
    }

    // Запускаем анимацию сразу, чтобы подсветка плавно исчезла при первом входе
    // Только если подсветка включена
    if (widget.enableHighlightAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimation();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheNavBarImages();
  }

  void _precacheNavBarImages() {
    final images = [
      'images/reserv_id_botom_nav_bar_icon.png',
      'images/reserv_id_botom_nav_bar_roginal_icon.png',
      'images/vacancies_botom_nav_bar__black_icon.png',
      'images/vacancies_botom_nav_bar_icon.png',
      'images/menu_botom_nav_bar_icon.png',
    ];

    for (final image in images) {
      precacheImage(AssetImage(image), context);
    }
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
    if (widget.enableHideAnimation) {
      _bottomNavBarController.removeListener(_onNavBarVisibilityChanged);
    }
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
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainLoaded) {
          return _buildBottomNavigationBar(state);
        }
        return _buildBottomNavigationBar(null);
      },
    );
  }

  Widget _buildBottomNavigationBar(MainLoaded? state) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Адаптивные размеры с ограничениями min/max
    final iconSize = (screenWidth * 0.06).clamp(24.0, 28.0);
    final textSize = (screenWidth * 0.03).clamp(12.0, 14.0);
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 18.0);

    final selectedIndex = state?.navigationState.selectedIndex ?? -1;

    final navBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: selectedIndex == -1 ? 0 : selectedIndex.clamp(0, 2),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      decoration: BoxDecoration(
                        // Подсветка только если enableHighlightAnimation = true
                        // и пользователь реально нажал на кнопку (не -1)
                        color: widget.enableHighlightAnimation && selectedIndex == 0
                            ? Colors.grey[300]
                                ?.withValues(alpha: _opacityAnimation.value)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        (selectedIndex == 0 || selectedIndex == -1)
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
                    fontWeight: (selectedIndex == 0 || selectedIndex == -1)
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
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      decoration: BoxDecoration(
                        // Подсветка только если enableHighlightAnimation = true
                        color: widget.enableHighlightAnimation &&
                                selectedIndex == 1
                            ? Colors.grey[300]
                                ?.withValues(alpha: _opacityAnimation.value)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        selectedIndex == 1
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
                    fontWeight:
                        selectedIndex == 1 ? FontWeight.w900 : FontWeight.w500,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _opacityAnimation,
                  builder: (context, child) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      decoration: BoxDecoration(
                        // Подсветка только если enableHighlightAnimation = true
                        color: widget.enableHighlightAnimation &&
                                selectedIndex == 2
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
                    fontWeight:
                        selectedIndex == 2 ? FontWeight.w900 : FontWeight.w500,
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
    );

    if (widget.enableHideAnimation) {
      return AnimatedBuilder(
        animation: _navBarSlideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 80 * _navBarSlideAnimation.value),
            child: child,
          );
        },
        child: navBar,
      );
    }

    return navBar;
  }
}
