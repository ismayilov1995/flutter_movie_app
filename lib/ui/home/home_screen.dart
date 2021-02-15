import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchAllMovies());
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
        if (state is SuccessFetchMovies) {
          return ListView.builder(
              itemCount: state.itemModel.results.length,
              itemBuilder: (context, i) {
                final movie = state.itemModel.results[i];
                return Card(
                  child: ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(movie.backdropPath),
                      ),
                      title: Text(movie.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${movie.releaseDate.year} - ${movie.releaseDate.month}'),
                          RichText(
                              text: TextSpan(
                                  text:
                                      movie.overview.substring(0, 70) + '... ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                TextSpan(
                                    text: 'Read more',
                                    style: TextStyle(color: Colors.blue))
                              ])),
                        ],
                      )),
                );
              });
        } else if (state is FailFetchMovies) {
          return Center(child: Text('Movies not load'));
        }
        return Center(child: Text('Home Screen'));
      }),
    );
  }
}
