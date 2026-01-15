import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reserv_plus/features/bank_auth/presentation/pages/bank_selection_page.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';
import 'package:reserv_plus/features/support/presentation/pages/support_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

/// Страница приветствия перед авторизацией через BankID
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isAgreed = false;

  void _navigateToSupport() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SupportPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToBankSelection() {
    NavigationUtils.pushWithHorizontalAnimation(
      context: context,
      page: const BankSelectionPage(),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse('https://reserveplus.mod.gov.ua/privacy/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header с заголовком и кнопкой "?"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Привіт!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToSupport,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Подзаголовок
              const Text(
                'Щоб отримати доступ до застосунку:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1,
                ),
              ),

              const SizedBox(height: 30),

              // Буллет 1
              _buildBulletPoint(
                'Авторизуйтеся через свій банк за допомогою BankID.',
              ),

              const SizedBox(height: 20),

              // Буллет 2
              _buildBulletPoint(
                'Створіть пароль та налаштуйте вхід за біометричними даними.',
              ),

              const Spacer(),

              // Чекбокс с согласием
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAgreed = !_isAgreed;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _isAgreed,
                        onChanged: (val) {
                          setState(() {
                            _isAgreed = val ?? false;
                          });
                        },
                        activeColor: const Color.fromRGBO(253, 135, 12, 1),
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            height: 1,
                          ),
                          children: [
                            const TextSpan(text: 'Погоджуюсь із '),
                            TextSpan(
                              text: 'Правилами обробки персональних даних',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _openPrivacyPolicy,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Кнопка "Розпочати"
              PrimaryButton(
                text: 'Розпочати',
                onPressed: _isAgreed ? _navigateToBankSelection : null,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
