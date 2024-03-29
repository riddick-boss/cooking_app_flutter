class AppStrings {
  static const String appName = "Cooking App";

  // login
  static const String loginTitle = "Sign in";
  static const String loginEnterValidEmailMessage = "Please enter valid email";
  static const String loginEmailTextFieldHint = "Enter email";
  static const String loginNotRegisteredYet = "Not registered yet?";
  static const String loginCreateAccountButton = "Sign up";
  static const String loginPasswordTextFieldHint = "Enter password";
  static const String loginEnterPasswordMessage = "Enter password";
  static const String loginSignInButton = "Sign in";
  static const String loginFailedToLogin = "Failed to login!";

  // sign up
  static const String signUpTitle = "Sign up";
  static const String signUpEnterFirstNameMessage = "Enter name*";
  static const String signUpFirstNameTextFieldHint = "First name*";
  static const String signUpEnterLastNameMessage = "Enter name";
  static const String signUpLastNameTextFieldHint = "Last name";
  static const String signUpEnterValidEmailMessage = "Enter valid email";
  static const String signUpEmailTextFieldHint = "Enter email*";
  static const String signUpEnterPasswordMessage = "Enter password*";
  static const String signUpPasswordTextFieldHint = "Enter password";
  static const String signUpSignUpButton = "Sign up";
  static const String signUpAlreadyRegistered = "Already registered?";
  static const String signUpAlreadyRegisteredButton = "Sign in";
  static const String signUpFailedToCreateAccount = "Failed to create account!";
  static const String signUpCollectingIngredients = "Collecting ingredients";
  static const String signUpMixing = "Mixing";
  static const String signUpTastingDishes = "Tasting wonderful dishes";
  static const String signUpReadyToCook = "Ready to cook";

  // logout
  static const String logoutTitle = "Logout";

  // dishes main drawer
  static const String dishesMainDrawerDefaultWelcomeMessage = "Hi 😃";
  static String dishesMainDrawerWelcomeMessage(String displayValue) => 'Hi, $displayValue 😃';

  // my dishes
  static const String myDishesTitle = "My dishes";

  // add dish
  static const String addDishTitle = "Add dish";
  static const String addDishPermissionsDeniedSnackBarMessage = "Cannot perform this operation without permissions!";
  static const String addDishNameHint = "Dish name";
  static const String addDishNameError = "Name cannot be empty";
  static const String addDishCategoryHint = "Category";
  static const String addDishCategoryError = "Category cannot be empty";
  static const String addDishPreparationTimeHint = "Preparation time";
  static const String addDishPreparationTimeError = "Time must be greater than 0";
  static const String addDishCreateButton = "Create dish";
  static const String addDishIngredientsHeader = "Ingredients";
  static const String addDishIngredientNameLabel = "Ingredient name";
  static const String addDishIngredientQuantityLabel = "Quantity";
  static const String addDishPreparationStepsGroupsHeader = "Preparation steps";
  static const String addDishStepsGroupNameLabel = "Steps group name";
  static const String addDishStepLabel = "Step name";
  static const String addDishSubmitPreparationTimeButton = "Submit";
  static const String addDishCreationFailureSnackBarMessage = "Dish creation failure! Try again in a moment!";
  static const String addDishNameInvalidSnackBarMessage = "Name cannot be blank!";
  static const String addDishPreparationTimeSnackBarMessage = "Preparation time must be greater than 0!";
  static const String addDishIngredientsEmptySnackBarMessage = "Ingredients cannot be empty!";
  static const String addDishPreparationStepsEmptySnackBarMessage = "Preparation steps cannot be empty!";
  static const String addDishUploading = "Creating dish...";
  static String addDishPreparationTime(int time) => 'Preparation time: $time';

  // dishes list
  static const String dishesListLoadingError = "Failed to load dishes!";

  // dish
  static const String dishTitle = "Dish";
  static const String dishLoadingError = "Failed to load dish!";
  static const String dishIngredientsTitle = "Ingredients:";
  static const String dishPreparationStepsGroupsTitle = "Preparation steps";

  // account
  static String accountTitle(String? name) => (name != null) ? "Hi, \n$name" : "Hi!";
  static const String accountLogoutButton = "Logout";
  static const String accountProvidedBy = "Provided by AbandonedSpace";

  //easy loading indicator
  static const String easyLoadingSuccess = "Success";
  static const String easyLoadingFailure = "Failure";
}
