import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_back_header.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/menu/presentation/pages/fines/no_fines_page.dart';

class FinesIntroPage extends StatefulWidget {
  const FinesIntroPage({super.key});

  @override
  State<FinesIntroPage> createState() => _FinesIntroPageState();
}

class _FinesIntroPageState extends State<FinesIntroPage> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildTitle(),
                    const SizedBox(height: 26),
                    _buildDescription(),
                    const Spacer(),
                    _buildBottomSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Штрафи онлайн',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'У цьому розділі деталі про штрафи та як їх врегулювати.',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        _buildCheckbox(),
        const SizedBox(height: 32),
        _buildStartButton(),
      ],
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _dontShowAgain = !_dontShowAgain;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: _dontShowAgain
                ? const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.black,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          const Text(
            'Більше не показувати',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          NavigationUtils.pushWithHorizontalAnimation(
            context: context,
            page: const NoFinesPage(),
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
          'Почати',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
