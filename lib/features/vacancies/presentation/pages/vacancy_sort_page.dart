import 'package:flutter/material.dart';

class VacancySortPage extends StatefulWidget {
  const VacancySortPage({super.key});

  @override
  State<VacancySortPage> createState() => _VacancySortPageState();
}

class _VacancySortPageState extends State<VacancySortPage> {
  String selectedSort = 'Від найновішої до найстарішої';

  final List<String> sortOptions = [
    'Від найновішої до найстарішої',
    'Від найстарішої до найновішої',
    'Від А до Я',
    'Від Я до А',
    'Найбільш популярні',
    'Найменш популярні',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Stack(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 28),
                  ),
                ],
              ),
              const Positioned.fill(
                child: Center(
                  child: Text(
                    'Сортування',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final option = sortOptions[index];

                return Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                      ),
                      child: RadioListTile<String>(
                        title: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                        value: option,
                        groupValue: selectedSort,
                        onChanged: (String? value) {
                          setState(() {
                            selectedSort = value!;
                          });
                        },
                        activeColor: const Color.fromRGBO(253, 135, 12, 1),
                        contentPadding: const EdgeInsets.symmetric(vertical: 6),
                        dense: true,
                      ),
                    ),
                    if (index % 2 == 1 && index < sortOptions.length - 1)
                      const Column(
                        children: [
                          SizedBox(height: 14),
                          Divider(
                            color: Colors.grey,
                            height: 1,
                            indent: 12,
                            endIndent: 12,
                          ),
                          SizedBox(height: 14),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Застосувати',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
