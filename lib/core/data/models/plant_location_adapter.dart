import 'package:hive/hive.dart';

import '../../entities/plant_location.dart';

class PlantLocationAdapter extends TypeAdapter<PlantLocation> {
  @override
  final int typeId = 1;

  @override
  PlantLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return PlantLocation(
      latitude: (fields[0] as num).toDouble(),
      longitude: (fields[1] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, PlantLocation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }
}
