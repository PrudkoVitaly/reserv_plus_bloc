import 'package:flutter/material.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';
import 'personal_data_error_page.dart';

class FixDataPage extends StatelessWidget {
  const FixDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(title: 'Виправити дані\nонлайн'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildMenuCard(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            title: 'Помилка в персональних\nданих',
            subtitle: 'Потрібно внести їх правильно',
            onTap: () {
              NavigationUtils.pushWithHorizontalAnimation(
                context: context,
                page: const PersonalDataErrorPage(),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            title: 'Помилка у даних\nбронювання',
            subtitle:
                'Якщо неправильно відображаються дані з наказу про бронювання',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            title: 'Відомості про\nінвалідність',
            subtitle: 'Даних про інвалідність немає чи вони помилкові',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            title: 'Актуалізувати фото',
            subtitle:
                'Натисніть – і ми підтягнемо ваше фото з реєстру у документ',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(106, 103, 88, 0.8),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
