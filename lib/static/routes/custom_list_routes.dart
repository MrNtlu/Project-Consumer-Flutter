class CustomListRoutes {
  late String _baseCustomListRoute;

  late String customLists;
  late String createCustomList;
  late String deleteCustomList;
  late String updateCustomList;
  late String addContentCustomList;
  late String deleteBulkContentCustomList;
  late String customListDetails;

  CustomListRoutes({baseURL}) {
    _baseCustomListRoute = '$baseURL/custom-list';

    customLists = _baseCustomListRoute;
    createCustomList = _baseCustomListRoute;
    deleteCustomList = _baseCustomListRoute;
    updateCustomList = _baseCustomListRoute;
    addContentCustomList = '$_baseCustomListRoute/add';
    deleteBulkContentCustomList = '$_baseCustomListRoute/content';
    customListDetails = '$_baseCustomListRoute/details';
  }
}