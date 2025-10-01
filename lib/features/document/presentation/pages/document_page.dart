import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';
import '../widgets/document_modal.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Инициализация контроллера анимации
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Анимация вращения
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация масштабирования
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Загружаем данные документа
    context.read<DocumentBloc>().add(const DocumentLoadData());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentLoaded && state.isFlipping) {
          if (state.isFrontVisible) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
        body: BlocBuilder<DocumentBloc, DocumentState>(
          builder: (context, state) {
            if (state is DocumentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DocumentUpdating) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Оновлення документу...'),
                  ],
                ),
              );
            } else if (state is DocumentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    Text('Помилка: ${state.message}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<DocumentBloc>()
                            .add(const DocumentLoadData());
                      },
                      child: const Text('Спробувати знову'),
                    ),
                  ],
                ),
              );
            } else if (state is DocumentLoaded) {
              return _buildDocumentContent(state, size);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildDocumentContent(DocumentLoaded state, Size size) {
    return GestureDetector(
      onTap: () {
        if (state.isModalVisible) {
          context.read<DocumentBloc>().add(const DocumentHideModal());
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildDocumentCard(state, size),
                ],
              ),
            ),
          ),
          if (state.isModalVisible) const DocumentModal(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Text(
              "Резерв",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              top: 6,
              right: -20,
              child: Image.asset(
                "images/res_plus.png",
                width: 20,
                color: const Color.fromRGBO(253, 135, 12, 1),
              ),
            ),
          ],
        ),
        const Spacer(),
        const Text(
          "Сканувати \nдокумент",
          style: TextStyle(
            height: 1,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(width: 6),
        Image.asset(
          "images/qr.png",
          width: 30,
        ),
      ],
    );
  }

  Widget _buildDocumentCard(DocumentLoaded state, Size size) {
    return GestureDetector(
      onTap: () {
        context.read<DocumentBloc>().add(const DocumentFlipCard());
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _rotationAnimation.value * 3.1415926535897932;
          final isFrontVisible = angle <= 3.1415926535897932 / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: isFrontVisible
                  ? _buildFrontCard(state, size)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1415926535897932),
                      child: _buildBackCard(state, size),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(DocumentLoaded state, Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.71,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(156, 152, 135, 1),
          width: 1.5,
        ),
        color: const Color.fromRGBO(212, 210, 189, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Військово\n-обліковий\nдокумент",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
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
                            Color.fromRGBO(212, 210, 189, 1),
                            BlendMode.difference,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset("images/ok_icon.png", width: 18),
                    const SizedBox(width: 10),
                    const Text(
                      "Дані уточнено вчасно",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Дата народження:",
                  style: TextStyle(
                    color: Color.fromRGBO(106, 103, 88, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  state.data.birthDate,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    wordSpacing: 0.1,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.15),
          Container(
            width: double.infinity,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(150, 148, 134, 1),
            ),
            child: Marquee(
              text: state.data.formattedLastUpdated,
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
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.data.status,
                        style: const TextStyle(
                          color: Color.fromRGBO(106, 103, 88, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.data.lastName} ${state.data.firstName}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            state.data.patronymic,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(253, 135, 12, 1),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                  onPressed: () {
                    context.read<DocumentBloc>().add(const DocumentShowModal());
                  },
                  child: Image.asset("images/three_dots.png", width: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(DocumentLoaded state, Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(156, 152, 135, 1),
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Код дійсний до ${state.data.validityDate}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(state.data.qrCode, width: 260),
          ],
        ),
      ),
    );
  }
}
