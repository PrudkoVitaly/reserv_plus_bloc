import 'package:flutter/material.dart';
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
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(253, 135, 12, 1),
                    strokeWidth: 4,
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeAlign: 1,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
