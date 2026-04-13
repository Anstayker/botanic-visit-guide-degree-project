import 'package:hive/hive.dart';

import '../../entities/plant.dart';
import '../../entities/plant_category.dart';
import '../../entities/plant_location.dart';

part 'plant_model.g.dart';

@HiveType(typeId: 0)
class PlantModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String scientificName;

  @HiveField(3)
  final String ilumination;

  @HiveField(4)
  final String watering;

  @HiveField(5)
  final String height;

  @HiveField(6)
  final String growthTime;

  @HiveField(7)
  final String minTemperature;

  @HiveField(8)
  final String maxTemperature;

  @HiveField(9)
  final String image;

  @HiveField(10)
  final String description;

  @HiveField(11)
  final int categoryId;

  @HiveField(12)
  final String shortDescription;

  @HiveField(13)
  final bool isDiscovered;

  @HiveField(14)
  final PlantLocation plantLocation;

  const PlantModel({
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
    required this.plantLocation,
    required this.isDiscovered,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientific_name'],
      ilumination: json['ilumination'],
      watering: json['watering'],
      height: json['height'],
      growthTime: json['growth_time'],
      minTemperature: json['min_temperature'],
      maxTemperature: json['max_temperature'],
      image: json['image'],
      description: json['description'],
      plantLocation: PlantLocation(
        latitude: json['latitude'] ?? 0.0,
        longitude: json['longitude'] ?? 0.0,
      ),
      categoryId: PlantCategory.fromId(json['category_id']).id,
      shortDescription: json['short_description'],
      isDiscovered: json['is_discovered'] ?? false,
    );
  }

  Plant toEntity() {
    return Plant(
      id: id,
      name: name,
      scientificName: scientificName,
      illumination: ilumination,
      watering: watering,
      height: height,
      location: PlantLocation(
        latitude: plantLocation.latitude,
        longitude: plantLocation.longitude,
      ),
      growthTime: growthTime,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      image: image,
      description: description,
      categoryId: PlantCategory.fromId(categoryId),
      shortDescription: shortDescription,
      isDiscovered: isDiscovered,
    );
  }

  factory PlantModel.fromEntity(Plant plant) {
    return PlantModel(
      id: plant.id,
      name: plant.name,
      scientificName: plant.scientificName,
      ilumination: plant.illumination,
      watering: plant.watering,
      height: plant.height,
      growthTime: plant.growthTime,
      minTemperature: plant.minTemperature,
      maxTemperature: plant.maxTemperature,
      image: plant.image,
      description: plant.description,
      categoryId: plant.categoryId.id,
      shortDescription: plant.shortDescription,
      plantLocation: plant.location,
      isDiscovered: plant.isDiscovered,
    );
  }

  PlantModel copyWith({
    String? id,
    String? name,
    String? scientificName,
    String? ilumination,
    String? watering,
    String? height,
    String? growthTime,
    String? minTemperature,
    String? maxTemperature,
    String? image,
    String? description,
    int? categoryId,
    String? shortDescription,
    bool? isDiscovered,
    PlantLocation? plantLocation,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      ilumination: ilumination ?? this.ilumination,
      watering: watering ?? this.watering,
      height: height ?? this.height,
      growthTime: growthTime ?? this.growthTime,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      image: image ?? this.image,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      shortDescription: shortDescription ?? this.shortDescription,
      plantLocation: plantLocation ?? this.plantLocation,
      isDiscovered: isDiscovered ?? this.isDiscovered,
    );
  }
}
