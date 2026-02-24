import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant.dart';
import '../../domain/usecases/get_plant_details_data.dart';

part 'plant_details_state.dart';

class PlantDetailsCubit extends Cubit<PlantDetailsState> {
  final GetPlantDetailsData getPlantDetailsData;

  PlantDetailsCubit({required this.getPlantDetailsData})
    : super(PlantDetailsInitial());

  Future<void> fetchPlantDetailsData(String plantId) async {
    emit(PlantDetailsLoading());

    final result = await getPlantDetailsData(Params(id: plantId));
    result.fold(
      (failure) => emit(PlantDetailsError(message: failure.message)),
      (plantDetails) => emit(PlantDetailsLoaded(plantDetails: plantDetails)),
    );
  }
}
