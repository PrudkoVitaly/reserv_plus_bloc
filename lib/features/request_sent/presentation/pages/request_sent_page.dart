import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/request_sent_bloc.dart';
import '../bloc/request_sent_event.dart';
import '../bloc/request_sent_state.dart';
import '../../../main/presentation/pages/main_page.dart';

class RequestSentPage extends StatelessWidget {
  const RequestSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestSentBloc, RequestSentState>(
      listener: (context, state) {
        if (state is RequestSentCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(151, 148, 131, 1),
                    width: 6,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 60,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Запит відправлено",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                textAlign: TextAlign.center,
                "Запит на оновлення даних\nз реэстру відправлено. Ми\n сповістимо вас про результат.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                foregroundColor: const Color.fromRGBO(22, 1, 0, 1),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                context
                    .read<RequestSentBloc>()
                    .add(const RequestSentContinue());
              },
              child: const Text(
                "Дякую",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
