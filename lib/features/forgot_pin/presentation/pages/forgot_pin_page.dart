import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv_plus/features/forgot_pin/data/repository/forgot_pin_repository_impl.dart';
import 'package:reserv_plus/features/forgot_pin/presentation/bloc/forgot_pin_bloc.dart';
import 'package:reserv_plus/features/forgot_pin/presentation/bloc/forgot_pin_event.dart';
import 'package:reserv_plus/features/forgot_pin/presentation/bloc/forgot_pin_state.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';

class ForgotPinPage extends StatelessWidget {
  const ForgotPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Скрываем панели сразу при создании экрана
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            // Возвращаем панели при возврате назад
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          }
        },
        child: BlocProvider<ForgotPinBloc>(
          create: (context) => ForgotPinBloc(
            repository: ForgotPinRepositoryImpl(),
          )..add(ForgotPinInitialized()),
          child: const ForgotPinView(),
        ));
  }
}

class ForgotPinView extends StatelessWidget {
  const ForgotPinView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPinBloc, ForgotPinState>(
      listener: (context, state) {
        if (state is ForgotPinAuthorizationSuccess) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 34.0),
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Забули код для входу?',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Пройдіть повторну авторизацію у застосунку',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Кнопка "Авторизуватися"
              BlocBuilder<ForgotPinBloc, ForgotPinState>(
                  builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: state is ForgotPinLoaded
                        ? () {
                            context
                                .read<ForgotPinBloc>()
                                .add(ForgotPinAuthorizePressed());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: state is ForgotPinAuthorizationInProgress
                        ? const DelayedLoadingIndicator()
                        : const Text(
                            'Авторизуватися',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Кнопка "Скасувати"
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Скасувати',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
