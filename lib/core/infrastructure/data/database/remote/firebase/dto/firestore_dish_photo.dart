class FireStoreDishPhoto extends Comparable<FireStoreDishPhoto> {
  FireStoreDishPhoto({
    required this.photoUrl,
    required this.sortOrder,
    this.id,
  });

  //TODO: factory fromFirestore

  Map<String, dynamic> toFirestore() => {
        _FireStoreDishPhotoFields.photoUrl: photoUrl,
        _FireStoreDishPhotoFields.sortOrder: sortOrder,
      };

  final String photoUrl;
  final int sortOrder;
  final String? id;

  @override
  int compareTo(FireStoreDishPhoto other) => sortOrder.compareTo(other.sortOrder);
}

class _FireStoreDishPhotoFields {
  static const photoUrl = "photoUrl";
  static const sortOrder = "sortOrder";
  static const id = "id";
}
