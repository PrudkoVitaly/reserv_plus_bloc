import 'package:equatable/equatable.dart';

class VacancyCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final bool isActive;

  const VacancyCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    this.isActive = false,
  });

  VacancyCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    bool? isActive,
  }) {
    return VacancyCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, description, iconPath, isActive];
}
