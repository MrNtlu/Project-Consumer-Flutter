class CustomListRoutes {
  late String _baseCustomListRoute;

  late String customLists;
  late String bookmarkedCustomLists;
  late String likededCustomLists;
  late String createCustomList;
  late String deleteCustomList;
  late String updateCustomList;
  late String likeCustomList;
  late String bookmarkCustomList;
  late String addContentCustomList;
  late String deleteBulkContentCustomList;
  late String customListDetails;

  CustomListRoutes({baseURL}) {
    _baseCustomListRoute = '$baseURL/custom-list';

    customLists = _baseCustomListRoute;
    likededCustomLists = '$_baseCustomListRoute/liked';
    bookmarkedCustomLists = '$_baseCustomListRoute/bookmarked';
    customListDetails = '$_baseCustomListRoute/details';
    createCustomList = _baseCustomListRoute;
    deleteCustomList = _baseCustomListRoute;
    updateCustomList = _baseCustomListRoute;
    likeCustomList = '$_baseCustomListRoute/like';
    bookmarkCustomList = '$_baseCustomListRoute/bookmark';
    addContentCustomList = '$_baseCustomListRoute/add';
    deleteBulkContentCustomList = '$_baseCustomListRoute/content';
  }
}