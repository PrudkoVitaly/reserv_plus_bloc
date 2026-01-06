import 'package:flutter/material.dart';

class AnimatedTabSwitcher extends StatefulWidget {
  final int currentIndex;
  final List<Widget> children;
  final Duration duration;

  const AnimatedTabSwitcher({
    super.key,
    required this.currentIndex,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedTabSwitcher> createState() => _AnimatedTabSwitcherState();
}

class _AnimatedTabSwitcherState extends State<AnimatedTabSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideInAnimation;
  late Animation<Offset> _slideOutAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;

  int _previousIndex = 0;
  int _currentIndex = 0;

  // Храним созданные виджеты чтобы они не пересоздавались
  late List<Widget> _cachedChildren;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _currentIndex = widget.currentIndex;

    // Инициализируем ВСЕ виджеты сразу чтобы не было дергания при первом показе
    _cachedChildren = List.generate(
      widget.children.length,
      (index) => RepaintBoundary(
        key: ValueKey('tab_$index'),
        child: widget.children[index],
      ),
    );

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    // Более мягкая кривая для плавного перехода
    const curve = Curves.easeInOutCubic;

    // Новый экран въезжает справа (меньшее смещение для мягкости)
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    // Старый экран уезжает влево (меньшее смещение)
    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    // Fade in для входящего экрана
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Fade out для уходящего экрана
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
  }

  @override
  void didUpdateWidget(AnimatedTabSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = widget.currentIndex;
      });
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final isAnimating = _controller.isAnimating;

        return ClipRect(
          child: Stack(
            children: [
              // Все экраны держим в памяти
              for (int i = 0; i < _cachedChildren.length; i++)
                _buildPositionedChild(i, isAnimating),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositionedChild(int index, bool isAnimating) {
    final isActive = index == _currentIndex;
    final isPrevious = index == _previousIndex && isAnimating;
    final shouldShow = isActive || isPrevious;

    // TickerMode enabled для активного И для уходящего (во время анимации)
    // чтобы не было перестройки виджета при смене состояния
    final tickerEnabled = isActive || isPrevious;

    return Offstage(
      offstage: !shouldShow,
      child: TickerMode(
        enabled: tickerEnabled,
        child: _buildAnimatedChild(index, isAnimating),
      ),
    );
  }

  Widget _buildAnimatedChild(int index, bool isAnimating) {
    final child = _cachedChildren[index];

    if (!isAnimating) {
      return child;
    }

    if (index == _currentIndex) {
      // Входящий экран - slide + fade in
      return FadeTransition(
        opacity: _fadeInAnimation,
        child: SlideTransition(
          position: _slideInAnimation,
          child: child,
        ),
      );
    } else if (index == _previousIndex) {
      // Уходящий экран - slide + fade out
      return FadeTransition(
        opacity: _fadeOutAnimation,
        child: SlideTransition(
          position: _slideOutAnimation,
          child: child,
        ),
      );
    }

    return child;
  }
}
