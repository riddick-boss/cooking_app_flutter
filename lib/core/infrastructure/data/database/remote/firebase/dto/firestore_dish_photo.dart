import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreDishPhoto extends Comparable<FirestoreDishPhoto> {
  FirestoreDishPhoto({
    required this.photoUrl,
    required this.sortOrder,
    this.id,
  });

  factory FirestoreDishPhoto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) throw ArgumentError("Dish photo data from firebase is null!");
    return FirestoreDishPhoto(
      photoUrl: data[_FirestoreDishPhotoFields.photoUrl] as String,
      sortOrder: data[_FirestoreDishPhotoFields.sortOrder] as int,
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore(String downloadUrl) => {
        _FirestoreDishPhotoFields.photoUrl: downloadUrl,
        _FirestoreDishPhotoFields.sortOrder: sortOrder,
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
  int compareTo(FirestoreDishPhoto other) => sortOrder.compareTo(other.sortOrder);
}

class _FirestoreDishPhotoFields {
  static const photoUrl = "photoUrl";
  static const sortOrder = "sortOrder";
}
