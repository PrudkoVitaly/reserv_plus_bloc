import 'package:flutter/material.dart';
import 'package:reserv_plus/features/registry/presentation/pages/registry_page.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

/// Страница запроса разрешения на биометрическую авторизацию
class BiometricPermissionPage extends StatelessWidget {
  const BiometricPermissionPage({super.key});

  void _navigateToRegistry(BuildContext context) {
    NavigationUtils.pushWithHorizontalAnimation(
      context: context,
      page: const RegistryPage(),
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
                // Заголовок
                const Text(
                  'Дозвольте вхід за\nбіометричними\nданими',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1,
                  ),
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 20),

                // Подзаголовок
                const Text(
                  'Щоб входити до застосунку за відбитком пальця або скануванням обличчя.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1,
                  ),
                  textAlign: TextAlign.start,
                ),

                // Иконки биометрии (отпечаток + Face ID) - центрируем между текстом и кнопками
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/fingerprint_icon.png',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 40),
                        Image.asset(
                          'images/face_id_icon.png',
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),

                // Кнопка "Дозволити"
                PrimaryButton(
                  text: 'Дозволити',
                  onPressed: () => _navigateToRegistry(context),
                ),

                const SizedBox(height: 16),

                // Кнопка "Пропустити"
                Center(
                  child: TextButton(
                    onPressed: () => _navigateToRegistry(context),
                    child: const Text(
                      'Дозволю пізніше',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
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
