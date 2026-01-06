import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/person_info_modal_content.dart';
import '../bloc/person_info_bloc.dart';
import '../../domain/usecases/get_person_info.dart';
import '../../data/repositories/person_info_repository_impl.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/draggable_bottom_sheet.dart';

class PersonInfoUtils {
  static void showPersonInfoModal(BuildContext context) {
    // Создаем экземпляры зависимостей
    final repository = PersonInfoRepositoryImpl();
    final getPersonInfo = GetPersonInfo(repository);
    final bloc = PersonInfoBloc(getPersonInfo);

    DraggableBottomSheet.showCustom(
      context: context,
      builder: (context, scrollController) => BlocProvider.value(
        value: bloc,
        child: PersonInfoModalContent(scrollController: scrollController),
      ),
    );
  }

  /// Показать модальное окно используя NavigatorState (для вызова после закрытия другого модала)
  static void showPersonInfoModalWithNavigator(NavigatorState navigatorState) {
    // Создаем экземпляры зависимостей
    final repository = PersonInfoRepositoryImpl();
    final getPersonInfo = GetPersonInfo(repository);
    final bloc = PersonInfoBloc(getPersonInfo);

    DraggableBottomSheet.showCustomWithNavigator(
      navigatorState: navigatorState,
      builder: (context, scrollController) => BlocProvider.value(
        value: bloc,
        child: PersonInfoModalContent(scrollController: scrollController),
      ),
    );
  }
}
