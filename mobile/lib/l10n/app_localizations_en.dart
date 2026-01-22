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
      'Location permission is required to continue.';

  @override
  String get locationPermissionDeniedForever =>
      'Permission permanently denied. Enable location permission from settings.';

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
  String get locationSaveFailed => 'Failed to save location. Please try again.';

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
  String get ordersTitle => 'My Orders';

  @override
  String get profileTitle => 'Profile';

  @override
  String get ordersPlaceholder => 'Orders Page (Later)';

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
  String get logout => 'Logout';

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
}
