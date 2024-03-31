class BackendRequestMapper {
  final String name;
  final String request;

  BackendRequestMapper(this.name, this.request);
}

class BackendRequestMapperWithImage extends BackendRequestMapper {
  final String image;

  BackendRequestMapperWithImage(String name, String request, {required this.image}) : super(name, request);
}