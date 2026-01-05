import 'package:flutter/material.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_back_header.dart';
import 'package:reserv_plus/features/menu/presentation/pages/fix_data/request_sent_page.dart';

class DescribeSituationPage extends StatefulWidget {
  const DescribeSituationPage({super.key});

  @override
  State<DescribeSituationPage> createState() => _DescribeSituationPageState();
}

class _DescribeSituationPageState extends State<DescribeSituationPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomBackHeader(title: 'Опишіть ситуацію'),
                    const SizedBox(height: 8),
                    _buildTextField(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: _textController,
        maxLines: 4,
        minLines: 1,
        decoration: InputDecoration(
          hintText: 'Текстовий опис ситуації',
          hintStyle: const TextStyle(
            color: Color.fromRGBO(106, 103, 88, 0.6),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromRGBO(106, 103, 88, 0.6),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromRGBO(106, 103, 88, 0.6),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromRGBO(106, 103, 88, 0.6),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            NavigationUtils.pushWithHorizontalAnimation(
              context: context,
              page: const RequestSentPage(),
            );
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
            'Надіслати',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
