import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/forgot_pin/presentation/pages/forgot_pin_page.dart';
import 'package:reserv_plus/features/registry/presentation/pages/registry_page.dart';
import 'package:reserv_plus/features/biometric/presentation/bloc/biometric_bloc.dart';
import 'package:reserv_plus/features/biometric/presentation/bloc/biometric_event.dart';
import 'package:reserv_plus/features/biometric/presentation/bloc/biometric_state.dart';
import '../bloc/pin_bloc.dart';
import '../bloc/pin_event.dart';
import '../bloc/pin_state.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> with TickerProviderStateMixin {
  String? _pressedButton;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    // // Возвращаем обычный режим при возврате на PIN экран
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Запускаем инициализацию BLoC
    context.read<PinBloc>().add(const PinStarted());

    // Автоматически показываем системный диалог биометрии при загрузке
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSystemBiometricDialog(context);
    });

    // Инициализация анимации дрожи
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -25.0),
        weight: 25.0, // 50ms из 200ms
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -45.0, end: 25.0),
        weight: 25.0, // 50ms
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 45.0, end: -25.0),
        weight: 25.0, // 50ms
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -25.0, end: 0.0),
        weight: 25.0, // 50ms
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

  // Функция для расчета адаптивного размера текста
  double _getAdaptiveFontSize(BuildContext context, double maxSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Базовый размер на основе меньшей стороны экрана для лучшей адаптивности
    double baseSize =
        (screenWidth < screenHeight ? screenWidth : screenHeight) * 0.03;

    // Ограничиваем максимальным размером
    return baseSize > maxSize ? maxSize : baseSize;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BiometricBloc, BiometricState>(
      listener: (context, state) {
        if (state is BiometricAuthenticationSuccess) {
          // Переходим на главный экран при успешной аутентификации
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RegistryPage()),
          );
        }
        // При отмене биометрии просто остаемся на экране PIN
        // Пользователь может ввести код вручную
      },
      child: BlocListener<PinBloc, PinState>(
        listener: (context, state) {
          if (state is PinSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const RegistryPage(),
              ),
            );
          } else if (state is PinError) {
            // Запускаем анимацию дрожи один раз при ошибке
            _shakeController.reset();
            _shakeController.forward();
            context.read<PinBloc>().add(const PinReset());
          } else if (state is PinShaking) {
            // Запускаем анимацию дрожи при удалении
            _shakeController.reset();
            _shakeController.forward();
          }
        },
        child: BlocBuilder<PinBloc, PinState>(builder: (context, state) {
          int pinLength = 0;
          bool isBiometricsAvailable = false;

          if (state is PinInitial) {
            isBiometricsAvailable = state.isBiometricsAvailable;
          } else if (state is PinEntering) {
            pinLength = state.enteredPin.length;
            isBiometricsAvailable = state.isBiometricsAvailable;
          } else if (state is PinValidating) {
            pinLength = 4; // Показываем все 4 точки при валидации
            isBiometricsAvailable = false;
          } else if (state is PinError) {
            pinLength = state.enteredPin.length;
            isBiometricsAvailable = state.isBiometricsAvailable;
          } else if (state is PinShaking) {
            pinLength = 0; // При удалении точки сразу исчезают
            isBiometricsAvailable = state.isBiometricsAvailable;
          }

          return GestureDetector(
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: AppBar(
                      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
                    ),
                  ),
                  body: Column(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Код для входу',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                4, // Assuming PIN length is 4
                                (index) => Container(
                                  margin: const EdgeInsets.all(12),
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: index < pinLength
                                        ? Colors.black
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                      _buildNumberPad(context, isBiometricsAvailable),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ForgotPinPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Не пам\'ятаю код для входу',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumberPad(BuildContext context, bool isBiometricsAvailable) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (j) {
              int number = i * 3 + j + 1;
              return _buildNumberButton(context, number.toString());
            }),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: isBiometricsAvailable
                  ? (_) {
                      setState(() {
                        _pressedButton = 'biometrics';
                      });
                    }
                  : null,
              onTapUp: isBiometricsAvailable
                  ? (_) async {
                      await Future.delayed(const Duration(milliseconds: 150));
                      setState(() {
                        _pressedButton = null;
                      });
                      // Показываем системный диалог биометрии
                      _showSystemBiometricDialog(context);
                    }
                  : null,
              onTapCancel: isBiometricsAvailable
                  ? () {
                      setState(() {
                        _pressedButton = null;
                      });
                    }
                  : null,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                // backgroundColor: _pressedButton == 'biometrics'
                //     ? Colors.black
                //     : Colors.white,
                child: Icon(
                  Icons.fingerprint_sharp,
                  size: 50,
                  color: _pressedButton == 'biometrics'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildNumberButton(context, '0'),
            ),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _pressedButton = 'delete';
                });
              },
              onTapUp: (_) async {
                await Future.delayed(const Duration(milliseconds: 150));
                setState(() {
                  _pressedButton = null;
                });
                context.read<PinBloc>().add(const PinDeletePressed());
              },
              onTapCancel: () {
                setState(() {
                  _pressedButton = null;
                });
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color:
                      _pressedButton == 'delete' ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  color:
                      _pressedButton == 'delete' ? Colors.white : Colors.black,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(BuildContext context, String number) {
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
          // Минимальная задержка, чтобы подсветка успела показаться
          await Future.delayed(const Duration(milliseconds: 150));
          setState(() {
            _pressedButton = null;
          });
          context.read<PinBloc>().add(PinNumberPressed(number));
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

  /// Показать системный диалог биометрии Android
  void _showSystemBiometricDialog(BuildContext context) {
    // Прямо вызываем BiometricBloc для системного диалога
    context.read<BiometricBloc>().add(
          const BiometricAuthenticationRequested(),
        );
  }
}
