import 'package:flutter/material.dart';
import 'package:reserv_plus/features/vacancies/domain/entities/vacancy.dart';

class VacancyListWidget extends StatelessWidget {
  final List<Vacancy> vacancies;

  const VacancyListWidget({
    super.key,
    required this.vacancies,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: vacancies.length,
      itemBuilder: (context, index) {
        final isFirstItem = index == 0;
        final isLastItem = index == vacancies.length - 1;
        return _buildVacancyCard(
          vacancies[index],
          isFirstItem: isFirstItem,
          isLastItem: isLastItem,
        );
      },
    );
  }

  Widget _buildVacancyCard(Vacancy vacancy, {bool isFirstItem = false, bool isLastItem = false}) {
    return Container(
      margin: EdgeInsets.only(
        left: 5,
        right: 5,
        top: isFirstItem ? 16 : 0,
        bottom: isLastItem ? 30 : 8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              vacancy.iconPath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    vacancy.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    vacancy.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
