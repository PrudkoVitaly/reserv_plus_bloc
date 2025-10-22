import 'package:flutter/material.dart';
import 'package:reserv_plus/features/extended_data/domain/entities/extended_data.dart';
import 'package:reserv_plus/features/support/presentation/pages/support_page.dart';

class ExtendedDataReviewPage extends StatelessWidget {
  final ExtendedData data;

  const ExtendedDataReviewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        elevation: 0,
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 34.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SupportPage(),
                    ),
                  );
                },
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
          'Уточнення\nконтактних даних',
          style: TextStyle(
              color: Colors.black,
              fontSize:34,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
            // Номер телефону
            _buildContactField(
              label: 'Номер телефону',
              value: _formatPhone(data.phone),
            ),
            
            const SizedBox(height: 24),
            
            // Адреса проживання
            _buildContactField(
              label: 'Адреса проживання',
              value: data.address,
            ),
            
            const SizedBox(height: 24),
            
            // Email адреса
            _buildContactField(
              label: 'Email адреса',
              value: data.email,
            ),
            
          ],
        ),
      ),
    );
  }

  String _formatPhone(String phone) {
    // Форматируем номер телефона в формат +380 95 361 4443
    if (phone.length >= 12) {
      return '+${phone.substring(0, 3)} ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8, 12)}';
    }
    return phone;
  }

  Widget _buildContactField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(221, 99, 99, 99),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 138, 138, 138)),
          
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}