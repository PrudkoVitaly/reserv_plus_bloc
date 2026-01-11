import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/main_bloc.dart';
import '../bloc/main_event.dart';
import '../bloc/main_state.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancies_page.dart';
import 'package:reserv_plus/features/document/presentation/pages/document_page.dart';
import 'package:reserv_plus/features/menu/presentation/pages/menu_screen.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/animated_tab_switcher.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(const MainInitialized());
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
    final currentIndex = state.navigationState.selectedIndex == -1
        ? 0
        : state.navigationState.selectedIndex.clamp(0, 2);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: AnimatedTabSwitcher(
        currentIndex: currentIndex,
        children: const [
          DocumentPage(),
          VacanciesPage(),
          MenuScreen(),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(
        enableHideAnimation: true,
      ),
    );
  }
}
