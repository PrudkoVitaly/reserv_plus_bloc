import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/vacancies/data/repositories/vacancies_repository_impl.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:reserv_plus/features/vacancies/presentation/widgets/vacancy_list_widget.dart';

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
    return BlocBuilder<VacanciesBloc, VacanciesState>(
      builder: (context, state) {
        if (state is VacanciesCategoriesLoading) {
          return const Center(
            child: DelayedLoadingIndicator(
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
    );
  }

  Widget _buildCategoriesList(
      BuildContext context,
      List<VacancyCategory> categories,
      VacancyCategory? selectedCategory,
      bool isHighlighted) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Вакансії в\nСилах оборони\nУкраїни',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 45,
                height: 45,
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
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          // Заменяем карточки на табы
          _buildCategoryTabs(
              context, categories, selectedCategory, isHighlighted),
          const SizedBox(height: 20),
          // Здесь будет контент выбранной категории
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 900),
              reverse: false,
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  fillColor: const Color.fromRGBO(226, 223, 204, 1),
                  child: child,
                );
              },
              child: _buildSelectedCategoryContent(selectedCategory),
            ),
          )
        ],
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
        _buildAnimatedIndicator(context, categories, selectedCategory),
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
              // Фоновая полосочка - немного короче
              Center(
                child: Container(
                  width: constraints.maxWidth * 0.96,
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
        key: const ValueKey('no_selection'),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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

    return SizedBox(
      key: ValueKey('category_${selectedCategory.id}'),
      width: double.infinity,
      child: _buildCategorySpecificContent(selectedCategory),
    );
  }

  // Специфичный контент для каждой категории
  Widget _buildCategorySpecificContent(VacancyCategory category) {
    switch (category.id) {
      case 'drones':
        return Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'На вас чекають',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              _buildEmblemsGridDroneLine(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Змінити хіт подій',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'for_you':
        return Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'На вас чекають',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildEmblemsGridForYou(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Подивитись вакансії',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'all':
        return BlocBuilder<VacanciesBloc, VacanciesState>(
          builder: (context, state) {
            if (state is VacanciesCategoriesLoaded &&
                state.loadedVacancies != null) {
              return VacancyListWidget(vacancies: state.loadedVacancies!);
            } else {
              return const Center(
                child: DelayedLoadingIndicator(),
              );
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmblemsGridDroneLine() {
    final emblems = [
      _buildEmblemDroneLine('images/axilles.png'),
      _buildEmblemDroneLine('images/k2.png'),
      _buildEmblemDroneLine('images/birds_madyar.png'),
      _buildEmblemDroneLine('images/papor.png'),
      _buildEmblemDroneLine('images/phoenix.png'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;

        // 35% от высоты экрана, но в разумных пределах
        final maxHeight = (screenHeight * 0.38).clamp(250.0, 450.0);

        return SizedBox(
          height: maxHeight,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: emblems.length,
            itemBuilder: (context, index) => emblems[index],
          ),
        );
      },
    );
  }

  Widget _buildEmblemDroneLine(String imagePath) {
    return Image.asset(
      imagePath,
      width: 180,
      height: 180,
      fit: BoxFit.contain,
    );
  }

  Widget _buildEmblemsGridForYou() {
    final emblems = [
      _buildEmblemForYou('images/birds_madyar.png'),
      _buildEmblemForYou('images/k2.png'),
      _buildEmblemForYou('images/cannos.png'),
      _buildEmblemForYou('images/1ohp.png'),
      _buildEmblemForYou('images/birds_madyar.png'),
      _buildEmblemForYou('images/crossed_swords.png'),
      _buildEmblemForYou('images/red_cross_trident.png'),
      _buildEmblemForYou('images/phoenix_ukr_gerb.png'),
      _buildPlusButton(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;

        // 35% от высоты экрана, но в разумных пределах
        final maxHeight = (screenHeight * 0.38).clamp(250.0, 450.0);

        return SizedBox(
          height: maxHeight,
          child: GridView.builder(
            padding: EdgeInsets.zero, // ← ВОТ ЭТО!
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: emblems.length,
            itemBuilder: (context, index) => emblems[index],
          ),
        );
      },
    );
  }

  Widget _buildEmblemForYou(String imagePath) {
    return Image.asset(
      imagePath,
      width: 180,
      height: 180,
      fit: BoxFit.contain,
    );
  }

  Widget _buildPlusButton() {
    return Transform.scale(
      scale: 0.6,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '+87',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
