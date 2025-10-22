import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/vacancies/presentation/pages/vacancy_categories_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

class VacancyFilterPage extends StatefulWidget {
  const VacancyFilterPage({super.key});

  @override
  State<VacancyFilterPage> createState() => _VacancyFilterPageState();
}

class _VacancyFilterPageState extends State<VacancyFilterPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
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
                  _buildToggleRow(),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      NavigationUtils.pushWithVerticalAnimation(
                        context: context,
                        page: const VacancyCategoriesPage(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Показати 9539 вакансій',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
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

Widget _buildFilterRow(String title, String value) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    dense: true,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
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
        ),
      ],
    ),
    onTap: () {},
  );
}

Widget _buildToggleRow() {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    leading: const Icon(Icons.info_outline, size: 30, color: Colors.black),
    title: const Text(
      'Вакансії для придатних до небойової служби',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1,
      ),
    ),
    trailing: Switch(
      value: false,
      onChanged: (value) {},
    ),
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
            padding: const EdgeInsets.only(right: 16),
            child: const Text(
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
