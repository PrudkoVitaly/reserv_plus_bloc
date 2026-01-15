import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Страница загрузки данных из реестра
class LoadingDataPage extends StatefulWidget {
  const LoadingDataPage({super.key});

  @override
  State<LoadingDataPage> createState() => _LoadingDataPageState();
}

class _LoadingDataPageState extends State<LoadingDataPage> {
  @override
  void initState() {
    super.initState();
    // Симулируем загрузку данных
    _loadData();
  }

  Future<void> _loadData() async {
    // Ждём 3 секунды для симуляции загрузки
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Восстанавливаем системные панели
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // TODO: Переход на главный экран приложения
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const HomePage()),
      //   (route) => false,
      // );

      // Пока просто показываем сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Реєстрація успішно завершена!'),
          backgroundColor: Color.fromRGBO(76, 175, 80, 1),
          duration: Duration(seconds: 2),
        ),
      );

      // Возвращаемся на начальный экран (очищаем стек навигации)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Запрещаем возврат назад во время загрузки
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Анимированный индикатор загрузки
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Color.fromRGBO(76, 175, 80, 1),
                  ),
                ),

                const SizedBox(height: 40),

                // Текст загрузки
                const Text(
                  'Отримуємо інформацію\nз реєстру',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Подсказка
                const Text(
                  'Це може зайняти деякий час',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(100, 100, 100, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
