import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/vacancies_repository.dart';
import 'vacancies_event.dart';
import 'vacancies_state.dart';

class VacanciesBloc extends Bloc<VacanciesEvent, VacanciesState> {
  final VacanciesRepository _repository;

  VacanciesBloc({required VacanciesRepository repository})
      : _repository = repository,
        super(const VacanciesInitial()) {
    on<VacanciesInitialized>(_onInitialized);
    on<VacanciesStartPressed>(_onStartPressed);
    on<VacanciesSetDontShowAgain>(_onSetDontShowAgain);
    on<VacanciesPageOpened>(_onPageOpened);

    // ОБРАБОТЧИКИ для категорий
    on<VacanciesLoadCategories>(_onLoadCategories);
    on<VacanciesSelectCategory>(_onSelectCategory);

    // ОБРАБОТЧИКИ для вакансий
    on<VacanciesLoadAllVacancies>(_onLoadAllVacancies);
  }

  void _onInitialized(
      VacanciesInitialized event, Emitter<VacanciesState> emit) async {
    // Если уже инициализирован - не делаем ничего
    if (state is! VacanciesInitial) {
      return;
    }

    emit(const VacanciesLoading());

    try {
      final shouldShowOnboarding = await _repository.shouldShowOnboarding();
      // Всегда показываем онбординг при инициализации (если пользователь не поставил галочку)
      emit(VacanciesLoaded(showOnboarding: shouldShowOnboarding));
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  void _onStartPressed(
      VacanciesStartPressed event, Emitter<VacanciesState> emit) async {
    // Вместо скрытия онбординга - загружаем категории
    emit(const VacanciesCategoriesLoading());
    try {
      final categories = await _repository.getVacancyCategories();

      // Автоматически выбираем вторую категорию "Для вас" при загрузке
      // Если категорий меньше 2, выбираем первую, если есть
      final selectedCategory = categories.length > 1
          ? categories[1]
          : (categories.isNotEmpty ? categories.first : null);

      emit(VacanciesCategoriesLoaded(
        categories: categories,
        selectedCategory: selectedCategory,
      ));
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  void _onSetDontShowAgain(
      VacanciesSetDontShowAgain event, Emitter<VacanciesState> emit) async {
    if (state is VacanciesLoaded) {
      await _repository.setDontShowAgain(event.value);
    }
  }

  void _onPageOpened(
      VacanciesPageOpened event, Emitter<VacanciesState> emit) async {
    emit(const VacanciesLoading());

    try {
      final shouldShowOnboarding = await _repository.shouldShowOnboarding();
      emit(VacanciesLoaded(showOnboarding: shouldShowOnboarding));
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  // ОБРАБОТЧИКИ для категорий
  void _onLoadCategories(
      VacanciesLoadCategories event, Emitter<VacanciesState> emit) async {
    emit(const VacanciesCategoriesLoading());

    try {
      final categories = await _repository.getVacancyCategories();

      // Автоматически выбираем вторую категорию "Для вас" при загрузке
      // Если категорий меньше 2, выбираем первую, если есть
      final selectedCategory = categories.length > 1
          ? categories[1]
          : (categories.isNotEmpty ? categories.first : null);

      emit(VacanciesCategoriesLoaded(
        categories: categories,
        selectedCategory: selectedCategory,
      ));
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  void _onSelectCategory(
      VacanciesSelectCategory event, Emitter<VacanciesState> emit) async {
    try {
      await _repository.selectCategory(event.category);
      final categories = await _repository.getVacancyCategories();

      emit(VacanciesCategoriesLoaded(
        categories: categories,
        selectedCategory: event.category,
        isHighlighted: true,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(VacanciesCategoriesLoaded(
        categories: categories,
        selectedCategory: event.category,
        isHighlighted: false,
      ));
      add(const VacanciesLoadAllVacancies());
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  void _onLoadAllVacancies(
      VacanciesLoadAllVacancies event, Emitter<VacanciesState> emit) async {
    try {
      // Получаем текущее состояние, чтобы сохранить категории
      if (state is VacanciesCategoriesLoaded) {
        final currentState = state as VacanciesCategoriesLoaded;
        final vacancies = await _repository.getAllVacancies();

        // Обновляем существующее состояние с добавлением вакансий
        emit(currentState.copyWith(loadedVacancies: vacancies));
      }
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }
}
