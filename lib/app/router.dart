import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth/auth.dart';
import 'auth/login.dart';
import 'home/dash.dart';
import 'pages/overview.dart';

/// Caches and Exposes a [GoRouter]
final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    urlPathStrategy:
        UrlPathStrategy.path, // UrlPathStrategy.path or UrlPathStrategy.hash
    debugLogDiagnostics: true, // For demo purposes
    refreshListenable: router, // This notifiies `GoRouter` for refresh events
    redirect: router._redirectLogic, // All the logic is centralized here
    routes: router._routes, // All the routes can be found there
  );
});

/// My favorite approach: ofc there's room for improvement, but it works fine.
/// What I like about this is that `RouterNotifier` centralizes all the logic.
/// The reason we use `ChangeNotifier` is because it's a `Listenable` object,
/// as required by `GoRouter`'s `refreshListenable` parameter.
/// Unluckily, it is not possible to use a `StateNotifier` here, since it's
/// not a `Listenable`. Recall that `StateNotifier` is to be preferred over
/// `ChangeNotifier`, see https://riverpod.dev/docs/concepts/providers/#different-types-of-providers
/// There are other approaches to solve this, and they can
/// be found in the `/others` folder.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  /// This implementation exploits `ref.listen()` to add a simple callback that
  /// calls `notifyListeners()` whenever there's change onto a desider provider.
  RouterNotifier(this._ref) {
    _ref.listen<User?>(
      userProvider, // In our case, we're interested in the log in / log out events.
      (_, __) => notifyListeners(), // Obviously more logic can be added here
    );
  }

  /// IMPORTANT: conceptually, we want to use `ref.read` to read providers, here.
  /// GoRouter is already aware of state changes through `refreshListenable`
  /// We don't want to trigger a rebuild of the surrounding provider.
  String? _redirectLogic(GoRouterState state) {
    final user = _ref.read(userProvider);

    _ref.read(userProvider.notifier).isAuthenticated();
    // From here we can use the state and implement our custom logic
    final areWeLoggingIn = state.location == '/login';

    if (user == null) {
      // We're not logged in
      // So, IF we aren't in the login page, go there.
      return areWeLoggingIn ? null : '/login';
    }
    // We're logged in

    // At this point, IF we're in the login page, go to the home page
    if (areWeLoggingIn) return '/';

    // There's no need for a redirect at this point.
    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          redirect: (_) => '/dash/${dashBoardTabs[0]}',
        ),
        GoRoute(
          name: "DashRoute",
          path: '/dash/:id',
          builder: (context, state) => DashView(
            key: state.pageKey,
            selectedTab: state.params['id']!,
          ),
        ),
        GoRoute(
          name: "LoginRoute",
          path: '/login',
          builder: (context, _) => const LoginPage(),
        ),
        GoRoute(
          name: "OverViewRoute",
          path: '/over-view',
          builder: (context, state) =>  OverView(
            imageUrl: state.queryParams["imageUrl"]!,
            subtitle: state.queryParams["subtitle"]!,
            title: state.queryParams["title"]!,
          ),
        ),
      ];
}
