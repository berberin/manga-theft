import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeStateNotifier extends StateNotifier<int> {
  HomeStateNotifier() : super(0);

  switchToIndex(int index) {
    state = index;
  }
}

final homeProvider =
    StateNotifierProvider<HomeStateNotifier, int>((ref) => HomeStateNotifier());
