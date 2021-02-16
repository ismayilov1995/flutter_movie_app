import 'package:flutter/material.dart';
import 'package:movie_app/models/models.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key key,
    @required this.m,
  }) : super(key: key);

  final Result m;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.30,
      margin: EdgeInsets.only(left: 20.0),
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
  }
}