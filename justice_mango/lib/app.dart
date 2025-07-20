import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'app/route/app_route.dart';
import 'app/theme/app_theme.dart';
import 'di/injection.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoute = getIt<AppRoute>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerDelegate: appRoute.delegate(
        navigatorObservers: () => [RouteObserver()],
      ),
      routeInformationParser: appRoute.defaultRouteParser(),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }

// runApp(
//   MaterialApp(
//     initialRoute: Routes.home,
//     getPages: AppPages.pages,
//     locale: SourceService.selectedLocale,
//     translationsKeys: translationMap,
//     debugShowCheckedModeBanner: false,
//     theme: appThemeData,
//     builder: (context, child) {
//       final mediaQueryData = MediaQuery.of(context);
//       return MediaQuery(
//         data: mediaQueryData.copyWith(textScaleFactor: 1.0),
//         child: child!,
//       );
//     },
//   ),
// );
}
