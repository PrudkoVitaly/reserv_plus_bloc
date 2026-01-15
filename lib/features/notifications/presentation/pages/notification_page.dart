import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_event.dart';
import 'package:reserv_plus/features/notifications/presentation/bloc/notification_state.dart';
import 'package:reserv_plus/features/notifications/presentation/widgets/notification_card.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Загружаем уведомления при открытии страницы
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(const NotificationLoadAll());
    });

    return const NotificationPageView();
  }
}

class NotificationPageView extends StatelessWidget {
  const NotificationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(title: 'Сповіщення'),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(
                      child: DelayedLoadingIndicator(),
                    );
                  }

                  if (state is NotificationError) {
                    return Center(
                      child: Text('Помилка: ${state.message}'),
                    );
                  }

                  if (state is NotificationLoaded) {
                    if (state.notifications.isEmpty) {
                      return const Center(
                        child: Text('Немає сповіщень'),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? 16 : 0,
                            bottom: 0,
                          ),
                          child: NotificationCard(
                            notification: state.notifications[index],
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
