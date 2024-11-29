import 'package:flutter/material.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cinemader/feature/home/model/movie_model.dart';
import 'package:cinemader/feature/home/presentation/profile_screen.dart';

class UpcomingMovieWidget extends StatelessWidget {
  const UpcomingMovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return         FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
      .collection('movies')
      .where('on_showing', isEqualTo: true)
            .where('release_date',
                isGreaterThan: Timestamp.fromDate(DateTime.now()))
      .get(),
      builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Handle errors
            }

            QuerySnapshot querySnapshot = snapshot.data!;
            List<DocumentSnapshot> documents = querySnapshot.docs;
            List movies = [];
            // Process the documents where 'onShowing' is true
            for (var doc in documents) {
              Map<String, dynamic> movie = doc.data()! as Map<String, dynamic>;
              movies.add(Movie(
                id: doc.id,
                title: movie['title'],
                assetImage: movie['imageUrl'],
                type: movie["genre"],
                duration: movie['duration'],
                rating: movie['rating'],
                synopsis: movie["synopsis"],
                isPlaying: movie['on_showing'], 
                shortTitle: movie['short_title'], 
                releaseDate: movie['release_date'],
              ));
            }
            // print(movies[1]);
            // print(movies[1]['rating']);

        return
        SizedBox(
      height: 360,
      child: CarouselSlider.builder(
        itemCount: movies.length,
        options: CarouselOptions(
          height: 360,
          pageSnapping: false,
          viewportFraction: 0.6,
        ),
        itemBuilder: (context, index, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(
                        movies[index].assetImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColor.black,
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      '${formatDateTimestamp(movies[index].releaseDate)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: AppColor.backgroundGray),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                ),
              ),
              const SizedBox(height: 16),
              Text(
                movies[index].title,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
              ),
            ],
          );
        },
      ),
    );
          }
          return Center(
              child:
                  SpinKitCubeGrid(color: AppColor.backgroundGray, size: 50.0));
        }));
  }
}
