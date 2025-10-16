import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import '../bloc/person_info_bloc.dart';
import '../bloc/person_info_event.dart';
import '../bloc/person_info_state.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import '../../domain/entities/person_info.dart';

class PersonInfoModal extends StatefulWidget {
  const PersonInfoModal({super.key});

  @override
  State<PersonInfoModal> createState() => _PersonInfoModalState();
}

class _PersonInfoModalState extends State<PersonInfoModal> {
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

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: DelayedLoadingIndicator(
        color: Colors.grey.shade700,
      ),
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
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      maxChildSize: 0.93,
      expand: false,
      builder: (context, scrollController) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(226, 223, 204, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildHeader(),
                      _buildMarquee(personInfo),
                      _buildContent(personInfo),
                    ],
                  ),
                ),
              ),
            ),
            _buildDragHandle(),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            textAlign: TextAlign.left,
            "Військово-\nобліковий\nдокумент",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
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
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(150, 148, 134, 1),
      ),
      child: Marquee(
        text: personInfo.formattedLastUpdated,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(252, 251, 246, 1),
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 50.0,
        velocity: 40.0,
        startPadding: 10.0,
      ),
    );
  }

  Widget _buildContent(PersonInfo personInfo) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 4), // Отступ сверху при скроллинге
          _buildPersonCard(personInfo),
          const SizedBox(height: 10),
          _buildExclusionReasonCard(personInfo),
          const SizedBox(height: 10),
          _buildVlcCard(personInfo),
          const SizedBox(height: 10),
          _buildTckCard(personInfo),
          const SizedBox(height: 10),
          _buildContactCard(personInfo),
          const SizedBox(height: 10),
          _buildDataUpdateCard(personInfo),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  personInfo.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  personInfo.status,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color.fromRGBO(234, 235, 228, 1),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Дата народження",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      personInfo.birthDate,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "РНОКПП",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      personInfo.rnokpp,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExclusionReasonCard(PersonInfo personInfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Підстава зняття чи виключення:\n${personInfo.exclusionReason}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildVlcCard(PersonInfo personInfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Постанова ВЛК",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                personInfo.vlcDecision,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Дата ВЛК",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 25),
              Text(
                personInfo.vlcDate,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
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
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ТЦК та СП:",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Амур-Нижньодніпровський районий територіальний центр\nкомплектування та соціальної підтримки",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color.fromRGBO(234, 235, 228, 1),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Звання",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      personInfo.rank,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "ВОС:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      personInfo.vos,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Категорія обліку:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  personInfo.category,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  personInfo.position,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Номер в реэстрації Оберіг:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  personInfo.registrationNumber,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            personInfo.phone,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Text(
            "Email:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            personInfo.email,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          const Text(
            "Адреса проживання:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            personInfo.address,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    width: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Дані уточнено вчасно",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Дата уточнення\nданих:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Text(
                    personInfo.dataUpdateDate,
                    style: const TextStyle(
                      fontSize: 18,
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

  Widget _buildDragHandle() {
    return Positioned(
      top: 20,
      left: MediaQuery.of(context).size.width / 2 - 25,
      child: Container(
        height: 5,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
