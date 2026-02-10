import 'package:equatable/equatable.dart' show Equatable;

class Plant extends Equatable {
  final String id;
  final String name;
  final String scientificName;
  final String ilumination;
  final String watering;
  final String height;
  final String growthTime;
  final String minTemperature;
  final String maxTemperature;
  final String image;
  final String description;
  //! TMP fields
  final int categoryId;
  final String shortDescription;
  final bool isDiscovered;

  const Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.ilumination,
    required this.watering,
    required this.height,
    required this.growthTime,
    required this.minTemperature,
    required this.maxTemperature,
    required this.image,
    required this.description,
    required this.categoryId,
    required this.shortDescription,
    required this.isDiscovered,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    scientificName,
    ilumination,
    watering,
    height,
    growthTime,
    minTemperature,
    maxTemperature,
    image,
    description,
    categoryId,
    shortDescription,
    isDiscovered,
  ];
}
