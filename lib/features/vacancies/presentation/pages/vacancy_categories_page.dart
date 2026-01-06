import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/vacancies/data/repositories/vacancies_repository_impl.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy_category.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:reserv_plus/features/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/selection_page.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancy_filter_page.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancy_search_page.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancy_sort_page.dart';
import 'package:reserv_plus/features/vacancies/presentation/widgets/vacancy_list_widget.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

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

class VacancyCategoriesView extends StatefulWidget {
  const VacancyCategoriesView({super.key});

  @override
  State<VacancyCategoriesView> createState() => _VacancyCategoriesViewState();
}

class _VacancyCategoriesViewState extends State<VacancyCategoriesView> {
  bool _isLoadingForYou = false;
  bool _isLoadingDrones = false;

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
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
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
                  fontWeight: FontWeight.w500,
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
                    NavigationUtils.pushWithHorizontalAnimation(
                      context: context,
                      page: const VacancySearchPage(),
                    );
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
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              children: [
                // Показываем лоадинг или контент
                if ((selectedCategory?.id == 'for_you' && _isLoadingForYou) ||
                    (selectedCategory?.id == 'drones' && _isLoadingDrones))
                  const Center(
                    child: DelayedLoadingIndicator(),
                  )
                else
                  PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 900),
                    reverse: false,
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        fillColor: const Color.fromRGBO(226, 223, 204, 1),
                        child: child,
                      );
                    },
                    child: _buildSelectedCategoryContent(
                        selectedCategory, context),
                  ),
                // Кнопки фильтра и сортировки только для категории 'all'
                if (selectedCategory?.id == 'all')
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildFilterSortButtons(context),
                  ),
              ],
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
                onTap: () async {
                  // Сначала переходим на вкладку
                  context
                      .read<VacanciesBloc>()
                      .add(VacanciesSelectCategory(category));

                  // Специальная логика для вкладки "for_you"
                  if (category.id == 'for_you') {
                    setState(() {
                      _isLoadingForYou = true;
                    });

                    // Показываем лоадинг на 2 секунды
                    await Future.delayed(const Duration(seconds: 2));

                    setState(() {
                      _isLoadingForYou = false;
                    });
                  }

                  // Специальная логика для вкладки "drones"
                  if (category.id == 'drones') {
                    setState(() {
                      _isLoadingDrones = true;
                    });

                    // Показываем лоадинг на 2 секунды
                    await Future.delayed(const Duration(seconds: 2));

                    setState(() {
                      _isLoadingDrones = false;
                    });
                  }
                },
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: shouldHighlight
                          ? Colors.black.withValues(alpha: 0.05)
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
  Widget _buildSelectedCategoryContent(
      VacancyCategory? selectedCategory, BuildContext context) {
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
              color: Colors.black.withValues(alpha: 0.1),
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
      child: _buildCategorySpecificContent(selectedCategory, context),
    );
  }

  // Специфичный контент для каждой категории
  Widget _buildCategorySpecificContent(
      VacancyCategory category, BuildContext context) {
    switch (category.id) {
      case 'drones':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
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
                    onPressed: () {
                      NavigationUtils.pushWithHorizontalAnimation(
                        context: context,
                        page: const SelectionPage(),
                      );
                    },
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
          ),
        );
      case 'for_you':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
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
                    onPressed: () {
                      NavigationUtils.pushWithHorizontalAnimation(
                        context: context,
                        page: const SelectionPage(),
                      );
                    },
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
          ),
        );
      case 'all':
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -16,
                  left: 0,
                  right: 0,
                  height: constraints.maxHeight + 32,
                  child: BlocBuilder<VacanciesBloc, VacanciesState>(
                    builder: (context, state) {
                      if (state is VacanciesCategoriesLoaded &&
                          state.loadedVacancies != null) {
                        return VacancyListWidget(
                            vacancies: state.loadedVacancies!);
                      } else {
                        return const Center(
                          child: DelayedLoadingIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
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

  // Кнопки фильтра и сортировки
  Widget _buildFilterSortButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.tune,
            text: 'Фільтр',
            onTap: () {
              NavigationUtils.pushWithHorizontalAnimation(
                context: context,
                page: const VacancyFilterPage(),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.sort,
            text: 'Сортування',
            onTap: () {
              NavigationUtils.pushWithHorizontalAnimation(
                context: context,
                page: const VacancySortPage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
