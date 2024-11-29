import 'package:cinemader/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinemader/core/route/app_route.dart';
import 'package:cinemader/core/theme/app_theme.dart';
import 'package:cinemader/readdata/getusername.dart';
import 'package:cinemader/core/route/app_route_name.dart';
import 'package:cinemader/feature/home/presentation/profile_screen.dart';
import 'package:cinemader/feature/home/presentation/widget/banner_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/category_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/section_title_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/upcoming_movie_widget.dart';
import 'package:cinemader/feature/home/presentation/widget/now_playing_movie_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                  Text(
                    "Hi, ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  getFullName(
                    documentId: userid,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    // textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),],
                  ),
                  MaterialButton(
                      onPressed: () => 
                      Navigator.pushReplacement(context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ProfileScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset(1.0, 0.0),
                                          end: Offset(0.0, 0.0))
                                      .animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          ),
                      child: GetUserImage(
                          documentId: userid, cirRadius: 20, sideLenght: 50)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Book your favorite Movie here!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: BannerWidget(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitleWidget(title: "Category"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CategoryWidget(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitleWidget(title: "Now Playing"),
            ),
            const SizedBox(height: 16),
            const NowPlayingMovieWidget(role: 0,), 
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitleWidget(title: "Upcoming"),
            ),
            const SizedBox(height: 16),
            const UpcomingMovieWidget(),
          ],
        ),
      ),
    );
  }
}
