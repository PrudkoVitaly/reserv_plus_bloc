// lib/features/extended_data/presentation/pages/extended_data_request_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/extended_data_repository_impl.dart';
import '../bloc/extended_data_bloc.dart';
import '../bloc/extended_data_event.dart';
import '../bloc/extended_data_state.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'extended_data_success_page.dart';

class ExtendedDataRequestPage extends StatelessWidget {
  const ExtendedDataRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtendedDataBloc(
        repository: ExtendedDataRepositoryImpl(),
      )..add(const ExtendedDataInitialized()),
      child: const ExtendedDataRequestView(),
    );
  }
}

class ExtendedDataRequestView extends StatelessWidget {
  const ExtendedDataRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExtendedDataBloc, ExtendedDataState>(
      listener: (context, state) {
        if (state is ExtendedDataReviewScreen) {
          // Переходим к экрану "Запит надіслано" с анимацией
          NavigationUtils.pushWithHorizontalAnimation(
            context: context,
            page: const ExtendedDataSuccessPage(),
          ).then((_) {
            // Заменяем текущий route после завершения анимации
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: BlocBuilder<ExtendedDataBloc, ExtendedDataState>(
        builder: (context, state) {
          // Если идет процесс отправки запроса - показываем полноэкранный loading
          if (state is ExtendedDataRequestInProgress) {
            return _buildLoadingScreen();
          }

          // Иначе показываем обычный экран с формой
          return _buildRequestScreen(context, state);
        },
      ),
    );
  }

  // Полноэкранный экран загрузки
  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(226, 223, 204, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DelayedLoadingIndicator(),
            SizedBox(height: 24),
            Text(
              'Надсилаємо запит...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Основной экран с формой запроса
  Widget _buildRequestScreen(BuildContext context, ExtendedDataState state) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Які ваші дані є в реєстрі Оберіг?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'У реєстрі Оберіг є більше інформації про вас, ніж відображає військово-обліковий документ. Щоб її отримати, достатньо подати запит.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            const Text(
              'Це можна робити раз на 24 години.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: state is ExtendedDataRequestConfirmation
                    ? () {
                        context
                            .read<ExtendedDataBloc>()
                            .add(const ExtendedDataConfirmRequest());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                child: const Text(
                  'Надіслати запит',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
