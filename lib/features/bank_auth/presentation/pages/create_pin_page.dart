import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reserv_plus/features/bank_auth/presentation/pages/confirm_pin_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

/// Страница создания PIN-кода (4 цифры)
class CreatePinPage extends StatefulWidget {
  const CreatePinPage({super.key});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  final List<int> _pin = [];
  static const int _pinLength = 4;
  String? _pressedButton;

  void _addDigit(int digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin.add(digit);
      });

      // Если PIN введён полностью, переходим на подтверждение
      if (_pin.length == _pinLength) {
        _navigateToConfirmPin();
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  void _navigateToConfirmPin() {
    final pinCode = _pin.join();
    NavigationUtils.pushWithHorizontalAnimation(
      context: context,
      page: ConfirmPinPage(originalPin: pinCode),
    ).then((_) {
      // Очищаем PIN при возврате
      if (mounted) {
        setState(() {
          _pin.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Показываем системные панели
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
        children: [
          // Заголовок
          const Padding(
            padding: EdgeInsets.only(left: 24, top: 10, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Придумайте код\nз 4 цифр',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Цей код ви будете вводити для входу у застосунок Резерв+.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),

          // Индикаторы PIN-кода
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pinLength,
              (index) => Container(
                margin: const EdgeInsets.all(12),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: index < _pin.length ? Colors.black : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: 80),

          // Цифровая клавиатура
          _buildNumberPad(),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (j) {
              int number = i * 3 + j + 1;
              return _buildNumberButton(number.toString());
            }),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Пустое место слева (вместо биометрии)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
              ),
            ),
            // Кнопка 0

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildNumberButton('0'),
            ),
            // Кнопка удаления
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _pressedButton = 'delete';
                  });
                },
                onTapUp: (_) async {
                  await Future.delayed(const Duration(milliseconds: 150));
                  if (!mounted) return;
                  setState(() {
                    _pressedButton = null;
                  });
                  _removeDigit();
                },
                onTapCancel: () {
                  setState(() {
                    _pressedButton = null;
                  });
                },
                child: ClipPath(
                  clipper: _DeleteButtonClipper(),
                  child: Container(
                    width: 40,
                    height: 30,
                    color: _pressedButton == 'delete'
                        ? Colors.black
                        : Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.close,
                          color: _pressedButton == 'delete'
                              ? Colors.white
                              : Colors.black,
                          size: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    final isPressed = _pressedButton == number;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressedButton = number;
          });
        },
        onTapUp: (_) async {
          await Future.delayed(const Duration(milliseconds: 150));
          if (!mounted) return;
          setState(() {
            _pressedButton = null;
          });
          _addDigit(int.parse(number));
        },
        onTapCancel: () {
          setState(() {
            _pressedButton = null;
          });
        },
        child: CircleAvatar(
          radius: 32,
          backgroundColor: isPressed ? Colors.black : Colors.white,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: isPressed ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

/// Clipper для кнопки удаления со срезанным левым углом (форма бирки/тега)
class _DeleteButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final arrowWidth = size.width * 0.35;
    const radius = 6.0;
    const tipRadius = 3.0;

    path.moveTo(arrowWidth + radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);
    path.lineTo(arrowWidth + radius, size.height);
    path.quadraticBezierTo(arrowWidth, size.height, arrowWidth - tipRadius,
        size.height - tipRadius);
    path.lineTo(tipRadius, size.height / 2 + tipRadius);
    path.quadraticBezierTo(
        0, size.height / 2, tipRadius, size.height / 2 - tipRadius);
    path.lineTo(arrowWidth - tipRadius, tipRadius);
    path.quadraticBezierTo(arrowWidth, 0, arrowWidth + radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
