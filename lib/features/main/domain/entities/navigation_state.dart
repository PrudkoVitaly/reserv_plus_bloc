import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int selectedIndex;
  final bool isContainerVisible;
  final bool hasNotifications;

  const NavigationState({
    this.selectedIndex = -1,
    this.isContainerVisible = false,
    this.hasNotifications = false,
  });

  NavigationState copyWith({
    int? selectedIndex,
    bool? isContainerVisible,
    bool? hasNotifications,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isContainerVisible: isContainerVisible ?? this.isContainerVisible,
      hasNotifications: hasNotifications ?? this.hasNotifications,
    );
  }

  @override
  List<Object?> get props =>
      [selectedIndex, isContainerVisible, hasNotifications];
}
