import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FireStoreDishPhoto extends Comparable<FireStoreDishPhoto> {
  FireStoreDishPhoto({
    required this.photoUrl,
    required this.sortOrder,
    this.id,
  });

  factory FireStoreDishPhoto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) throw ArgumentError("Dish photo data from firebase is null!");
    return FireStoreDishPhoto(
      photoUrl: data[_FireStoreDishPhotoFields.photoUrl] as String,
      sortOrder: data[_FireStoreDishPhotoFields.sortOrder] as int,
      id: snapshot.id,
    );
  }

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
}
