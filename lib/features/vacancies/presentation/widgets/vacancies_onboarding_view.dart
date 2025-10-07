import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vacancies_bloc.dart';
import '../bloc/vacancies_event.dart';

class VacanciesOnboardingView extends StatefulWidget {
  const VacanciesOnboardingView({super.key});

  @override
  State<VacanciesOnboardingView> createState() => _VacanciesOnboardingViewState();
}

class _VacanciesOnboardingViewState extends State<VacanciesOnboardingView> {
  bool _dontShowAgain = false;

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
                SizedBox(height: 60),
                const Text(
                  'Вакансії',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
            const SizedBox(height: 30),
            const Text(
              'Тут знаходяться актуальні посади\nдля служби в українському\nвійську, надані у співпраці з\nплатформою Lobby X.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Це найбільший перелік\nпропозицій, який допоможе\nзнайти ту, що підходить саме\nвам. Обирайте варіанти,\nподавайте заявки у кілька кліків і\nочікуйте відповіді від бригади',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _dontShowAgain,
                  onChanged: (value) {
                    setState(() {
                      _dontShowAgain = value ?? false;
                    });
                    context.read<VacanciesBloc>().add(
                      const VacanciesDontShowAgainToggled(),
                    );
                  },
                  activeColor: const Color.fromRGBO(253, 135, 12, 1),
                  checkColor: Colors.black,
                ),
                const Text(
                  'Більше не показувати',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<VacanciesBloc>().add(
                    const VacanciesStartPressed(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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