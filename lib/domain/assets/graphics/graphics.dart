enum Graphics {
  loginSingUpBackground;
}

extension GraphicPath on Graphics {
  String _path(String asset) => "assets/graphics/$asset";

  String get path {
    switch(this) {
      case Graphics.loginSingUpBackground: return _path("login_sign_up_background.png");
    }
  }
}
