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
  @override
  void initState() {
    super.initState();
    // Инициализируем BLoC
    context.read<MainBloc>().add(const MainInitialized());
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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: state.navigationState.isContainerVisible
          ? const Color.fromRGBO(106, 105, 94, 1)
          : Colors.white,
      currentIndex: state.navigationState.selectedIndex,
      onTap: (index) {
        context.read<MainBloc>().add(MainNavigationChanged(index));
      },
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.read<MainBloc>().add(const MainNavigationChanged(0));
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.navigationState.selectedIndex == 0
                        ? Colors.grey[200]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: state.navigationState.selectedIndex == 0
                      ? const Icon(
                          Icons.work,
                          size: 24,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.work_outline,
                          size: 24,
                          color: Colors.grey,
                        ),
                ),
                const Text(
                  "Вакансії",
                  style: TextStyle(
                    fontSize: 14,
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
              context.read<MainBloc>().add(const MainNavigationChanged(1));
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.navigationState.selectedIndex == 1
                        ? Colors.grey[200]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: state.navigationState.selectedIndex == 1
                      ? const Icon(
                          Icons.insert_drive_file,
                          size: 24,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.insert_drive_file_outlined,
                          size: 24,
                          color: state.navigationState.selectedIndex == 1
                              ? Colors.black
                              : Colors.grey,
                        ),
                ),
                const Text(
                  "Документ",
                  style: TextStyle(
                    fontSize: 14,
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
              context.read<MainBloc>().add(const MainNavigationChanged(2));
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: state.navigationState.selectedIndex == 2
                            ? Colors.grey[200]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: state.navigationState.selectedIndex == 2
                          ? const Icon(
                              Icons.menu,
                              size: 24,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.menu_outlined,
                              size: 24,
                              color: Colors.grey,
                            ),
                    ),
                    const Text(
                      "Меню",
                      style: TextStyle(
                        fontSize: 14,
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
    );
  }
}
