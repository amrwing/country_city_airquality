import 'package:contamination_cities/screens/home_screen.dart';
import 'package:contamination_cities/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MySplashScreen();
      },
      //ABAJO DE ESTE COMENTARIO AÑADIR LAS RUTAS
      routes: <RouteBase>[
        GoRoute(
          path: 'home_screen',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
      ],
    ),
  ],
);
