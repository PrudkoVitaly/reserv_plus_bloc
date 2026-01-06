import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancy_categories_page.dart';
import '../bloc/vacancies_bloc.dart';
import '../bloc/vacancies_event.dart';
import '../bloc/vacancies_state.dart';
import '../widgets/vacancies_onboarding_view.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

class VacanciesPage extends StatelessWidget {
  const VacanciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Инициализируем блок если он в начальном состоянии
    // Блок сам проверит и проигнорирует если уже инициализирован
    context.read<VacanciesBloc>().add(const VacanciesInitialized());
    return const VacanciesView();
  }
}

class VacanciesView extends StatelessWidget {
  const VacanciesView({super.key});

  static const _backgroundColor = Color.fromRGBO(226, 223, 204, 1);
  static const _primaryColor = Color.fromRGBO(253, 135, 12, 1);
  static const _loadingColor = Color(0xFF666666);

  static const _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: BlocBuilder<VacanciesBloc, VacanciesState>(
        builder: (context, state) => _buildAnimatedContent(state),
      ),
    );
  }

  Widget _buildAnimatedContent(VacanciesState state) {
    return PageTransitionSwitcher(
      duration: _animationDuration,
      reverse: false,
      transitionBuilder: _transitionBuilder,
      child: _buildContent(state),
    );
  }

  Widget _transitionBuilder(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: _backgroundColor,
      child: child,
    );
  }

  // Определяет какой виджет показать на основе состояния BLoC
  Widget _buildContent(VacanciesState state) {
    return switch (state) {
      VacanciesLoading() => _buildLoading(_loadingColor),
      VacanciesLoaded(showOnboarding: true) => _buildOnboarding(),
      VacanciesLoaded(showOnboarding: false) => _buildVacanciesList(),
      VacanciesCategoriesLoading() => _buildLoading(_primaryColor),
      VacanciesCategoriesLoaded() => _buildCategories(),
      VacanciesError(:final message) => _buildError(message),
      _ => _buildEmpty(),
    };
  }

  // Виджет загрузки
  Widget _buildLoading(Color color) {
    return Center(
      child: DelayedLoadingIndicator(
        key: ValueKey('loading_${color.toARGB32()}'),
        color: color,
      ),
    );
  }

  // Виджет приветственного экрана
  Widget _buildOnboarding() {
    return const VacanciesOnboardingView(
      key: ValueKey('onboarding'),
    );
  }

  // Виджет списка вакансий
  Widget _buildVacanciesList() {
    return const Center(
      key: ValueKey('list'),
      child: Text('Список вакансий'),
    );
  }

  // Виджет экрана с категориями
  Widget _buildCategories() {
    return const VacancyCategoriesView(
      key: ValueKey('categories'),
    );
  }

  // Виджет пустого состояния
  Widget _buildEmpty() {
    return const SizedBox.shrink(
      key: ValueKey('empty'),
    );
  }

  // Виджет ошибки
  Widget _buildError(String message) {
    return Center(
      key: ValueKey('error_$message'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Помилка: $message',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
