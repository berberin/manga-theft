import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void switchToIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
