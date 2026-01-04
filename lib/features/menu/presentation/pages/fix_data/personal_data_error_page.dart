import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/services/user_data_service.dart';

class PersonalDataErrorPage extends StatelessWidget {
  const PersonalDataErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserDataService();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildDataItem(
                        label: 'ПІБ',
                        value: userData.fullName,
                      ),
                      _buildDataItem(
                        label: 'Дата народження',
                        value: userData.birthDate,
                      ),
                      _buildDataItem(
                        label: 'РНОКПП або паспорт',
                        value: userData.taxId,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Тут вказано ваші дані з BankID',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Якщо все правильно — надішліть заявку і вони оновляться в реєстрі Оберіг.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Якщо бачите помилку, то зверніться у банк, щоб виправити дані. А потім подайте заявку на зміни у реєстр.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 24, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 28,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Перевірте дані',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(106, 103, 88, 1),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Действие подтверждения
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Підтвердити',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
