import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/repository_list_screen.dart';
import '../screens/review_progress_screen.dart';
import '../screens/findings_list_screen.dart';

/// Application router configuration using GoRouter
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/repositories',
      builder: (context, state) => const RepositoryListScreen(),
    ),
    GoRoute(
      path: '/review/:sessionId',
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['sessionId']!);
        return ReviewProgressScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: '/findings/:prId',
      builder: (context, state) {
        final prId = int.parse(state.pathParameters['prId']!);
        return FindingsListScreen(prId: prId);
      },
    ),
  ],
);

