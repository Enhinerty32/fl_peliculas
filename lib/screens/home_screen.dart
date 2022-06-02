import 'package:fl_peliculas/providers/movie_provider.dart';
import 'package:fl_peliculas/search/search_delegate.dart';
import 'package:fl_peliculas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    /*TODO:listen:ayuda a pedir que se redibuje en provider viene  en listen: true*/

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas de cine'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
          //SingleChildScrollView crea scrollView cuando colum lo nesesfite
          child: Column(
        children: [
          //TODO:CardSwiper
          CardSwiper(
            movies: moviesProvider.onDisplayMovie,
          )
          //TODO: Slider de peliculas
          ,
          MoviesSlider(
              onNextPage: () => moviesProvider.getPopularMovie(),
              movies: moviesProvider.onPopularMovie,
              categoryMovie: 'Populares :D'),
          const SizedBox(
            height: 10,
          ),
        ],
      )),
    );
  }
}
