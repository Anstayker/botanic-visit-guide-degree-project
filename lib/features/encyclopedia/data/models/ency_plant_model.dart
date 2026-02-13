import '../../../../core/data/models/plant_model.dart';
import '../../domain/entities/ency_plant.dart';

class EncyPlantModel extends EncyPlant {
  const EncyPlantModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.shortDescription,
    required super.image,
    required super.isDiscovered,
  });

  factory EncyPlantModel.fromPlantModel(PlantModel plant) {
    return EncyPlantModel(
      id: plant.id,
      categoryId: plant.categoryId,
      name: plant.name,
      shortDescription: plant.shortDescription,
      image: plant.image,
      isDiscovered: plant.isDiscovered,
    );
  }
}
