class OpenAIRoutes {
  late String _baseAssistant;
  late String _baseSuggestions;

  late String opinion;
  late String summary;
  late String suggestions;
  late String generateSuggestions;

  OpenAIRoutes({baseURL}) {
    _baseAssistant = '$baseURL/assistant';
    _baseSuggestions = '$baseURL/suggestions';

    opinion = '$_baseAssistant/opinion';
    summary = '$_baseAssistant/summary';
    suggestions = _baseSuggestions;
    generateSuggestions = '$_baseSuggestions/generate';
  }
}