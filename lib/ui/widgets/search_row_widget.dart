import 'package:flutter/material.dart';
import 'package:movie_app/blocs/search/search_cubit.dart';
import 'package:movie_app/ui/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchRow extends StatelessWidget {
  SearchRow({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    String query;
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
              if (child != null) child,
            ],
          ),
          SizedBox(height: 6),
          TextFormField(
            onChanged: (v) => query = v,
            style: TextStyle(color: kTextColor, fontSize: 28),
            decoration: InputDecoration.collapsed(
                hintText: 'Movie, Actors, Directors...',
                hintStyle: TextStyle(color: kTextColor, fontSize: 28),
                border: UnderlineInputBorder()),
          ),
          FlatButton(
            child: Text('Search'),
            onPressed: () {
              print(query);
              context.read<SearchCubit>().searchMovie(query);
            },
          )
        ],
      ),
    );
  }
}
