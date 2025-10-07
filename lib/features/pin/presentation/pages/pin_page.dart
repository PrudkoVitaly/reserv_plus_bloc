import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:reserv_plus/features/registry/presentation/pages/registry_page.dart';
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
    // Запускаем инициализацию BLoC
    context.read<PinBloc>().add(const PinStarted());

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
    Size size = MediaQuery.of(context).size;

    return BlocListener<PinBloc, PinState>(
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
        }
      },
      child: BlocBuilder<PinBloc, PinState>(builder: (context, state) {
        bool isContainerVisible = false;
        int pinLength = 0;
        bool isBiometricsAvailable = false;

        if (state is PinInitial) {
          isContainerVisible = state.isBiometricsModalVisible;
          isBiometricsAvailable = state.isBiometricsAvailable;
        } else if (state is PinEntering) {
          isContainerVisible = state.isBiometricsModalVisible;
          pinLength = state.enteredPin.length;
          isBiometricsAvailable = state.isBiometricsAvailable;
        } else if (state is PinValidating) {
          pinLength = 4; // Показываем все 4 точки при валидации
          isBiometricsAvailable = false;
        } else if (state is PinError) {
          isContainerVisible = state.isBiometricsModalVisible;
          pinLength = state.enteredPin.length;
          isBiometricsAvailable = state.isBiometricsAvailable;
        }

        return GestureDetector(
          onTap: () {
            if (isContainerVisible) {
              context.read<PinBloc>().add(const PinBiometricsCancelled());
            }
          },
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Восстановление кода')),
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
              if (isContainerVisible)
                AnimatedOpacity(
                  alwaysIncludeSemantics: true,
                  duration: const Duration(milliseconds: 900),
                  opacity: 0.5,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                bottom: isContainerVisible ? 0 : -400,
                left: 0,
                right: 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  scale: isContainerVisible ? 1.0 : 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(20),
                    height: size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40,
                          alignment: Alignment.center,
                          child: Marquee(
                            text: "Вхід за біометричними даними",
                            fadingEdgeStartFraction: 0.2,
                            fadingEdgeEndFraction: 0.2,
                            style: const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 100.0,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(35, 34, 30, 1),
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 50,
                            color: Color.fromRGBO(70, 164, 164, 1.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Прикоснитесь к сканеру отпечатков пальцев.",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: _getAdaptiveFontSize(context, 12),
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<PinBloc>()
                                  .add(const PinBiometricsCancelled());
                            },
                            child: const Text(
                              "Скасувати",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromRGBO(70, 164, 164, 1.0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
                      context.read<PinBloc>().add(const PinBiometricsPressed());
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
}
