import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_bloc.dart';
import 'package:reserv_plus/features/main/presentation/bloc/main_event.dart';
import 'package:reserv_plus/features/main/presentation/pages/main_page.dart';
import 'package:reserv_plus/features/notifications/presentation/pages/notification_page.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import '../bloc/registry_bloc.dart';
import '../bloc/registry_event.dart';
import '../bloc/registry_state.dart';

class RegistryPage extends StatelessWidget {
  const RegistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Инициализируем глобальный MainBloc
    context.read<MainBloc>().add(const MainInitialized());
    return const RegistryView();
  }
}

class RegistryView extends StatefulWidget {
  const RegistryView({super.key});

  @override
  State<RegistryView> createState() => _RegistryViewState();
}

class _RegistryViewState extends State<RegistryView> {
  @override
  void initState() {
    super.initState();
    // Запускаем загрузку данных
    context.read<RegistryBloc>().add(const RegistryLoadData());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final isSmallScreen = screenHeight < 700;

    return BlocListener<RegistryBloc, RegistryState>(
      listener: (context, state) {
        if (state is RegistrySuccess) {
          // Переходим на главный экран и очищаем весь стек навигации
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
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
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        NavigationUtils.pushWithHorizontalAnimation(
                          context: context,
                          page: const NotificationPage(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
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
                            Image.asset(
                              "images/notification_bell.png",
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
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
        bottomNavigationBar: const AppBottomNavigationBar(
          enableHighlightAnimation: false, // Без подсветки на экране загрузки
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
}
