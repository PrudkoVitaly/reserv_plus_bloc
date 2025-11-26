import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/delayed_loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loading_bloc.dart';
import '../bloc/loading_state.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool showOverlay;

  const LoadingOverlay({
    super.key,
    required this.child,
    this.showOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingBloc, LoadingState>(
      builder: (context, state) {
        return Stack(
          children: [
            child,
            if (state is LoadingInProgress && showOverlay)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const DelayedLoadingIndicator(
                  color: Colors.purple,
                  delay:
                      Duration(milliseconds: 0), // Показываем сразу для overlay
                ),
              ),
          ],
        );
      },
    );
  }
}
