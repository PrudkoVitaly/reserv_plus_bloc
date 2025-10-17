import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/vacancies/data/repositories/vacancies_repository_impl.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancies_page.dart';

class VacancyCategoriesPage extends StatelessWidget {
  const VacancyCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VacanciesBloc(
        repository: VacanciesRepositoryImpl(),
      )..add(const VacanciesLoadCategories()),
      child: const VacancyCategoriesView(),
    );
  }
}

class VacancyCategoriesView extends StatelessWidget {
  const VacancyCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: BlocBuilder<VacanciesBloc, VacanciesState>(
        builder: (context, state) {
          if (state is VacanciesCategoriesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(253, 135, 12, 1),
              ),
            );
          } else if (state is VacanciesCategoriesLoaded) {
            return _buildCategoriesList(context, state.categories,
                state.selectedCategory, state.isHighlighted);
          } else if (state is VacanciesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Помилка: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<VacanciesBloc>()
                          .add(const VacanciesLoadCategories());
                    },
                    child: const Text('Спробувати знову'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategoriesList(
      BuildContext context,
      List<VacancyCategory> categories,
      VacancyCategory? selectedCategory,
      bool isHighlighted) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Вакансії в\nСилах оборони\nУкраїни',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Заменяем карточки на табы
          _buildCategoryTabs(
              context, categories, selectedCategory, isHighlighted),
          const SizedBox(height: 20),
          // Здесь будет контент выбранной категории
          Expanded(
            child: _buildSelectedCategoryContent(selectedCategory),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, VacancyCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlocProvider(
              create: (context) => VacanciesBloc(
                repository: VacanciesRepositoryImpl(),
              )..add(VacanciesSelectCategory(category)),
              child: const VacanciesPage(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: const Color.fromRGBO(226, 223, 204, 1),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color.fromRGBO(253, 135, 12, 1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromRGBO(253, 135, 12, 1)
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : const Color.fromRGBO(253, 135, 12, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                _getCategoryIcon(category.id),
                color: isSelected
                    ? const Color.fromRGBO(253, 135, 12, 1)
                    : Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  // Виджет табов с анимацией
  Widget _buildCategoryTabs(
      BuildContext context,
      List<VacancyCategory> categories,
      VacancyCategory? selectedCategory,
      bool isHighlighted) {
    return Column(
      children: [
        // Табы
        Row(
          children: categories.map((category) {
            final isSelected = selectedCategory?.id == category.id;
            final shouldHighlight = isSelected && isHighlighted;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  context
                      .read<VacanciesBloc>()
                      .add(VacanciesSelectCategory(category));
                },
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: shouldHighlight
                          ? Colors.black.withOpacity(0.05)
                          : Colors.transparent,
                    ),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        // Общая полосочка с анимированным сдвигом
        Center(
          child: _buildAnimatedIndicator(context, categories, selectedCategory),
        ),
      ],
    );
  }

  // Анимированный индикатор
  Widget _buildAnimatedIndicator(BuildContext context,
      List<VacancyCategory> categories, VacancyCategory? selectedCategory) {
    final selectedIndex = selectedCategory != null
        ? categories.indexWhere((cat) => cat.id == selectedCategory.id)
        : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / categories.length;

        // Вычисляем ширину полосочки на основе длины текста
        final selectedCategory = categories[selectedIndex];
        final textPainter = TextPainter(
          text: TextSpan(
            text: selectedCategory.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final indicatorWidth = textPainter.width + 4;

        final leftPosition =
            selectedIndex * tabWidth + (tabWidth - indicatorWidth) / 2;

        return SizedBox(
          width: constraints.maxWidth,
          height: 1,
          child: Stack(
            children: [
              // Фоновая полосочка - только под табами
              Center(
                child: Container(
                  width: constraints.maxWidth * 0.9,
                  height: 1,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 165, 165, 165),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              // Анимированная полосочка
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: leftPosition,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  width: indicatorWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Контент выбранной категории
  Widget _buildSelectedCategoryContent(VacancyCategory? selectedCategory) {
    if (selectedCategory == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Оберіть категорію',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(selectedCategory.id),
            size: 48,
            color: const Color.fromRGBO(253, 135, 12, 1),
          ),
          const SizedBox(height: 16),
          Text(
            selectedCategory.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedCategory.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildCategorySpecificContent(selectedCategory),
        ],
      ),
    );
  }

  // Специфичный контент для каждой категории
  Widget _buildCategorySpecificContent(VacancyCategory category) {
    switch (category.id) {
      case 'drones':
        return Column(
          children: [
            const Text(
              'Лінія дронів',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Спеціалізовані посади для роботи з безпілотними літальними апаратами',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 'for_you':
        return Column(
          children: [
            const Text(
              'Для вас',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Персоналізовані рекомендації на основі ваших навичок',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 'all':
        return Column(
          children: [
            const Text(
              'Всі вакансії',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Повний список доступних вакансій у ЗСУ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'drones':
        return Icons.airplanemode_active;
      case 'for_you':
        return Icons.person;
      case 'all':
        return Icons.list;
      default:
        return Icons.work;
    }
  }
}
