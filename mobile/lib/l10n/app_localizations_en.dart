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
  String get emailOrPhone => 'Phone or Email';

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
}
