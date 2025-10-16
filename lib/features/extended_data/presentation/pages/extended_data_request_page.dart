// lib/features/extended_data/presentation/pages/extended_data_request_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/extended_data_repository_impl.dart';
import '../bloc/extended_data_bloc.dart';
import '../bloc/extended_data_event.dart';
import '../bloc/extended_data_state.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'extended_data_success_page.dart';
import 'extended_data_review_page.dart';

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
          // Переходим к экрану "Запит надіслано" (как на картинке)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ExtendedDataSuccessPage(),
            ),
          );
        }
      },
      child: Scaffold(
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
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Які ваші дані є в реєстрі Оберіг?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'У реєстрі Оберіг є більше інформації про вас, ніж відображає військово-обліковий документ. Щоб її отримати, достатньо подати запит.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Це можна робити раз на 24 години.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<ExtendedDataBloc, ExtendedDataState>(
                builder: (context, state) {
                  return SizedBox(
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
                      child: state is ExtendedDataRequestInProgress
                          ? const DelayedLoadingIndicator()
                          : const Text(
                              'Надіслати запит',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
