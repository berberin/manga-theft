import 'package:flutter/widgets.dart';

class RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _log('PUSHED', route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _log('POPPED', route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _log('REMOVED', route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _log('REPLACED', newRoute, oldRoute);
  }

  void _log(String action, Route? route, Route? previousRoute) {
    final current = route?.settings.name ?? route.toString();
    final previous = previousRoute?.settings.name ?? previousRoute.toString();
    debugPrint('[ROUTE][$action] current: $current | previous: $previous');
  }
}
