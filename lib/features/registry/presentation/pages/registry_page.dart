import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_event.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_state.dart';
import 'package:reserv_plus/features/main/domain/entities/navigation_state.dart';
import 'package:reserv_plus/features/main/data/repositories/navigation_repository_impl.dart';
import 'package:reserv_plus/features/main/presentation/pages/main_page.dart';
import '../bloc/registry_bloc.dart';
import '../bloc/registry_event.dart';
import '../bloc/registry_state.dart';

class RegistryPage extends StatelessWidget {
  const RegistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(
        repository: NavigationRepositoryImpl(),
      )..add(const MainInitialized()),
      child: const RegistryView(),
    );
  }
}

class RegistryView extends StatefulWidget {
  const RegistryView({super.key});

  @override
  State<RegistryView> createState() => _RegistryViewState();
}

class _RegistryViewState extends State<RegistryView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Запускаем загрузку данных
    context.read<RegistryBloc>().add(const RegistryLoadData());

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
    Size size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final isSmallScreen = screenHeight < 700;

    return BlocListener<RegistryBloc, RegistryState>(
      listener: (context, state) {
        if (state is RegistrySuccess) {
          // Переходим на главный экран после успешной загрузки
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              children: [
                SizedBox(height: isSmallScreen ? 5.0 : 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          "Резерв",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24.0 : 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Positioned(
                          top: isSmallScreen ? 4 : 6,
                          right: isSmallScreen ? -16 : -20,
                          child: Image.asset(
                            "images/res_plus.png",
                            width: isSmallScreen ? 16.0 : 20.0,
                            color: const Color.fromRGBO(253, 135, 12, 1),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "Сканувати \nдокумент",
                            style: TextStyle(
                              height: 1,
                              fontSize: isSmallScreen ? 14.0 : 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          "images/qr.png",
                          width: isSmallScreen ? 25.0 : 30.0,
                        ),
                      ],
                    ),
                    // Flexible(
                    //   child: Text(
                    //     "Сканувати \nдокумент",
                    //     style: TextStyle(
                    //       height: 1,
                    //       fontSize: isSmallScreen ? 14.0 : 16.0,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //     textAlign: TextAlign.right,
                    //   ),
                    // ),
                    // const SizedBox(width: 6),
                    // Image.asset(
                    //   "images/qr.png",
                    //   width: isSmallScreen ? 25.0 : 30.0,
                    // ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 5.0 : 10.0),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromRGBO(156, 152, 135, 1),
                        width: 1.5,
                      ),
                      color: const Color.fromRGBO(212, 210, 189, 1),
                    ),
                    child: BlocBuilder<RegistryBloc, RegistryState>(
                      builder: (context, state) {
                        if (state is RegistryLoading) {
                          return _buildLoadingContent(isSmallScreen);
                        } else if (state is RegistryError) {
                          return _buildErrorContent(
                              state.message, isSmallScreen);
                        } else {
                          return _buildLoadingContent(isSmallScreen);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2.0 : 5.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state is MainLoaded) {
              return _buildBottomNavigationBar(state);
            }
            return _buildBottomNavigationBar(const MainLoaded(
              NavigationState(
                selectedIndex: -1,
                isContainerVisible: false,
                hasNotifications: true,
              ),
            ));
          },
        ),
      ),
    );
  }

  Widget _buildLoadingContent(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: isSmallScreen ? 50.0 : 60.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/logo_invert.webp"),
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(212, 210, 189, 1),
                  BlendMode.modulate,
                ),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 12.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              textAlign: TextAlign.center,
              "Отримуємо\nінформацію з\nреєстру",
              style: TextStyle(
                fontSize: isSmallScreen ? 30.0 : 38.0,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Поки ми шукаємо дані -\nперегляньте вакансії у Силах\nоборони",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18.0 : 22.0,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String message, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: isSmallScreen ? 60.0 : 80.0,
            color: Colors.red,
          ),
          SizedBox(height: isSmallScreen ? 15.0 : 20.0),
          Text(
            "Помилка завантаження",
            style: TextStyle(
              fontSize: isSmallScreen ? 20.0 : 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 10.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isSmallScreen ? 14.0 : 16.0),
          ),
          SizedBox(height: isSmallScreen ? 15.0 : 20.0),
          ElevatedButton(
            onPressed: () {
              context.read<RegistryBloc>().add(const RegistryRetry());
            },
            child: const Text("Спробувати знову"),
          ),
        ],
      ),
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
        currentIndex: state.navigationState.selectedIndex.clamp(0, 2),
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
                      right: 20,
                      top: 4,
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
