import 'package:flutter/material.dart';

class DataReceivedDetailPage extends StatelessWidget {
  const DataReceivedDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Дані з реєстру Оберіг отримано',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 26),
                  Text(
                    'Ваш військово-обліковий документ в електронній формі з QR-кодом вже доступний на головному екрані застосунку.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Зверніть увагу, що при статусі «Потребує уточнення» військово-обліковий документ в електронній формі не формується.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Про деталі цього статусу дізнайтесь у розділі «Питання та відповіді» в меню.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
