import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
            repository: NavigationRepositoryImpl(),
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
