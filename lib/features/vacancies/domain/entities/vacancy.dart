import 'package:equatable/equatable.dart';

class Vacancy extends Equatable {
  final String id;
  final String title;
  final String description;
  final String company;
  final String location;
  final String salary;
  final String experience;
  final List<String> requirements;
  final List<String> benefits;
  final String categoryId;
  final DateTime createdAt;
  final bool isActive;
  final String iconPath;

  const Vacancy({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.salary,
    required this.experience,
    required this.requirements,
    required this.benefits,
    required this.categoryId,
    required this.createdAt,
    this.isActive = true,
    required this.iconPath,
  });

  Vacancy copyWith({
    String? id,
    String? title,
    String? description,
    String? company,
    String? location,
    String? salary,
    String? experience,
    List<String>? requirements,
    List<String>? benefits,
    String? categoryId,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Vacancy( 
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      company: company ?? this.company,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      experience: experience ?? this.experience,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        company,
        location,
        salary,
        experience,
        requirements,
        benefits,
        categoryId,
        createdAt,
        isActive,
        iconPath,
      ];
}
