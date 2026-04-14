import 'package:equatable/equatable.dart' show Equatable;

import 'plant_category.dart';
import 'plant_location.dart';

class Plant extends Equatable {
  final String id;
  // * Plant characteristics
  final String name;
  final String scientificName;
  final String image;
  final String description;
  final String? funFact;

  //* Plant stats
  final String illumination;
  final String watering;
  final String minTemperature;
  final String maxTemperature;
  final String height;
  final String growthTime;

  // * Location
  final PlantLocation location;

  // * Gamification
  final PlantCategory categoryId;
  final bool isDiscovered;

  const Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.illumination,
    required this.watering,
    required this.height,
    required this.growthTime,
    required this.minTemperature,
    required this.location,
    required this.maxTemperature,
    required this.image,
    required this.description,
    required this.categoryId,
    required this.isDiscovered,
    this.funFact,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    scientificName,
    illumination,
    watering,
    height,
    growthTime,
    minTemperature,
    maxTemperature,
    image,
    description,
    categoryId,
    funFact,
    isDiscovered,
  ];
}
