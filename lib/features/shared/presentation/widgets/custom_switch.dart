import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 52,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value
              ? const Color.fromRGBO(253, 135, 12, 1)
              : const Color.fromARGB(255, 153, 153, 153),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 100),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: value ? 30 : 18,
            height: value ? 30 : 18,
            margin: value
                ? const EdgeInsets.all(4)
                : const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
