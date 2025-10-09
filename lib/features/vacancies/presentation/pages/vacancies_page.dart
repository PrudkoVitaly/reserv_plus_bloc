import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vacancies_bloc.dart';
import '../bloc/vacancies_event.dart';
import '../bloc/vacancies_state.dart';
import '../widgets/vacancies_onboarding_view.dart';
import '../widgets/vacancies_list_view.dart';
import '../../data/repositories/vacancies_repository_impl.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

class VacanciesPage extends StatelessWidget {
  const VacanciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VacanciesBloc(
        repository: VacanciesRepositoryImpl(),
      )..add(const VacanciesInitialized()),
      child: const VacanciesView(),
    );
  }
}

class VacanciesView extends StatelessWidget {
  const VacanciesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: BlocBuilder<VacanciesBloc, VacanciesState>(
        builder: (context, state) {
          if (state is VacanciesLoading) {
            return const DelayedLoadingIndicator(
              color: Color(0xFF666666),
            );
          } else if (state is VacanciesLoaded) {
            if (state.showOnboarding) {
              return const VacanciesOnboardingView();
            } else {
              return const VacanciesListView();
            }
          } else if (state is VacanciesError) {
            return Center(
              child: Text('Помилка: ${state.message}'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
