import 'package:flutter/material.dart';
import 'package:movie_app/ui/widgets/cached_image.dart';

class MovieCard extends StatelessWidget {
  const MovieCard(
      {Key key, @required this.posterPath, this.title, this.onPress})
      : super(key: key);

  final String title, posterPath;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedImage(
                  posterPath,
                  fit: BoxFit.cover,
                  height: 180,
                )),
            if (title != null) ...[
              SizedBox(height: 6),
              Container(width: 120, child: Text(title)),
            ]
          ],
        ),
      ),
    );
  }
}
