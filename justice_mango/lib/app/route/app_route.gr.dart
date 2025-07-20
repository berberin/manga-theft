// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_route.dart';

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [MangaDetailScreen]
class MangaDetailRoute extends PageRouteInfo<MangaDetailRouteArgs> {
  MangaDetailRoute({
    Key? key,
    required MangaMetaCombine metaCombine,
    List<PageRouteInfo>? children,
  }) : super(
          MangaDetailRoute.name,
          args: MangaDetailRouteArgs(
            key: key,
            metaCombine: metaCombine,
          ),
          initialChildren: children,
        );

  static const String name = 'MangaDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MangaDetailRouteArgs>();
      return MangaDetailScreen(
        key: args.key,
        metaCombine: args.metaCombine,
      );
    },
  );
}

class MangaDetailRouteArgs {
  const MangaDetailRouteArgs({
    this.key,
    required this.metaCombine,
  });

  final Key? key;

  final MangaMetaCombine metaCombine;

  @override
  String toString() {
    return 'MangaDetailRouteArgs{key: $key, metaCombine: $metaCombine}';
  }
}

/// generated route for
/// [ReaderScreen]
class ReaderRoute extends PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    Key? key,
    required ReaderScreenArgs readerScreenArgs,
    List<PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            readerScreenArgs: readerScreenArgs,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderRouteArgs>();
      return ReaderScreen(
        key: args.key,
        readerScreenArgs: args.readerScreenArgs,
      );
    },
  );
}

class ReaderRouteArgs {
  const ReaderRouteArgs({
    this.key,
    required this.readerScreenArgs,
  });

  final Key? key;

  final ReaderScreenArgs readerScreenArgs;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, readerScreenArgs: $readerScreenArgs}';
  }
}
