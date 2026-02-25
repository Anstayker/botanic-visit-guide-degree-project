import 'package:equatable/equatable.dart';

class PlantLocation extends Equatable {
  final double latitude;
  final double longitude;

  const PlantLocation({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
