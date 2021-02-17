import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/genre_model.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:movie_app/ui/widgets/colors.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class MovieDetail extends StatelessWidget {
  static route(BuildContext context, int id) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => MovieBloc(context.read<Repository>()),
                child: MovieDetail(id))));
  }

  MovieDetail(this.movieId);

  final int movieId;

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchMovie(this.movieId));
    return Scaffold(
      backgroundColor: kBgColor,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is SuccessFetchMovie) {
            return _scaffoldBody(context, state.movie, state.trailersModel);
          } else if (state is FailFetchMovie) {
            return Center(child: Text('Error while load details'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _scaffoldBody(
      BuildContext context, Movie movie, TrailersModel trailersModel) {
    final size = MediaQuery.of(context).size;
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          height: 300,
          width: size.width,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: NetworkImage(
                      movie.posterPath.replaceAll('w185', 'w400')))),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: 70,
                  width: size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        kBgColor.withOpacity(0.0),
                        kBgColor.withOpacity(0.90),
                        kBgColor,
                      ])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size.width - 40,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: AppText(
                        movie.title,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GenresRow(movie.genres),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(indent: 20.0, endIndent: 20.0),
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    movie.popularity.toStringAsFixed(2),
                    color: Colors.pink[400],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText('Popularity', fontSize: 18),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.pink, size: 18),
                  Row(
                    children: [
                      AppText(movie.voteAverage.toString(),
                          fontSize: 20, fontWeight: FontWeight.bold),
                      AppText('/10', fontSize: 18),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    movie.voteCount.toString(),
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                    'Vote count',
                    fontSize: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(indent: 20.0, endIndent: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Description',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              AppText(
                movie.overview,
                fontSize: 18,
              )
            ],
          ),
        ),
        TrailersCol(trailersModel),
      ],
    );
  }
}

class GenresRow extends StatelessWidget {
  GenresRow(this.genres);

  final List<Genre> genres;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 8.0,
        children: genres
            .map((e) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(e.name),
                ))
            .toList(),
      ),
    );
  }
}

class TrailersCol extends StatelessWidget {
  TrailersCol(this.trailersModel);

  final TrailersModel trailersModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Trailers',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          trailersModel != null
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: trailersModel.results.length,
                  itemBuilder: (context, i) => ListTile(
                        title: Text(trailersModel.results[i].name),
                      ))
              : Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
