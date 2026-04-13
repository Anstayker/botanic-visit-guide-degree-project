import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_progress_bloc.dart';

class EncyUserProgressCard extends StatelessWidget {
  const EncyUserProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (_, state) {
        final isLoading = state is UserProgressLoading;
        final hasError = state is UserProgressError;
        final loadedState = state is UserProgressLoaded ? state : null;

        final identifiedPlants = loadedState?.identifiedPlants ?? 0;
        final totalPlants = loadedState?.totalPlants ?? 0;
        final progressValue = loadedState?.progressValue ?? 0;
        final progressPercentage = loadedState?.progressPercentage ?? 0;
        final levelNumber = loadedState?.levelNumber ?? 1;
        final levelTitle = loadedState?.levelTitle ?? 'Explorador Inicial';

        return SizedBox(
          height: 300,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: SizedBox(
                  height: 220,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1.25,
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/wallpaper1.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 185,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardTitle(),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _userLevel(levelNumber, levelTitle),
                              _plantsObtainedQuantity(
                                identifiedPlants,
                                totalPlants,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          _progressBar(context, progressValue),
                          const SizedBox(height: 8.0),
                          if (isLoading)
                            _helperText('Calculando progreso...')
                          else if (hasError)
                            _helperText('No se pudo cargar el progreso')
                          else
                            _completionPercentage(progressPercentage),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Text _plantsObtainedQuantity(int identifiedPlants, int totalPlants) => Text(
    '$identifiedPlants/$totalPlants',
    style: const TextStyle(fontWeight: FontWeight.bold),
  );

  LinearProgressIndicator _progressBar(BuildContext context, double value) {
    return LinearProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      color: Theme.of(context).primaryColor,
    );
  }

  Text _completionPercentage(int progressPercentage) {
    return Text(
      '$progressPercentage% completado',
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Text _userLevel(int levelNumber, String levelTitle) {
    return Text(
      'Nivel $levelNumber: $levelTitle',
      style: TextStyle(color: Colors.grey[600], fontSize: 12),
    );
  }

  Text _helperText(String message) {
    return Text(
      message,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Text _cardTitle() {
    return const Text(
      'Progreso de Descubrimiento',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
