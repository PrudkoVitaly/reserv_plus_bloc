import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reserv_plus/features/bank_auth/presentation/pages/biometric_permission_page.dart';
import 'package:reserv_plus/features/pin/data/services/pin_storage_service.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

/// Страница подтверждения PIN-кода
class ConfirmPinPage extends StatefulWidget {
  final String originalPin;

  const ConfirmPinPage({
    super.key,
    required this.originalPin,
  });

  @override
  State<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage>
    with SingleTickerProviderStateMixin {
  final List<int> _pin = [];
  static const int _pinLength = 4;
  String? _pressedButton;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    // Инициализация анимации дрожи
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -25.0),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -45.0, end: 25.0),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 45.0, end: -25.0),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -25.0, end: 0.0),
        weight: 25.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _addDigit(int digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin.add(digit);
      });

      // Если PIN введён полностью, проверяем совпадение
      if (_pin.length == _pinLength) {
        _verifyPin();
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

  void _verifyPin() async {
    final enteredPin = _pin.join();
    if (enteredPin == widget.originalPin) {
      // PIN совпадает - сохраняем в защищённое хранилище
      final pinStorage = PinStorageService();
      await pinStorage.savePin(enteredPin);

      // Переходим к биометрии
      _navigateToBiometric();
    } else {
      // PIN не совпадает - показываем дрожь и вибрацию, затем возвращаемся
      HapticFeedback.mediumImpact();
      _shakeController.reset();
      _shakeController.forward().then((_) {
        // После анимации возвращаемся на CreatePinPage
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  void _navigateToBiometric() {
    NavigationUtils.pushWithHorizontalAnimation(
      context: context,
      page: const BiometricPermissionPage(),
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Стрелка назад
            const AppHeader(),
            // Заголовок
            const Padding(
              padding: EdgeInsets.only(left: 24, top: 10, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Повторіть код з\n4 цифр',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Підтвердьте код.',
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

            // Индикаторы PIN-кода с анимацией дрожи
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pinLength,
                      (index) => Container(
                        margin: const EdgeInsets.all(12),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              index < _pin.length ? Colors.black : Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 80),

            // Цифровая клавиатура
            _buildNumberPad(),
          ],
        ),
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
