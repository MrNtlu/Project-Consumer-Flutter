class BackendRequestMapper {
  final String name;
  final String request;

  BackendRequestMapper(this.name, this.request);
}

class BackendRequestMapperWithImage extends BackendRequestMapper {
  final String image;

  BackendRequestMapperWithImage(super.name, super.request, {required this.image});
}