import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/ui/widgets/colors.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchAllMovies());
    return Scaffold(backgroundColor: kBgColor, body: _HomeScreenBody());
  }
}

class _HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        primary: false,
        children: [
          _SearchRow(),
          _RecentMoviesRow(),
          _PopularMoviesRow(),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: TextStyle(fontFamily: 'PaytoneOne', fontSize: 30),
          ),
          SizedBox(height: 6),
          TextField(
            style: TextStyle(color: kTextColor, fontSize: 28),
            decoration: InputDecoration.collapsed(
                hintText: 'Movie, Actors, Directors...',
                hintStyle: TextStyle(color: kTextColor, fontSize: 28),
                border: UnderlineInputBorder()),
          ),
        ],
      ),
    );
  }
}

class _RecentMoviesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCardW(
      title: 'Recent',
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is SuccessFetchMovies) {
            return state.recent != null
                ? Container(
                    height: 230,
                    child: ListView.builder(
                        primary: false,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recent.results.length,
                        itemBuilder: (context, i) {
                          final m = state.recent.results[i];
                          return MovieCard(m: m);
                        }))
                : Center(child: CircularProgressIndicator());
          } else if (state is FailFetchMovies) {
            return Center(child: Text('Failed while loading movies'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _PopularMoviesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCardW(
      title: 'Popular',
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is SuccessFetchMovies) {
            return state.popular != null
                ? Container(
                    height: 230,
                    child: ListView.builder(
                        primary: false,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.popular.results.length,
                        itemBuilder: (context, i) {
                          final m = state.popular.results[i];
                          return MovieCard(m: m);
                        }))
                : Center(child: CircularProgressIndicator());
          } else if (state is FailFetchMovies) {
            return Center(child: Text('Failed while loading movies'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
