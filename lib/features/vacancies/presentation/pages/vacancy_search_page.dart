import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

class VacancySearchPage extends StatefulWidget {
  const VacancySearchPage({super.key});

  @override
  State<VacancySearchPage> createState() => _VacancySearchPageState();
}

class _VacancySearchPageState extends State<VacancySearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Stack(
        children: [
          Column(
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
                        'Пошук',
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
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Пошук вакансій',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 161, 161, 161),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 161, 161, 161),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 161, 161, 161),
                        width: 1,
                      ),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: AnimatedOpacity(
                        opacity: _searchController.text.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: _searchController.text.isNotEmpty
                              ? () {
                                  _searchController.clear();
                                  setState(() {});
                                }
                              : null,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(226, 223, 204, 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Условный лоадинг по центру экрана
          if (_searchController.text.isNotEmpty)
            const Center(
              child: DelayedLoadingIndicator(),
            ),
        ],
      ),
    );
  }
}
