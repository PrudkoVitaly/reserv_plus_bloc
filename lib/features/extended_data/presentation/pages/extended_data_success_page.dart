import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/primary_button.dart';
import 'package:reserv_plus/features/extended_data/presentation/pages/extended_data_received_page.dart';

class ExtendedDataSuccessPage extends StatelessWidget {
  const ExtendedDataSuccessPage({super.key});

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
                    // Иконка щита с восклицательным знаком
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Image.asset(
                        "images/attention_image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Запит надіслано',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Тепер слід трохи почекати',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
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
                // Переходим на ExtendedDataReceivedPage с горизонтальной анимацией
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: const Color.fromRGBO(226, 223, 204, 1),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ExtendedDataReceivedPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Анимация для входящего экрана
                      final slideIn = Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ));

                      // Анимация для уходящего экрана
                      final slideOut = Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-0.3, 0.0),
                      ).animate(CurvedAnimation(
                        parent: secondaryAnimation,
                        curve: Curves.easeInOut,
                      ));

                      // Затемнение уходящего экрана
                      final fadeOut = Tween<double>(
                        begin: 1.0,
                        end: 0.5,
                      ).animate(CurvedAnimation(
                        parent: secondaryAnimation,
                        curve: Curves.easeInOut,
                      ));

                      return SlideTransition(
                        position: slideOut,
                        child: FadeTransition(
                          opacity: fadeOut,
                          child: SlideTransition(
                            position: slideIn,
                            child: child,
                          ),
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    reverseTransitionDuration: const Duration(milliseconds: 200),
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
