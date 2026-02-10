import '../../../core/entities/plant.dart';

class PlantModel extends Plant {
  const PlantModel({
    required super.id,
    required super.name,
    required super.scientificName,
    required super.ilumination,
    required super.watering,
    required super.height,
    required super.growthTime,
    required super.minTemperature,
    required super.maxTemperature,
    required super.image,
    required super.description,
    //! TMP fields
    required super.categoryId,
    required super.shortDescription,
    required super.isDiscovered,
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
      categoryId: json['category_id'],
      shortDescription: json['short_description'],
      isDiscovered: json['is_discovered'] ?? false,
    );
  }
}
