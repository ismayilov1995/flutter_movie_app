import 'package:flutter/material.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class HomeCardW extends StatelessWidget {
  HomeCardW(
      {@required this.title, this.more = 'SEE ALL', @required this.child});

  final String title, more;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCardTitle(title: title),
        SizedBox(height: 6),
        child,
      ],
    );
  }
}

class HomeCardTitle extends StatelessWidget {
  HomeCardTitle({@required this.title, this.more = 'SEE ALL'});

  final String title, more;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontFamily: 'PaytoneOne', fontSize: 22),
          ),
          TextButton(
              child: Text(
                more,
                style: TextStyle(color: kTextColor, fontSize: 14),
              ),
              onPressed: () {}),
        ],
      ),
    );
  }
}
