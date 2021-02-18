import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/ui/splash_screen.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentPage = 0;
  final tiles = [
    'Follow latest movies news',
    'Create your own movie list',
    'Get notify when your movie on screen'
  ];

  final images = ['video.png', 'database.png', 'active.png'];

  final descriptions = [
    "Every year since 2008, the number of contributions to our database has increased. With over 400,000 developers and companies using our platform, TMDb has become a premiere source for metadata.",
    "We're international. While we officially support 39 languages we also have extensive regional data. Every single day TMDb is used in over 180 countries.",
    "Trusted platform. Every single day our service is used by millions of people while we process over 3 billion requests. We've proven for years that this is a service that can be trusted and relied on."
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment(0, 0.88),
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: size.height,
            initialPage: 0,
            viewportFraction: 1.0,
            onPageChanged: (index, _) => onPageChange(index),
          ),
          items: [0, 1, 2].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return IntroTile(
                  title: tiles[i],
                  image: images[i],
                  description: descriptions[i],
                );
              },
            );
          }).toList(),
        ),
        DotsIndicator(
          dotsCount: 3,
          position: currentPage.toDouble(),
          decorator: DotsDecorator(
            spacing: const EdgeInsets.all(10.0),
            activeColor: Colors.pink,
            color: Colors.pink[100],
          ),
        ),
      ],
    ));
  }

  onPageChange(int index) {
    setState(() {
      currentPage = index;
    });
  }
}

class IntroTile extends StatelessWidget {
  const IntroTile({
    Key key,
    @required this.title,
    @required this.description,
    @required this.image,
  }) : super(key: key);

  final String title, image, description;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ort = MediaQuery.of(context).orientation == Orientation.landscape;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: ort ? size.width * 0.1 : size.width * 0.3,
              backgroundColor: Colors.pink,
              child: Image.asset(
                'assets/images/' + image,
                color: Colors.white,
                width: ort ? size.width * 0.1 : size.width * 0.3,
              ),
            ),
            SizedBox(height: 20),
            AppText(
              title,
              fontSize: 28.0,
              align: TextAlign.center,
            ),
            SizedBox(height: 10),
            AppText(
              description,
              align: TextAlign.center,
              color: Colors.pink,
            ),
            SizedBox(height: 30),
            OutlineButton(
                child: AppText('Let\'s go'),
                onPressed: () => SplashScreen.route(context))
          ],
        ),
      ),
    );
  }
}
