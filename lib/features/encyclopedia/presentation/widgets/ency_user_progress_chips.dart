import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_progress_bloc.dart';

class EncyUserProgressCard extends StatelessWidget {
  const EncyUserProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (_, state) {
        if (state is UserProgressLoaded) {
          debugPrint('User progress loaded');
        }
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
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
                children: [_userLevel(), _plantsObtainedQuantity()],
              ),
              const SizedBox(height: 8.0),
              _progressBar(context),
              const SizedBox(height: 8.0),
              _completionPercentage(),
            ],
          ),
        );
      },
    );
  }

  Text _plantsObtainedQuantity() =>
      Text('12/30', style: TextStyle(fontWeight: FontWeight.bold));

  LinearProgressIndicator _progressBar(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.4,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      color: Theme.of(context).primaryColor,
    );
  }

  Text _completionPercentage() {
    return Text(
      '40% completado',
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Text _userLevel() {
    return Text(
      'Nivel 3: Descubridor Novato',
      style: TextStyle(color: Colors.grey[600], fontSize: 12),
    );
  }

  Text _cardTitle() {
    return const Text(
      'Progreso de Descubrimiento',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
