enum BaseState {
  init,
  loading,
  disposed
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