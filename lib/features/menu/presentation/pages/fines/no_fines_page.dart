import 'package:flutter/material.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/menu/presentation/pages/fines/checking_fines_page.dart';

class NoFinesPage extends StatelessWidget {
  const NoFinesPage({super.key});

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
                      _buildDescription(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      'images/ok_square_icon.png',
      width: 170,
      height: 170,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Штрафів немає',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Ми повідомимо вам, якщо виявимо порушення, за яке можна буде сплатити штраф онлайн.',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildUnderstandButton(context),
          const SizedBox(height: 22),
          _buildCheckAgainButton(context),
        ],
      ),
    );
  }

  Widget _buildUnderstandButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
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
    );
  }

  Widget _buildCheckAgainButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationUtils.pushWithHorizontalAnimation(
          context: context,
          page: const CheckingFinesPage(),
        );
      },
      child: const Text(
        'Перевірити ще раз',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
