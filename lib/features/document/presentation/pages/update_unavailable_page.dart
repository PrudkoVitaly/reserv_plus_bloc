import 'package:flutter/material.dart';

class UpdateUnavailablePage extends StatelessWidget {
  const UpdateUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 34.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Иконка щита с восклицательным знаком
                    Image.asset(
                      "images/attention_image.png",
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Оновлення даних\nнедоступне',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Оновлення даних доступне один\nраз на 6 годин.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Закрываем страницу и возвращаемся назад
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                child: const Text(
                  'Зрозуміло',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
