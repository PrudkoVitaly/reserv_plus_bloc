import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/extended_data/domain/entities/extended_data.dart';
import 'package:reserv_plus/features/extended_data/presentation/bloc/extended_data_bloc.dart';
import 'package:reserv_plus/features/extended_data/presentation/bloc/extended_data_event.dart';
import 'package:reserv_plus/features/extended_data/presentation/bloc/extended_data_state.dart';
import 'package:reserv_plus/features/extended_data/presentation/pages/extended_data_received_page.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import '../../data/repositories/extended_data_repository_impl.dart';

class ExtendedDataReviewPage extends StatelessWidget {
  final ExtendedData data;

  const ExtendedDataReviewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtendedDataBloc(
        repository: ExtendedDataRepositoryImpl(),
      ),
      child: ExtendedDataReviewView(data: data),
    );
  }
}

class ExtendedDataReviewView extends StatelessWidget {
  final ExtendedData data;

  const ExtendedDataReviewView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExtendedDataBloc, ExtendedDataState>(
      listener: (context, state) {
        if (state is ExtendedDataSuccess) {
          // Переходим к финальному экрану "Отримали дані з реєстру"
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ExtendedDataReceivedPage(
                pdfPath: state.pdfPath,
              ),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Перевірте ваші дані',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildDataCard('ПІБ', data.fullName),
                      _buildDataCard('Дата народження', data.birthDate),
                      _buildDataCard('Статус', data.status),
                      _buildDataCard('Стать', data.gender),
                      _buildDataCard('ІПН', data.taxId),
                      _buildDataCard('Місце народження', data.placeOfBirth),
                      _buildDataCard('Адреса', data.address),
                      _buildDataCard('Телефон', data.phone),
                      _buildDataCard('Email', data.email),
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
                      onPressed: state is ExtendedDataReviewScreen
                          ? () {
                              context
                                  .read<ExtendedDataBloc>()
                                  .add(const ExtendedDataGeneratePDF());
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      child: state is ExtendedDataGeneratingPDF
                          ? const DelayedLoadingIndicator()
                          : const Text(
                              'Згенерувати PDF',
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

  Widget _buildDataCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
