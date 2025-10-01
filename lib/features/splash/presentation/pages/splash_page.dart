import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/pin/presentation/pages/pin_page.dart';
import 'package:reserv_plus/features/splash/presentation/bloc/splash_event.dart';
import 'package:reserv_plus/features/splash/presentation/bloc/splash_state.dart';
import '../bloc/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Запускаем BLoC
    context.read<SplashBloc>().add(const SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PinPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(35, 34, 30, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo_invert.webp"),
                    colorFilter: ColorFilter.mode(
                      Color.fromRGBO(226, 223, 206, 1),
                      BlendMode.modulate,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Міністерство \nоборони \nУкраїни",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(226, 223, 206, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "UkraineLight",
                  letterSpacing: 2,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
