import 'package:bmi_calculator/main/main_screen.dart';
import 'package:go_router/go_router.dart';

import '../result/result_screen.dart';

final GoRouter $Router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final uri = Uri.parse(state.uri.toString());
        final queryParams = uri.queryParameters;

        final double height = double.tryParse(queryParams['height'] ?? '') ??  0.0;
        final double weight = double.tryParse(queryParams['weight'] ?? '') ??  0.0;

        return ResultScreen(height: height, weight: weight);
      },
    ),
  ],
);
