import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import '../bloc/person_info_bloc.dart';
import '../bloc/person_info_event.dart';
import '../bloc/person_info_state.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:reserv_plus/features/document/presentation/bloc/document_bloc.dart';
import 'package:reserv_plus/features/document/presentation/bloc/document_state.dart';
import '../../domain/entities/person_info.dart';

class PersonInfoModalContent extends StatefulWidget {
  final ScrollController scrollController;

  const PersonInfoModalContent({
    super.key,
    required this.scrollController,
  });

  @override
  State<PersonInfoModalContent> createState() => _PersonInfoModalContentState();
}

class _PersonInfoModalContentState extends State<PersonInfoModalContent> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при открытии модального окна
    context.read<PersonInfoBloc>().add(PersonInfoLoadData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonInfoBloc, PersonInfoState>(
      builder: (context, state) {
        if (state is PersonInfoLoading) {
          return _buildLoadingState();
        } else if (state is PersonInfoLoaded) {
          return _buildLoadedState(state.personInfo);
        } else if (state is PersonInfoError) {
          return _buildErrorState(state.message);
        }
        return _buildLoadingState();
      },
    );
  }

  String _formatFullName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.isEmpty) return fullName;

    final result = <String>[];
    for (int i = 0; i < parts.length; i++) {
      if (i == 0) {
        // Фамилия - все заглавные
        result.add(parts[i].toUpperCase());
      } else {
        // Имя и отчество - только первая заглавная
        final word = parts[i].toLowerCase();
        if (word.isNotEmpty) {
          result.add(word[0].toUpperCase() + word.substring(1));
        }
      }
    }
    return result.join('\n');
  }

  Widget _buildLoadingState() {
    return DelayedLoadingIndicator(
      color: Colors.grey.shade700,
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PersonInfoBloc>().add(PersonInfoLoadData());
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(PersonInfo personInfo) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildHeader(),
          _buildMarquee(personInfo),
          _buildContent(personInfo),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            textAlign: TextAlign.left,
            "Резерв ID",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 0.9,
            ),
          ),
          const Spacer(),
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/logo_main_screen.jpg"),
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(226, 223, 204, 1),
                  BlendMode.difference,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarquee(PersonInfo personInfo) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, documentState) {
        final isUpdating =
            documentState is DocumentLoaded && documentState.isUpdating;
        final formattedDate = documentState is DocumentLoaded
            ? documentState.data.formattedLastUpdated
            : personInfo.formattedLastUpdated;

        final backgroundColor = isUpdating
            ? const Color.fromRGBO(255, 235, 59, 1) // Жёлтый
            : const Color.fromRGBO(150, 148, 134, 1); // Серый
        final marqueeText = isUpdating
            ? " • Оновлюємо документ • Впораємось за пару годин • Дякуємо за терпіння!"
            : " • $formattedDate";

        return Container(
          width: double.infinity,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Marquee(
            key: ValueKey(isUpdating),
            text: marqueeText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 0.1,
            ),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            velocity: isUpdating ? 40.0 : 20.0,
            startPadding: 10.0,
          ),
        );
      },
    );
  }

  Widget _buildContent(PersonInfo personInfo) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 4),
          _buildPersonCard(personInfo),
          const SizedBox(height: 8),
          _buildExclusionReasonCard(personInfo),
          const SizedBox(height: 10),
          _buildVlcCard(personInfo),
          const SizedBox(height: 10),
          _buildTckCard(personInfo),
          const SizedBox(height: 10),
          _buildContactCard(personInfo),
          const SizedBox(height: 10),
          _buildDataUpdateCard(personInfo),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
        ],
      ),
    );
  }

  Widget _buildPersonCard(PersonInfo personInfo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatFullName(personInfo.fullName),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              personInfo.status,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Дата народження:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              personInfo.birthDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "РНОКПП:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              personInfo.rnokpp,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExclusionReasonCard(PersonInfo personInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Підстава зняття чи виключення:\n${personInfo.exclusionReason}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildVlcCard(PersonInfo personInfo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Постанова ВЛК:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  personInfo.vlcDecision.replaceAll('\n', ' '),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            color: Color.fromRGBO(234, 235, 228, 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  "Дата ВЛК:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const Spacer(),
                Text(
                  personInfo.vlcDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTckCard(PersonInfo personInfo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ТЦК та СП:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Амур-Нижньодніпровський районний у місті Дніпро ТЦК та СП",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            color: Color.fromRGBO(234, 235, 228, 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Звання",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      personInfo.rank,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      "ВОС:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      personInfo.vos,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Категорія обліку:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  personInfo.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  personInfo.position,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Номер в реєстрі Оберіг:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  personInfo.registrationNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(PersonInfo personInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Телефон",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            personInfo.phone,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.1),
          ),
          const SizedBox(height: 10),
          const Text(
            "Email:",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.1),
          ),
          const SizedBox(height: 5),
          Text(
            personInfo.email,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.1),
          ),
          const SizedBox(height: 10),
          const Text(
            "Адреса проживання:",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.1),
          ),
          const SizedBox(height: 5),
          Text(
            personInfo.address.replaceAll('\n', ' '),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.1),
          ),
        ],
      ),
    );
  }

  Widget _buildDataUpdateCard(PersonInfo personInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/ok_icon.png",
                    width: 18,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Дані уточнено вчасно",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Дата останнього\nуточнення даних:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Text(
                    personInfo.dataUpdateDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
