import 'package:image_picker/image_picker.dart';

class FireStoreDishPhoto extends Comparable<FireStoreDishPhoto> {
  FireStoreDishPhoto({
    required this.photoUrl,
    required this.sortOrder,
    this.id,
  });

  //TODO: factory fromFirestore

  Map<String, dynamic> toFirestore(String downloadUrl) => {
        _FireStoreDishPhotoFields.photoUrl: downloadUrl,
        _FireStoreDishPhotoFields.sortOrder: sortOrder,
      };

  final String photoUrl;
  final int sortOrder;
  final String? id;

  XFile? xFile() {
    try {
      return XFile(photoUrl);
    } catch(e) {
      return null;
    }
  }

  @override
  int compareTo(FireStoreDishPhoto other) => sortOrder.compareTo(other.sortOrder);
}

class _FireStoreDishPhotoFields {
  static const photoUrl = "photoUrl";
  static const sortOrder = "sortOrder";
  static const id = "id";
}
