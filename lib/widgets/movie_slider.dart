import 'package:fl_peliculas/models/models.dart';
import 'package:flutter/material.dart';

class MoviesSlider extends StatefulWidget {
  final List<Movie> movies;

  final String? categoryMovie;

  final Function onNextPage;

  const MoviesSlider(
      {required this.movies, this.categoryMovie, required this.onNextPage});

  @override
  State<MoviesSlider> createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 500 >=
          scrollController.position.maxScrollExtent) {
        //Llamaer provider
        print('ya');
        widget.onNextPage();
      }

      print(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${widget.categoryMovie}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int i) => _MoviePosters(
              movie: widget.movies[i],
              hero: 'Slider-${i}-${widget.movies[i].id}',
            ),
            itemCount: widget.movies.length,
          ))
        ],
      ),
    );
  }
}

class _MoviePosters extends StatelessWidget {
  final Movie movie;
  final String hero;

  const _MoviePosters({required this.movie, required this.hero});

  @override
  Widget build(BuildContext context) {
    movie.heroId = hero;
    return Container(
      width: 130,
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
