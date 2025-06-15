class OpenAIRoutes {
  late String _baseSuggestions;

  late String suggestions;
  late String notInterested;

  OpenAIRoutes({baseURL}) {
    _baseSuggestions = '$baseURL/suggestions';

    suggestions = _baseSuggestions;
    notInterested = '$_baseSuggestions/not-interested';
  }
}
