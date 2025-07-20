import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../di/injection.dart';
import '../route/app_route.dart';

abstract class BaseStatefulWidget<T extends Cubit<S>, S> extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseStatefulWidgetState<T extends Cubit<S>, S, W extends BaseStatefulWidget<T, S>> extends State<W> {
  late final T cubit = GetIt.I<T>();
  AppRoute navigator = getIt<AppRoute>();

  @override
  void initState() {
    super.initState();
    onCubitReady(cubit);
  }

  /// Override để xử lý khi Cubit được khởi tạo
  void onCubitReady(T cubit) {}

  /// Override để build UI với Cubit và State
  Widget buildContent(BuildContext context, T cubit, S state);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: cubit,
      child: BlocBuilder<T, S>(
        builder: (context, state) => buildContent(context, cubit, state),
      ),
    );
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }
}
