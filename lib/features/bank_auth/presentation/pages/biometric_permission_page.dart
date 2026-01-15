import 'package:flutter/material.dart';
import 'package:reserv_plus/features/bank_auth/presentation/pages/loading_data_page.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

/// Страница запроса разрешения на биометрическую авторизацию
class BiometricPermissionPage extends StatelessWidget {
  const BiometricPermissionPage({super.key});

  void _navigateToLoading(BuildContext context) {
    NavigationUtils.pushWithHorizontalAnimation(
      context: context,
      page: const LoadingDataPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Возвращаемся на ConfirmPinPage
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Заголовок
                const Text(
                  'Дозвольте вхід за\nбіометричними\nданими',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 20),

                // Подзаголовок
                const Text(
                  'Щоб швидко заходити в\nзастосунок',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 40),

                // Иконки биометрии (отпечаток + Face ID)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/fingerprint_icon.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(width: 24),
                    Image.asset(
                      'images/face_id_icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),

                // Кнопка "Дозволити"
                PrimaryButton(
                  text: 'Дозволити',
                  onPressed: () => _navigateToLoading(context),
                ),

                const SizedBox(height: 16),

                // Кнопка "Пропустити"
                TextButton(
                  onPressed: () => _navigateToLoading(context),
                  child: const Text(
                    'Пропустити',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
