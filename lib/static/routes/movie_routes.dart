class MovieRoutes {
  late String _baseMovieRoute;

  late String movieBySortFilter;
  late String upcomingMovies;
  late String theaterMovies;
  late String moviesByActor;
  late String popularActors;
  late String searchMovies;
  late String movieDetails;
  late String popularStreamingPlatforms;
  late String moviesByStreamingPlatform;

  MovieRoutes({baseURL}) {
    _baseMovieRoute = '$baseURL/movie';

    movieBySortFilter = _baseMovieRoute;
    upcomingMovies = '$_baseMovieRoute/upcoming';
    theaterMovies = '$_baseMovieRoute/theaters';
    moviesByActor = '$_baseMovieRoute/actor';
    popularActors = '$_baseMovieRoute/popular-actors';
    searchMovies = '$_baseMovieRoute/search';
    movieDetails = '$_baseMovieRoute/details';
    popularStreamingPlatforms = '$_baseMovieRoute/popular-streaming-platforms';
    moviesByStreamingPlatform = '$_baseMovieRoute/streaming-platforms';
  }
}
