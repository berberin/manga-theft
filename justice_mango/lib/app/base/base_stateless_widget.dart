import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract class BaseStatelessWidget<T extends Cubit<S>, S> extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  /// Override để build UI
  Widget buildContent(BuildContext context, T cubit, S state);

  /// Override nếu muốn gọi hàm Cubit ngay lập tức
  /// (bạn cần dùng `WidgetsBinding.instance.addPostFrameCallback`)
  void onCubitReady(T cubit) {}

  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.I<T>();

    // Gọi callback sau frame đầu tiên nếu cần
    WidgetsBinding.instance.addPostFrameCallback((_) => onCubitReady(cubit));
    return BlocProvider<T>.value(
      value: cubit,
      child: BlocBuilder<T, S>(
        builder: (context, state) => buildContent(context, cubit, state),
      ),
    );
  }
}
