abstract class RemoteDatabase {
  Future<void> initUserCollection({required String userUid, required String firstName, required String lastName});

  Future<void> getAllDishes(); // TODO
}
