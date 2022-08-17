class DishPhoto extends Comparable<DishPhoto> {
  DishPhoto({
    required this.photoUrl,
    required this.sortOrder,
    this.id,
  });

  final String photoUrl; // TODO: shouldn't be photo file ?
  final int sortOrder;
  final String? id;

  @override
  int compareTo(DishPhoto other) => sortOrder.compareTo(other.sortOrder);
}
