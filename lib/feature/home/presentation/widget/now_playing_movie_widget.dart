import 'package:flutter/material.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:cinemader/core/route/app_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cinemader/core/route/app_route_name.dart';
import 'package:cinemader/feature/home/model/movie_model.dart';
import 'package:cinemader/view/movie_booking/presentation/movie_booking_screen.dart';

class NowPlayingMovieWidget extends StatefulWidget {
  final int role;
  const NowPlayingMovieWidget({super.key, required this.role});

  @override
  State<NowPlayingMovieWidget> createState() => _NowPlayingMovieWidgetState();
}

class _NowPlayingMovieWidgetState extends State<NowPlayingMovieWidget> {
  int centerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('movies')
            .where('on_showing', isEqualTo: true)
            .where('release_date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print('${snapshot.error}');
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
            print(movies);
            // print(movies[1]['rating']);

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: CarouselSlider.builder(
                itemCount: movies.length,
                options: CarouselOptions(
                  height: 400,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  initialPage: centerIndex,
                  viewportFraction: 0.7,
                  onPageChanged: (index, reason) {
                    // setState(() {
                    //   centerIndex = index;
                    // });
                  },
                ),
                itemBuilder: (context, index, _) {
                  if (widget.role == 0) {
                    return _NowPlayingItem(
                      movie: movies[index],
                      isCenter: index == centerIndex,
                    );
                  } else if (widget.role == 1) {
                    print('2');
                    return _NowPlayingUsherItem(
                      movie: movies[index],
                      isCenter: index == centerIndex,
                    );
                  } else {
                    print('2');
                    return _NowPlayingManagerItem(
                      movie: movies[index],
                      isCenter: index == centerIndex,
                    );
                  }
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

class _NowPlayingItem extends StatefulWidget {
  const _NowPlayingItem({
    required this.movie,
    this.isCenter = false,
  });

  final Movie movie;
  final bool isCenter;

  @override
  State<_NowPlayingItem> createState() => __NowPlayingItemState();
}

class __NowPlayingItemState extends State<_NowPlayingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouteName.movieDetail,
          arguments: widget.movie,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.movie.assetImage),
                  // image: AssetImage(
                  //   widget.movie.assetImage,
                  // ),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: widget.isCenter
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Buy Ticket",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColor.primaryColor),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.movie.title,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}



class _NowPlayingUsherItem extends StatefulWidget {
  const _NowPlayingUsherItem({
    required this.movie,
    this.isCenter = false,
  });

  final Movie movie;
  final bool isCenter;

  @override
  State<_NowPlayingUsherItem> createState() => __NowPlayingUsherItemState();
}

class __NowPlayingUsherItemState extends State<_NowPlayingUsherItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouteName.movieDetailUsher,
          arguments: widget.movie,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.movie.assetImage),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: widget.isCenter
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Checking Round",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColor.primaryColor),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.movie.title,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}


class _NowPlayingManagerItem extends StatefulWidget {
  const _NowPlayingManagerItem({
    required this.movie,
    this.isCenter = false,
  });

  final Movie movie;
  final bool isCenter;

  @override
  State<_NowPlayingManagerItem> createState() => __NowPlayingManagerItemState();
}

class __NowPlayingManagerItemState extends State<_NowPlayingManagerItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MovieBookingManagerScreen(movie: widget.movie,),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                        begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.movie.assetImage),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: widget.isCenter
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Adding Round",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColor.primaryColor),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.movie.title,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
