class OpenAIRoutes {
  late String _baseSuggestions;

  late String suggestions;

  OpenAIRoutes({baseURL}) {
    _baseSuggestions = '$baseURL/suggestions';

    suggestions = _baseSuggestions;
  }
}
