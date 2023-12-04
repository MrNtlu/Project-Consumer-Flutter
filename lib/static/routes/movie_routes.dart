class MovieRoutes {
  late String _baseMovieRoute;

  late String movieBySortFilter;
  late String upcomingMovies;
  late String theaterMovies;
  late String searchMovies;
  late String movieDetails;

  MovieRoutes({baseURL}) {
    _baseMovieRoute = '$baseURL/movie';

    movieBySortFilter = _baseMovieRoute;
    upcomingMovies = '$_baseMovieRoute/upcoming';
    theaterMovies = '$_baseMovieRoute/theaters';
    searchMovies = '$_baseMovieRoute/search';
    movieDetails = '$_baseMovieRoute/details';
  }
}
