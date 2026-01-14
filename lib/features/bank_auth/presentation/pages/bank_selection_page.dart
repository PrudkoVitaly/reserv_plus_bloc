import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_back_header.dart';

class BankSelectionPage extends StatelessWidget {
  const BankSelectionPage({super.key});

  // Список банков с логотипами и названиями
  static const List<Map<String, String>> _banks = [
    {'name': 'ПриватБанк', 'logo': 'images/privatbank_logo.png'},
    {'name': 'Ощадбанк', 'logo': 'images/oschadbank_logo.png'},
    {'name': 'monobank', 'logo': 'images/monobank_logo.png'},
    {'name': 'Райффайзен Банк', 'logo': 'images/raiffeisen_logo.png'},
    {'name': 'Абанк', 'logo': 'images/abank_logo.png'},
    {'name': 'ПУМБ', 'logo': 'images/pumb_logo.png'},
    {'name': 'Sense Bank', 'logo': 'images/sensebank_logo.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с кнопкой назад
            const CustomBackHeader(
              title: 'Оберіть свій банк',
            ),
            const SizedBox(height: 24),

            // Список банков
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _banks.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final bank = _banks[index];
                    return _BankListItem(
                      name: bank['name']!,
                      logoPath: bank['logo']!,
                      onTap: () {
                        // TODO: Открыть WebView с сайтом банка
                      },
                    );
                  },
                ),
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  fontWeight: FontWeight.w500,
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
