import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/item_model.dart';
import 'package:movie_app/ui/widgets/colors.dart';

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
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent',
                style: TextStyle(fontFamily: 'PaytoneOne', fontSize: 22),
              ),
              Text(
                'SEE ALL',
                style: TextStyle(color: kTextColor, fontSize: 18),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is SuccessFetchMovies) {
              return Container(
                  height: 230,
                  child: ListView.builder(
                      primary: false,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.itemModel.results.length,
                      itemBuilder: (context, i) {
                        final m = state.itemModel.results[i];
                        return Container(
                          width: size.width * 0.30,
                          margin: EdgeInsets.only(left: i == 0 ? 20.0 : 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    m.posterPath,
                                    fit: BoxFit.cover,
                                    height: 180,
                                  )),
                              SizedBox(height: 6),
                              Text(m.title),
                            ],
                          ),
                        );
                      }));
            } else if (state is FailFetchMovies) {
              return Center(child: Text('Failed while loading movies'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
