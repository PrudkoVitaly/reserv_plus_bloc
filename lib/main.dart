import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/splash/data/repositories/splash_repository_impl.dart';
import 'features/pin/presentation/bloc/pin_bloc.dart';
import 'features/pin/data/repositories/pin_repository_impl.dart';
import 'features/registry/presentation/bloc/registry_bloc.dart';
import 'features/registry/data/repositories/registry_repository_impl.dart';
import 'features/main/presentation/bloc/main_bloc.dart';
import 'features/main/data/repositories/navigation_repository_impl.dart';
import 'features/document/presentation/bloc/document_bloc.dart';
import 'features/document/data/repositories/document_repository_impl.dart';
import 'features/document/presentation/bloc/person_info_bloc.dart';
import 'features/loading/presentation/bloc/loading_bloc.dart';
import 'features/loading/data/repositories/loading_repository_impl.dart';
import 'features/request_sent/presentation/bloc/request_sent_bloc.dart';
import 'features/request_sent/data/repositories/request_sent_repository_impl.dart';
import 'features/biometric/presentation/bloc/biometric_bloc.dart';
import 'features/biometric/data/services/biometric_auth_service.dart';
import 'features/biometric/data/repositories/biometric_repository_impl.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'features/vacancies/data/repositories/vacancies_repository_impl.dart';

void main() async {
  // Инициализируем WidgetsBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем бежевый цвет navigation bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color.fromRGBO(226, 223, 204, 1),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Получаем SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Создаем один экземпляр NotificationRepositoryImpl для переиспользования
    final notificationRepository = NotificationRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc(
            repository: SplashRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => PinBloc(
            repository: PinRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => RegistryBloc(
            repository: RegistryRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => MainBloc(
            repository: NavigationRepositoryImpl(
              notificationRepository: notificationRepository,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DocumentBloc(
            repository: DocumentRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => LoadingBloc(
            repository: LoadingRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => PersonInfoBloc(),
        ),
        BlocProvider(
          create: (context) => RequestSentBloc(
            repository: RequestSentRepositoryImpl(),
          ),
        ),
        // BiometricBloc
        BlocProvider(
          create: (context) => BiometricBloc(
            repository: BiometricRepositoryImpl(
              biometricAuthService: BiometricAuthService(
                localAuth: LocalAuthentication(),
              ),
              sharedPreferences: prefs,
            ),
          ),
        ),
        // NotificationBloc
        BlocProvider(
          create: (context) => NotificationBloc(
            repository: notificationRepository,
          ),
        ),
        // VacanciesBloc - глобальный чтобы не пересоздавался при переключении табов
        BlocProvider(
          create: (context) => VacanciesBloc(
            repository: VacanciesRepositoryImpl(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Резерв+',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
