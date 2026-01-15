import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';

class FixDataRequestDetailPage extends StatelessWidget {
  const FixDataRequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildSubtitle(),
                  const SizedBox(height: 20),
                  _buildDescription(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Запит на виправлення даних відправлено',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      'Згодом ви отримаєте сповіщення про статус запиту.',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.1,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Якщо запит неможливо отримати з технічних причин, застосунок також повідомить вас про це.',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.1,
      ),
    );
  }
}
