import 'package:flutter/material.dart';

class AlreadySubmittedPage extends StatelessWidget {
  const AlreadySubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIcon(),
                      const SizedBox(height: 40),
                      _buildTitle(),
                      const SizedBox(height: 20),
                      _buildSubtitle(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      'images/attention_image.png',
      width: 170,
      height: 170,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Ви вже подали\nзапит',
      style: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      'Тож заваріть чаю і очікуйте\nна результат',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
            splashFactory: NoSplash.splashFactory,
            shadowColor: Colors.transparent,
            overlayColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          child: const Text(
            'Зрозуміло',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
