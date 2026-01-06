import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/support/data/repositories/support_repository_impl.dart';
import '../bloc/support_bloc.dart';
import '../bloc/support_event.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(
        repository: SupportRepositoryImpl(),
      )..add(const SupportInitialized()),
      child: const SupportView(),
    );
  }
}

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showSuccessIcon = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Анимация масштаба: быстрое появление, задержка 0.8 сек, быстрое исчезновение
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 16.7, // 0.2 сек из 1.2
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 66.6, // 0.8 сек из 1.2
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 16.7, // 0.2 сек из 1.2
      ),
    ]).animate(_animationController);

    // Анимация прозрачности: быстрое появление и исчезновение
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 12.5, // 0.15 сек из 1.2
      ),
      // Держим прозрачность (1 -> 1) 0.9 секунд
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 75.0, // 0.9 сек из 1.2
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 12.5, // 0.15 сек из 1.2
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCopyDeviceNumber() {
    setState(() {
      _showSuccessIcon = true;
    });

    _animationController.forward().then((_) {
      setState(() {
        _showSuccessIcon = false;
      });
      _animationController.reset();
    });

    // Отправляем событие в BLoC
    context.read<SupportBloc>().add(const SupportCopyDeviceNumber());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 26,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Служба підтримки',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Маєте додаткові питання про послуги або виникла проблема із застосунком? Чатбот підкаже, що робити.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                height: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                context.read<SupportBloc>().add(const SupportOpenViber());
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "images/viber.png",
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Viber',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              color: Colors.black.withValues(alpha: 0.1),
              thickness: 1,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _onCopyDeviceNumber,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.copy,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Копіювати номер пристрою',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Анимированная иконка успеха
                  if (_showSuccessIcon)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 18,
                              height: 18,
                              margin: const EdgeInsets.only(left: 12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
