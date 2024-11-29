import 'app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:cinemader/feature/home/model/movie_model.dart';
import 'package:cinemader/feature/usher/home_usher_screen.dart';
import 'package:cinemader/feature/usher/home_usher_screen.dart';
import 'package:cinemader/feature/home/presentation/home_screen.dart';
import 'package:cinemader/feature/usher/presentation/movie_detail_screen.dart';
import 'package:cinemader/view/movie_booking/presentation/movie_booking_screen.dart';
import 'package:cinemader/feature/movie_detail/presentation/movie_detail_screen.dart';
import 'package:cinemader/feature/movie_booking/presentation/movie_booking_screen.dart';
import 'package:cinemader/feature/usher/movie_booking/presentation/movie_booking_screen.dart';




class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case AppRouteName.homeUsher:
        return MaterialPageRoute( 
          builder: (_) => const HomeUsherScreen(),
          settings: settings,
        );

      case AppRouteName.movieDetail:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const MovieDetailScreen(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      case AppRouteName.movieDetailUsher:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const MovieDetailScreenUsher(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      case AppRouteName.movieAdding:
        final movie = settings.arguments as Movie;
        print(movie.id);
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => MovieBookingScreen(movie: movie),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );

      case AppRouteName.movieBooking:
        final movie = settings.arguments as Movie;
        print(movie.id);
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) =>  MovieBookingScreen(movie: movie),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );

      case AppRouteName.movieBookingUsher:
        final movie = settings.arguments as Movie;
        print(movie.id);
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => MovieBookingUsherScreen(movie: movie),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
    }
    return null;
  }
}
