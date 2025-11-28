import 'package:flutter/material.dart';
import 'package:reserv_plus/features/faq/domain/entities/faq_item.dart';

class FaqDetailPage extends StatefulWidget {
  final FaqItem faqItem;

  const FaqDetailPage({
    super.key,
    required this.faqItem,
  });

  @override
  State<FaqDetailPage> createState() => _FaqDetailPageState();
}

class _FaqDetailPageState extends State<FaqDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _questionKey = GlobalKey();
  bool _showDivider = false;
  double _bottomGradientOpacity = 0.0;
  double _dividerTop = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDividerPosition();
      _checkScrollPosition();
    });
  }

  void _checkScrollPosition() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final distanceToEnd = maxScroll - currentScroll;
      final newOpacity = _calculateGradientOpacity(distanceToEnd);
      if ((newOpacity - _bottomGradientOpacity).abs() > 0.01) {
        setState(() {
          _bottomGradientOpacity = newOpacity;
        });
      }
    }
  }

  double _calculateGradientOpacity(double distanceToEnd) {
    // Градиент плавно появляется когда осталось больше 50px до конца
    // И плавно исчезает когда осталось меньше 50px
    if (distanceToEnd > 50) {
      return 1.0; // Полностью видимый
    } else if (distanceToEnd > 0) {
      return distanceToEnd / 50; // Плавное исчезание от 1.0 до 0.0
    } else {
      return 0.0; // Полностью невидимый
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateDividerPosition() {
    final RenderBox? renderBox =
        _questionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      setState(() {
        _dividerTop = position.dy + size.height + 26;
      });
    }
  }

  void _onScroll() {
    final shouldShowDivider = _scrollController.offset > 0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final distanceToEnd = maxScroll - currentScroll;
    final newOpacity = _calculateGradientOpacity(distanceToEnd);

    if (shouldShowDivider != _showDivider ||
        (newOpacity - _bottomGradientOpacity).abs() > 0.01) {
      setState(() {
        _showDivider = shouldShowDivider;
        _bottomGradientOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    key: _questionKey,
                    widget.faqItem.question,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    child: Text(
                      widget.faqItem.answer,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showDivider)
            Positioned(
              left: 0,
              right: 0,
              top: _dividerTop,
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[400],
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _bottomGradientOpacity,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromRGBO(226, 223, 204, 1)
                            .withValues(alpha: 0),
                        const Color.fromRGBO(226, 223, 204, 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
