import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';
import 'package:reserv_plus/features/bank_auth/presentation/pages/bank_webview_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

class BankSelectionPage extends StatelessWidget {
  const BankSelectionPage({super.key});

  // Список банков с логотипами, названиями, URL, телефонами и цветами бренда
  static const List<Map<String, dynamic>> _banks = [
    {
      'name': 'ПриватБанк',
      'logo': 'images/privatbank_logo.png',
      'url': 'https://www.privat24.ua/',
      'phone': '3700',
      'phoneHint': 'Безкоштовно з мобільного',
      'color': Color(0xFF4CAF50), // Зелёный ПриватБанка
    },
    {
      'name': 'Ощадбанк',
      'logo': 'images/oschadbank_logo.png',
      'url': 'https://online.oschadbank.ua/',
      'phone': '0 800 210 800',
      'phoneHint': 'Безкоштовно по Україні',
      'color': Color(0xFF00A651), // Зелёный Ощадбанка
    },
    {
      'name': 'monobank',
      'logo': 'images/monobank_logo.png',
      'url': 'https://www.monobank.ua/',
      'phone': '0 800 205 205',
      'phoneHint': 'Безкоштовно по Україні',
      'color': Color(0xFF000000), // Чёрный monobank
    },
    {
      'name': 'Райффайзен Банк',
      'logo': 'images/raiffeisen_logo.png',
      'url': 'https://raiffeisen.ua/uk',
      'phone': '0 800 500 500',
      'phoneHint': 'Безкоштовно по Україні',
      'color': Color.fromARGB(255, 252, 210, 42), // Жёлтый Райффайзен
    },
    {
      'name': 'Абанк',
      'logo': 'images/abank_logo.png',
      'url': 'https://a-bank.com.ua/',
      'phone': '0 800 205 580',
      'phoneHint': 'Безкоштовно по Україні',
      'color': Color.fromARGB(255, 61, 176, 4), // Красный Абанк
    },
    {
      'name': 'ПУМБ',
      'logo': 'images/pumb_logo.png',
      'url': 'https://online.pumb.ua/',
      'phone': '0 800 505 490',
      'phoneHint': 'Безкоштовно по Україні',
      'color': Color.fromARGB(255, 193, 12, 12), // Синий ПУМБ
    },
    {
      'name': 'Sense Bank',
      'logo': 'images/sensebank_logo.png',
      'url': 'https://online.sensebank.com.ua/',
      'phone': '0 800 509 990',
      'phoneHint': 'Безкоштовно по Україні',
      'color': Color.fromARGB(255, 1, 126, 229), // Розовый Sense Bank
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Показываем системные панели
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Адаптивные отступы в зависимости от ширины экрана
            final horizontalPadding = constraints.maxWidth > 600 ? 32.0 : 16.0;
            // Максимальная ширина списка на больших экранах
            final maxListWidth =
                constraints.maxWidth > 600 ? 500.0 : double.infinity;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок с кнопкой назад и иконкой помощи
                const AppHeader(
                  title: 'Оберіть свій банк',
                  showHelpButton: true,
                ),
                const SizedBox(height: 24),

                // Список банков
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Container(
                      width: maxListWidth,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _banks.length; i++) ...[
                            _BankListItem(
                              name: _banks[i]['name'] as String,
                              logoPath: _banks[i]['logo'] as String,
                              onTap: () {
                                NavigationUtils.pushWithHorizontalAnimation(
                                  context: context,
                                  page: BankWebViewPage(
                                    bankName: _banks[i]['name'] as String,
                                    logoPath: _banks[i]['logo'] as String,
                                    authUrl: _banks[i]['url'] as String,
                                    supportPhone: _banks[i]['phone'] as String,
                                    supportPhoneHint:
                                        _banks[i]['phoneHint'] as String,
                                    brandColor: _banks[i]['color'] as Color,
                                  ),
                                );
                              },
                            ),
                            // Divider после каждого элемента
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                height: 1,
                                color: const Color.fromRGBO(234, 235, 228, 1),
                              ),
                            ),
                          ],
                          // Отступ снизу чтобы divider не обрезался скруглёнными углами
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Виджет одного банка в списке
class _BankListItem extends StatelessWidget {
  final String name;
  final String logoPath;
  final VoidCallback onTap;

  const _BankListItem({
    required this.name,
    required this.logoPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            // Логотип банка
            SizedBox(
              width: 100,
              height: 40,
              child: Image.asset(
                logoPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            // Название банка
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
