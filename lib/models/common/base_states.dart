enum BaseState {
  init,
  loading,
  view,
  disposed
}

enum NetworkState {
  init,
  loading,
  success,
  error,
  disposed,
}

enum ListState {
  init,
  loading,
  done,
  empty,
  error,
  //paginating,
  disposed
}

enum DetailState {
  init,
  view,
  loading,
  error,
  disposed,
}