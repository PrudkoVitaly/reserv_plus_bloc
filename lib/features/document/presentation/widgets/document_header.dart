import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class DocumentHeader extends StatelessWidget {
  final DateTime currentDate;

  const DocumentHeader({
    super.key,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 30,
            right: 30,
            bottom: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Військово-\nобліковий\nдокумент",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 0.9,
                ),
              ),
              const Spacer(),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo_main_screen.jpg"),
                    colorFilter: ColorFilter.mode(
                      Color.fromRGBO(226, 223, 204, 1),
                      BlendMode.difference,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(150, 148, 134, 1),
          ),
          child: Marquee(
            text: "Виключено - Документ оновлений О $currentDate",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(252, 251, 246, 1),
            ),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 50.0,
            velocity: 40.0,
            startPadding: 10.0,
          ),
        ),
      ],
    );
  }
}
