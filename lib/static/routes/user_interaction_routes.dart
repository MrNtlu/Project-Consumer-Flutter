class UserInteractionRoutes {
  late String _baseUserInteractionRoute;

  late String consumeLater;
  late String moveConsumeLaterAsUserList;

  UserInteractionRoutes({baseURL}) {
    _baseUserInteractionRoute = '$baseURL/consume';

    consumeLater = _baseUserInteractionRoute;
    moveConsumeLaterAsUserList = '$_baseUserInteractionRoute/move';
  }
}
