import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/main/presentation/pages/main_page.dart';
import '../bloc/registry_bloc.dart';
import '../bloc/registry_event.dart';
import '../bloc/registry_state.dart';

class RegistryPage extends StatefulWidget {
  const RegistryPage({super.key});

  @override
  State<RegistryPage> createState() => _RegistryPageState();
}

class _RegistryPageState extends State<RegistryPage> {
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
                SizedBox(height: isSmallScreen ? 10.0 : 20.0),
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
                SizedBox(height: isSmallScreen ? 15.0 : 30.0),
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
                SizedBox(height: isSmallScreen ? 10.0 : 20.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<RegistryBloc, RegistryState>(
          builder: (context, state) {
            int currentIndex = 0;
            if (state is RegistryLoading) {
              currentIndex = state.currentTabIndex;
            } else if (state is RegistrySuccess) {
              currentIndex = state.currentTabIndex;
            } else if (state is RegistryError) {
              currentIndex = state.currentTabIndex;
            }

            return _buildBottomNavigationBar(currentIndex);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingContent(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
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
          SizedBox(height: isSmallScreen ? 15.0 : 20.0),
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
          SizedBox(height: isSmallScreen ? 20.0 : 30.0),
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

  Widget _buildBottomNavigationBar(int currentIndex) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        context.read<RegistryBloc>().add(RegistryNavigationChanged(index));
      },
      items: [
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Icon(
                Icons.work_outline,
                size: 24,
                color: currentIndex == 0 ? Colors.black : Colors.grey,
              ),
              Text(
                "Вакансії",
                style: TextStyle(
                  fontSize: 14,
                  color: currentIndex == 0 ? Colors.black : Colors.grey,
                  fontWeight:
                      currentIndex == 0 ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Icon(
                Icons.insert_drive_file_outlined,
                size: 24,
                color: currentIndex == 1 ? Colors.black : Colors.grey,
              ),
              Text(
                "Мій документ",
                style: TextStyle(
                  fontSize: 14,
                  color: currentIndex == 1 ? Colors.black : Colors.grey,
                  fontWeight:
                      currentIndex == 1 ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.menu,
                    size: 24,
                    color: currentIndex == 2 ? Colors.black : Colors.grey,
                  ),
                  Text(
                    "Меню",
                    style: TextStyle(
                      fontSize: 14,
                      color: currentIndex == 2 ? Colors.black : Colors.grey,
                      fontWeight:
                          currentIndex == 2 ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
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
          label: '',
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
