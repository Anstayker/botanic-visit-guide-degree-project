import 'package:equatable/equatable.dart';

class EncyPlant extends Equatable {
  // Internal Info
  final String id;
  final int categoryId;
  // Public Info
  final String name;
  final String shortDescription;
  final String image;
  // Gamnification Info
  final bool isDiscovered;

  const EncyPlant({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.shortDescription,
    required this.image,
    required this.isDiscovered,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    shortDescription,
    image,
    isDiscovered,
  ];
}
