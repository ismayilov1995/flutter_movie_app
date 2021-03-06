import 'package:flutter/material.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class HomeCardW extends StatelessWidget {
  HomeCardW(
      {@required this.title,
      this.more = 'SEE ALL',
      @required this.child,
      this.onPress});

  final String title, more;
  final VoidCallback onPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCardTitle(title: title, onPress: onPress),
        SizedBox(height: 6),
        child,
      ],
    );
  }
}

class HomeCardTitle extends StatelessWidget {
  HomeCardTitle({@required this.title, this.more = 'SEE ALL', this.onPress});

  final String title, more;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
              child: Text(
                more,
                style: TextStyle(color: kTextColor, fontSize: 14),
              ),
              onPressed: onPress),
        ],
      ),
    );
  }
}
