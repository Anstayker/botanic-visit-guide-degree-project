import 'package:equatable/equatable.dart';

class UserPosition extends Equatable {
  final double latitude;
  final double longitude;
  final double heading;

  const UserPosition({
    required this.latitude,
    required this.longitude,
    required this.heading,
  });

  @override
  List<Object?> get props => [latitude, longitude, heading];
}
