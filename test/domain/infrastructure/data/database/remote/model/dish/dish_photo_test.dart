import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("dish photos compareTo sorting properly", () {
    final photo1 = DishPhoto(photoUrl: "photoUrl1", sortOrder: 0);
    final photo2 = DishPhoto(photoUrl: "photoUrl2", sortOrder: 1);
    final photo3 = DishPhoto(photoUrl: "photoUrl3", sortOrder: 2);

    final list = [photo2, photo3, photo1]
      ..sort();

    expect(list.map((e) => e.photoUrl), [photo1.photoUrl, photo2.photoUrl, photo3.photoUrl]);
    expect(list, [photo1, photo2, photo3]);
  });

  test("xFile returns file when photo url valid", () {
    final photo = DishPhoto(photoUrl: "https://www.google.pl/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png", sortOrder: 0);

    final xFile = photo.xFile();

    expect(xFile != null, true);
  });
}
