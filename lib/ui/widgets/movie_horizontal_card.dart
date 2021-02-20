import 'package:flutter/material.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/ui/movie/movie_detail.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class MovieHorizontalCard extends StatelessWidget {
  const MovieHorizontalCard({
    Key key,
    @required this.m,
    this.genresModel,
    this.onPress,
    this.onRemove,
    this.favBtn = false,
  }) : super(key: key);

  final Movie m;
  final GenresModel genresModel;
  final VoidCallback onPress, onRemove;
  final bool favBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieCard(
          posterPath: m.poster,
          onPress: () => MovieDetail.route(context, m.id),
        ),
        Expanded(
          child: Container(
            height: 180,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  m.title,
                  style: TextStyle(fontSize: 20),
                  softWrap: false,
                ),
                Text(
                  '${m.releaseDate.year}-${m.releaseDate.month}-${m.releaseDate.day}',
                  style: TextStyle(fontSize: 16),
                ),
                if (genresModel != null)
                  Text(
                    genresModel.getGenreTitle(m.genreIds),
                    style: TextStyle(color: kTextColor),
                  ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.pink),
                    RichText(
                      text: TextSpan(
                          text: m.voteAverage.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: '/10',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal))
                          ]),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (favBtn)
                        FlatButton(
                            child: Text('Remove'), onPressed: onRemove),
                      SizedBox(width: 12.0),
                      OutlineButton(
                          child: Text('See details'), onPressed: onPress),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
