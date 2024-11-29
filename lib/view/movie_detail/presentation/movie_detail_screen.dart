import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cinemader/core/route/app_route_name.dart';
import 'package:cinemader/feature/home/model/movie_model.dart';
import 'package:cinemader/feature/movie_detail/presentation/widget/movie_info_widget.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)?.settings.arguments as Movie;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Movie Detail",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(movie.assetImage),
                            // image: AssetImage(movie.assetImage,),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MovieInfoWidget(
                          iconData: Icons.videocam_rounded,
                          title: "Genre",
                          value: movie.type,
                        ),
                        MovieInfoWidget(
                          iconData: Icons.access_time_filled_rounded,
                          title: "Duration",
                          value: '${movie.duration}',
                        ),
                        MovieInfoWidget(
                          iconData: Icons.stars_rounded,
                          title: "Rating",
                          value: '${movie.rating}',
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              const Divider(height: 32),
              Text(
                "Synopsis",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                movie.synopsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouteName.movieAdding,
              arguments: movie,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Text(
              "Booking Now",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      )
    ;
  }
}
