import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/person_info_modal.dart';
import '../bloc/person_info_bloc.dart';
import '../../domain/usecases/get_person_info.dart';
import '../../data/repositories/person_info_repository_impl.dart';

class PersonInfoUtils {
  static void showPersonInfoModal(BuildContext context) {
    // Создаем экземпляры зависимостей
    final repository = PersonInfoRepositoryImpl();
    final getPersonInfo = GetPersonInfo(repository);
    final bloc = PersonInfoBloc(getPersonInfo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: const PersonInfoModal(),
      ),
    );
  }
}
