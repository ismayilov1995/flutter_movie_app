import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({Key key, @required this.posterPath, this.title})
      : super(key: key);

  final String title, posterPath;

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
                posterPath,
                fit: BoxFit.cover,
                height: 180,
              )),
          if (title != null) ...[
            SizedBox(height: 6),
            Text(title),
          ]
        ],
      ),
    );
  }
}
