import 'package:go_router/go_router.dart';
import 'package:matule/layers/presentation/screens/language_screen.dart';
import 'package:matule/layers/presentation/screens/notebook.dart';
import 'package:matule/layers/presentation/screens/settings_screen.dart';

class RouterConfigGO {
  final GoRouter router = GoRouter(
    initialLocation: '/first',
    routes: [
      GoRoute(path: '/first', builder: (context, state) => Notebookf()),
      GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
      GoRoute(path: '/language', builder: (context, state) => LanguageScreen()),
    ]
  );
}