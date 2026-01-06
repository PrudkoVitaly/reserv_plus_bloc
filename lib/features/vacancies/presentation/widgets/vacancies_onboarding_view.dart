import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import 'package:reserv_plus/features/support/presentation/pages/support_page.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_checkbox.dart';
import '../bloc/vacancies_bloc.dart';
import '../bloc/vacancies_event.dart';

class VacanciesOnboardingView extends StatefulWidget {
  const VacanciesOnboardingView({super.key});

  @override
  State<VacanciesOnboardingView> createState() =>
      _VacanciesOnboardingViewState();
}

class _VacanciesOnboardingViewState extends State<VacanciesOnboardingView> {
  bool _dontShowAgain = false;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Вакансії',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Тут знаходяться актуальні посади\nдля служби в українському\nвійську, надані у співпраці з\nплатформою Lobby X.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Це найбільший перелік\nпропозицій, який допоможе\nзнайти ту, що підходить саме\nвам. Обирайте варіанти,\nподавайте заявки у кілька кліків і\nочікуйте відповіді від бригади',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                CustomCheckbox(
                  value: _dontShowAgain,
                  onChanged: (value) {
                    setState(() {
                      _dontShowAgain = value;
                    });
                    context.read<VacanciesBloc>().add(
                          VacanciesSetDontShowAgain(_dontShowAgain),
                        );
                  },
                  label: 'Більше не показувати',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<VacanciesBloc>()
                          .add(const VacanciesStartPressed());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Почати',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 34,
            child: GestureDetector(
              onTap: _navigateToSupport,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
