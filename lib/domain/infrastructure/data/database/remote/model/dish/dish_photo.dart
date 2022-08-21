import 'package:image_picker/image_picker.dart';

class DishPhoto extends Comparable<DishPhoto> {
  DishPhoto({
    required this.photoUrl,
    required this.sortOrder,
    this.id,
  });

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
  int compareTo(DishPhoto other) => sortOrder.compareTo(other.sortOrder);
}
