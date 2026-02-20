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
        return SizedBox.shrink();
      },
    );
  }
}
