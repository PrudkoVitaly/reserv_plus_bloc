import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';
import 'package:reserv_plus/features/shared/services/bottom_nav_bar_controller.dart';

class VlkUnavailablePage extends StatelessWidget {
  const VlkUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 26.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/attention_image.png",
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Запит на ВЛК недоступний',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Ви виключені з військового\nобліку.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Зараз цей сервіс діє лише для військовозобов\'язаних.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Якщо ви маєте бути на обліку, то зверніться до ТЦК',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              text: 'Зрозуміло',
              onPressed: () {
                BottomNavBarController().show();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
