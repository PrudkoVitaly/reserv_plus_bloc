import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

class VacancyFilterPage extends StatefulWidget {
  const VacancyFilterPage({super.key});

  @override
  State<VacancyFilterPage> createState() => _VacancyFilterPageState();
}

class _VacancyFilterPageState extends State<VacancyFilterPage> {
  bool isLoading = true;
  bool isToggleActive = false;
  late int activeVacancyCount; // ✅ Для активного состояния
  late int inactiveVacancyCount; // ✅ Для неактивного состояния

  @override
  void initState() {
    super.initState();
    _generateVacancyCounts(); // ✅ Генерировать один раз
    _simulateLoading();
  }

  void _generateVacancyCounts() {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    // Генерируем оба числа один раз
    activeVacancyCount = 2100 + random.nextInt(801); // 2100-2900
    inactiveVacancyCount = 9100 + random.nextInt(801); // 9100-9900
  }

  void _toggleSwitch() {
    setState(() {
      isToggleActive = !isToggleActive;
      // ✅ НЕ генерируем новые числа!
    });
  }

  void _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isLoading
            ? const Center(
                child: DelayedLoadingIndicator(),
              )
            : Column(
                children: [
                  const SizedBox(height: 40),
                  _buildFilterHeader(context),
                  const Divider(
                    color: Color.fromARGB(255, 161, 161, 161),
                  ),
                  const SizedBox(height: 6),
                  _buildFilterRow('Війська', 'Всі'),
                  _buildFilterRow('Спеціальність', 'Всі'),
                  _buildFilterRow('Звання', 'Всі'),
                  _buildFilterRow('Підрозділи', 'Всі'),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Color.fromARGB(255, 161, 161, 161),
                    indent: 16,
                    endIndent: 16,
                  ),
                  const SizedBox(height: 20),
                  _buildToggleRow(isToggleActive, _toggleSwitch),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Показати ${isToggleActive ? activeVacancyCount : inactiveVacancyCount} вакансій',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }

  Widget _buildToggleRow(bool isToggleActive, VoidCallback onToggle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: const Icon(
        Icons.info_outline,
        size: 30,
        color: Colors.black,
      ),
      title: const Text(
        'Вакансії для\nпридатних до\nнебойової служби',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          height: 1,
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          onToggle();
        },
        child: Container(
          width: 52,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isToggleActive
                ? const Color.fromRGBO(253, 135, 12, 1)
                : const Color.fromARGB(255, 153, 153, 153),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 100),
            alignment:
                isToggleActive ? Alignment.centerRight : Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: isToggleActive ? 30 : 18,
              height: isToggleActive ? 30 : 18,
              margin: isToggleActive
                  ? const EdgeInsets.all(4)
                  : const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isToggleActive ? Colors.white : Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFilterRow(String title, String value) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    dense: true,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.black,
          fontWeight: FontWeight.w900,
        ),
      ],
    ),
    onTap: () {},
  );
}

Widget _buildFilterHeader(BuildContext context) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Очистити',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      const Center(
        child: Text(
          'Фільтр',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}
