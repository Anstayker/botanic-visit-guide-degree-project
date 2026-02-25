// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantModelAdapter extends TypeAdapter<PlantModel> {
  @override
  final int typeId = 0;

  @override
  PlantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantModel(
      id: fields[0] as String,
      name: fields[1] as String,
      scientificName: fields[2] as String,
      ilumination: fields[3] as String,
      watering: fields[4] as String,
      height: fields[5] as String,
      growthTime: fields[6] as String,
      minTemperature: fields[7] as String,
      maxTemperature: fields[8] as String,
      image: fields[9] as String,
      description: fields[10] as String,
      categoryId: fields[11] as int,
      shortDescription: fields[12] as String,
      plantLocation: fields[14] as PlantLocation,
      isDiscovered: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlantModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.ilumination)
      ..writeByte(4)
      ..write(obj.watering)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.growthTime)
      ..writeByte(7)
      ..write(obj.minTemperature)
      ..writeByte(8)
      ..write(obj.maxTemperature)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.categoryId)
      ..writeByte(12)
      ..write(obj.shortDescription)
      ..writeByte(13)
      ..write(obj.isDiscovered)
      ..writeByte(14)
      ..write(obj.plantLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
