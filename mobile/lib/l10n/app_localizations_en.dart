// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AbuKaf Herbs';

  @override
  String get loginTitle => 'Login';

  @override
  String get welcomeTitle => 'Welcome to AbuKaf Herbs';

  @override
  String get registerWelcomeTitle => 'Welcome to the AbuKaf Family 🌿';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get googleLoginButton => 'Continue with Google';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccountRegister => 'Don\'t have an account? Create one';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get createAccount => 'Create account';

  @override
  String get alreadyHaveAccountLogin => 'Already have an account? Sign in';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorSomethingWrong => 'Something went wrong, please try again';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorUnauthorized => 'You are not authorized';

  @override
  String get errorUnknown => 'Unexpected error occurred';

  @override
  String get errorEmailRequired => 'Email is required';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorEmailAlreadyUsed => 'This email is already in use';

  @override
  String get errorEmailNotFound => 'No account found with this email';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errorPasswordRequired => 'Password is required';

  @override
  String get errorPasswordShort => 'Password must be at least 8 characters';

  @override
  String get errorPasswordWeak => 'Password is too weak';

  @override
  String get errorWrongPassword => 'Incorrect password';

  @override
  String get errorConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get errorPasswordsNotMatch => 'Passwords do not match';

  @override
  String get errorFirstNameRequired => 'First name is required';

  @override
  String get errorLastNameRequired => 'Last name is required';

  @override
  String get errorPhoneRequired => 'Phone number is required';

  @override
  String get errorInvalidPhone => 'Invalid phone number';

  @override
  String get errorPhoneAlreadyUsed => 'Phone number already in use';

  @override
  String get errorLoginFailed => 'Login failed';

  @override
  String get errorRegisterFailed => 'Registration failed';

  @override
  String get errorAccountDisabled => 'This account has been disabled';

  @override
  String get errorUserNotFound => 'User not found';

  @override
  String get errorGoogleCanceled => 'Google sign-in canceled';

  @override
  String get errorGoogleFailed => 'Google sign-in failed';

  @override
  String get errorLocationRequired => 'Location is required';

  @override
  String get errorLocationDenied => 'Location permission denied';

  @override
  String get errorLocationDisabled => 'Location services are disabled';

  @override
  String get errorEmptyCart => 'Your cart is empty';

  @override
  String get errorOrderFailed => 'Failed to place order';

  @override
  String get errorPaymentFailed => 'Payment failed';

  @override
  String get locationTitle => 'Set Delivery Location';

  @override
  String get locationMyLocation => 'My location';

  @override
  String get locationMoveMapHint =>
      'Move the map and place the pin accurately on your home';

  @override
  String get locationStreetLabel => 'Street name';

  @override
  String get locationBuildingLabel => 'Building number';

  @override
  String get locationFloorLabel => 'Floor';

  @override
  String get locationNotesLabel => 'Additional notes (optional)';

  @override
  String get locationNotesHint => 'Example: next to pharmacy, back entrance...';

  @override
  String get locationSaveButton => 'Save delivery location';

  @override
  String get locationServiceDisabled =>
      'Location services are disabled. Enable GPS and try again.';

  @override
  String get locationPermissionDenied =>
      'Location permission is denied. You can still pick manually on the map.';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission is permanently denied. Enable it from Settings, or pick manually on the map.';

  @override
  String get locationCantGetCurrent => 'Could not get your current location.';

  @override
  String get locationPickOnMapError => 'Please pick your location on the map.';

  @override
  String get locationStreetRequired => 'Street name is required.';

  @override
  String get locationBuildingRequired => 'Building number is required.';

  @override
  String get locationFloorRequired => 'Floor is required.';

  @override
  String get locationNotLoggedIn => 'User is not logged in.';

  @override
  String get locationSavedSuccess => 'Delivery location saved successfully.';

  @override
  String locationSaveFailed(Object error) {
    return 'Failed to save location: $error';
  }

  @override
  String get completeProfileTitle => 'Complete Profile';

  @override
  String get completeProfileSubtitle =>
      'Please enter your name and phone number to complete your account.';

  @override
  String get completeProfileSaveButton => 'Save & Continue';

  @override
  String get savedSuccess => 'Data Saved';

  @override
  String get followUs => 'Follow Us';

  @override
  String get contactUs => 'Contact us';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email and we’ll send you a link to reset your password.';

  @override
  String get resetPasswordSendButton => 'Send reset link';

  @override
  String get resetPasswordEmailSent =>
      'A password reset link has been sent to your email.';

  @override
  String get appTitle => 'Abukaf Herbs';

  @override
  String get navHome => 'Home';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get profileTitle => 'Profile';

  @override
  String get ordersPlaceholder => 'NO Orders Yet';

  @override
  String get profilePlaceholder => 'Profile Page (Later)';

  @override
  String get categoryProductsTitle => 'Products';

  @override
  String categoryProductsSubtitle(String categoryName) {
    return 'Products of $categoryName';
  }

  @override
  String get catHerbs => 'Herbs';

  @override
  String get catSpices => 'Spices';

  @override
  String get catOils => 'Oils';

  @override
  String get catHoney => 'Honey';

  @override
  String get catCosmetics => 'Cosmetics';

  @override
  String get catBestSellers => 'Best Sellers';

  @override
  String get catBundles => 'Bundles';

  @override
  String get searchHint => 'Search herbs';

  @override
  String helloUser(Object name) {
    return 'Hello, $name';
  }

  @override
  String get ourPicks => 'Our Picks';

  @override
  String get settings => 'Settings';

  @override
  String get aboutUs => 'About us';

  @override
  String get logout => 'Log out';

  @override
  String get guest => 'Guest';

  @override
  String get forYouTitle => 'For you';

  @override
  String get searchResultsTitle => 'Search results';

  @override
  String get noResults => 'No results';

  @override
  String get searchStartTyping => 'Start typing to search herbs';

  @override
  String get searchResultPlaceholder => 'Temporary search result';

  @override
  String get actionViewDetails => 'View details';

  @override
  String get actionAddToCart => 'Add to cart';

  @override
  String get toastAddedToCart => 'Added to cart';

  @override
  String get labelForYou => 'Our picks';

  @override
  String get sectionBenefits => 'Benefits';

  @override
  String get sectionHowToUse => 'How to use';

  @override
  String get sectionQuantity => 'Quantity';

  @override
  String get labelTotal => 'Total';

  @override
  String get labelMin => 'Min';

  @override
  String get labelMax => 'Max';

  @override
  String get labelStep => 'Step';

  @override
  String get labelAvailable => 'Available';

  @override
  String get labelHidden => 'Hidden';

  @override
  String get currencyJOD => 'JOD';

  @override
  String get placeholderDash => '—';

  @override
  String get unitGram => 'g';

  @override
  String get unitKilogram => 'kg';

  @override
  String get unitMilliliter => 'ml';

  @override
  String get unitLiter => 'L';

  @override
  String get unitPiece => 'piece';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get noInternetTitle => 'No internet connection';

  @override
  String get noInternetBody => 'Please check your connection and try again.';

  @override
  String get navCart => 'Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle => 'Add items to your cart to see them here.';

  @override
  String get startShopping => 'Start shopping';

  @override
  String get actionViewCart => 'View Cart';

  @override
  String get orderSummaryTitle => 'Order Summary';

  @override
  String get labelSubtotal => 'Subtotal';

  @override
  String get labelDeliveryFee => 'Delivery fee';

  @override
  String get labelGrandTotal => 'Total';

  @override
  String get paymentMethodTitle => 'Payment Method';

  @override
  String get paymentCODOnly => 'Cash on delivery (only option for now)';

  @override
  String get actionCheckout => 'Checkout';

  @override
  String get checkoutComingSoon => 'Coming soon: checkout and location flow.';

  @override
  String get labelQty => 'Qty';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionShowMore => 'Show more';

  @override
  String get actionShowLess => 'Show less';

  @override
  String get locationGateTitle => 'Location';

  @override
  String get locationSetupTitle => 'Set your location';

  @override
  String get locationEditTitle => 'Edit location';

  @override
  String get locationEnterAddress => 'Enter address details';

  @override
  String get locationGovLabel => 'Governorate';

  @override
  String get locationAreaLabel => 'Area (e.g., Jubaiha)';

  @override
  String get locationApartmentLabel => 'Apartment number';

  @override
  String get locationNextToMap => 'Next: Pick on map';

  @override
  String get locationPickOnMapTitle => 'Pick location on map';

  @override
  String get locationSave => 'Save location';

  @override
  String get locationPickFirst => 'Please pick your location on the map first.';

  @override
  String get locationDetecting => 'Detecting your location...';

  @override
  String get locationFieldRequired => 'This field is required';

  @override
  String get locationChooseGov => 'Please choose a governorate';

  @override
  String get govAmman => 'Amman';

  @override
  String get govIrbid => 'Irbid';

  @override
  String get govZarqa => 'Zarqa';

  @override
  String get govBalqa => 'Balqa';

  @override
  String get govMafraq => 'Mafraq';

  @override
  String get govJerash => 'Jerash';

  @override
  String get govAjloun => 'Ajloun';

  @override
  String get govMadaba => 'Madaba';

  @override
  String get govKarak => 'Karak';

  @override
  String get govTafilah => 'Tafilah';

  @override
  String get govMaan => 'Ma\'an';

  @override
  String get govAqaba => 'Aqaba';

  @override
  String get locationPermissionTitle => 'Location Permission Required';

  @override
  String get locationPermissionRequiredMessage =>
      'The app cannot work without location permission. Please allow location access to continue.';

  @override
  String get locationPermissionDeniedForeverMessage =>
      'Location permission is permanently denied. Please open settings and grant permission to continue.';

  @override
  String get locationServiceDisabledMessage =>
      'Location services (GPS) are disabled. Please enable them to continue.';

  @override
  String get locationRequestAgain => 'Request permission again';

  @override
  String get actionOpenSettings => 'Open settings';

  @override
  String get locationWaitingPermission => 'Waiting for location permission...';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionBack => 'Back';

  @override
  String get locationMissingInProfile =>
      'Cannot calculate delivery fee because your location data is incomplete. Please set your location first.';

  @override
  String get labelItems => 'Items';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusPreparing => 'Preparing';

  @override
  String get orderStatusDelivering => 'Delivering';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderCancelledSuccess => 'Order cancelled successfully.';

  @override
  String get orderItemsUnknown => 'Items not available';

  @override
  String get actionCancelOrder => 'Cancel order';

  @override
  String get actionContactUs => 'Contact us';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get notSet => 'Not set';

  @override
  String get noAddress => 'No address';

  @override
  String get editName => 'Edit name';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get failedToSave => 'Failed to save';

  @override
  String get featureNotAvailableYet => 'This feature is not available yet';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get buildingShort => 'Bldg';

  @override
  String get apartmentShort => 'Apt';

  @override
  String get accountLabel => 'User account';

  @override
  String get myInfoTitle => 'My Info';

  @override
  String get myInfoSubtitle => 'View & edit your details';

  @override
  String get myNameLabel => 'My name';

  @override
  String get myPhoneLabel => 'My phone';

  @override
  String get myLocationLabel => 'My location';

  @override
  String get confirmChangeLanguageTitle => 'Confirm language change';

  @override
  String get confirmChangeLanguageBody =>
      'Do you want to change the app language?';

  @override
  String get confirmChangeLanguageCta => 'Change';

  @override
  String get confirmLogoutTitle => 'Confirm logout';

  @override
  String get confirmLogoutBody => 'Are you sure you want to log out?';

  @override
  String get confirmLogoutCta => 'Logout';

  @override
  String get editPhone => 'Edit phone';

  @override
  String get editLocation => 'Edit location';

  @override
  String get continueText => 'Continue';

  @override
  String get editWarningOutForDelivery =>
      'Note: Changes will not apply to orders that are already out for delivery.';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get aboutUsBody =>
      'Abu Kaf Spice Shop - Al-Yasmeen Branch \"Your premier destination in Al-Yasmeen district for all things natural. At Abu Kaf, we take pride in offering the finest medicinal herbs, fresh spices that bring authentic flavor to your table, and a wide selection of premium nuts, natural oils, and skin and hair care products. We blend years of expertise with high quality to meet all your wellness and nutritional needs.\"';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get buildingLabel => 'Building';

  @override
  String get apartmentLabel => 'Apartment';

  @override
  String get phoneMax10Digits => 'Maximum is 10 digits';

  @override
  String get phoneAlreadyUsed => 'This phone is already used';

  @override
  String get phoneAvailable => 'Phone is available';

  @override
  String get checkingPhone => 'Checking phone...';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get ordersEmptyTitle => 'No orders yet';

  @override
  String get ordersEmptySubtitle =>
      'Place your first order to see it here and track its status.';

  @override
  String get ordersEmptyCta => 'Browse products';

  @override
  String get orderLabel => 'Order';

  @override
  String get orderStatusLabel => 'Status';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonErrorPrefix => 'Error';

  @override
  String get cancelOrderDialogTitle => 'Cancel order?';

  @override
  String get cancelOrderDialogBody =>
      'Are you sure you want to cancel this order? This action cannot be undone.';

  @override
  String get actionKeepOrder => 'Keep';

  @override
  String get actionConfirmCancel => 'Cancel order';
}
