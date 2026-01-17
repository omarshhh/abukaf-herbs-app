import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AbuKaf Herbs'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AbuKaf Herbs'**
  String get welcomeTitle;

  /// No description provided for @registerWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the AbuKaf Family 🌿'**
  String get registerWelcomeTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @googleLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleLoginButton;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Create one'**
  String get noAccountRegister;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorRequired;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again'**
  String get errorSomethingWrong;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNetwork;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized'**
  String get errorUnauthorized;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get errorUnknown;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get errorEmailRequired;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get errorInvalidEmail;

  /// No description provided for @errorEmailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get errorEmailAlreadyUsed;

  /// No description provided for @errorEmailNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get errorEmailNotFound;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'البريد الإلكتروني أو كلمة المرور غير صحيحة'**
  String get errorInvalidCredentials;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get errorPasswordShort;

  /// No description provided for @errorPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get errorPasswordWeak;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get errorWrongPassword;

  /// No description provided for @errorConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get errorConfirmPasswordRequired;

  /// No description provided for @errorPasswordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsNotMatch;

  /// No description provided for @errorFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get errorFirstNameRequired;

  /// No description provided for @errorLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get errorLastNameRequired;

  /// No description provided for @errorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get errorPhoneRequired;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get errorInvalidPhone;

  /// No description provided for @errorPhoneAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Phone number already in use'**
  String get errorPhoneAlreadyUsed;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get errorLoginFailed;

  /// No description provided for @errorRegisterFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get errorRegisterFailed;

  /// No description provided for @errorAccountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get errorAccountDisabled;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get errorUserNotFound;

  /// No description provided for @errorGoogleCanceled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in canceled'**
  String get errorGoogleCanceled;

  /// No description provided for @errorGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get errorGoogleFailed;

  /// No description provided for @errorLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get errorLocationRequired;

  /// No description provided for @errorLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get errorLocationDenied;

  /// No description provided for @errorLocationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get errorLocationDisabled;

  /// No description provided for @errorEmptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get errorEmptyCart;

  /// No description provided for @errorOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order'**
  String get errorOrderFailed;

  /// No description provided for @errorPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get errorPaymentFailed;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Delivery Location'**
  String get locationTitle;

  /// No description provided for @locationMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get locationMyLocation;

  /// No description provided for @locationMoveMapHint.
  ///
  /// In en, this message translates to:
  /// **'Move the map and place the pin accurately on your home'**
  String get locationMoveMapHint;

  /// No description provided for @locationStreetLabel.
  ///
  /// In en, this message translates to:
  /// **'Street name'**
  String get locationStreetLabel;

  /// No description provided for @locationBuildingLabel.
  ///
  /// In en, this message translates to:
  /// **'Building number'**
  String get locationBuildingLabel;

  /// No description provided for @locationFloorLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get locationFloorLabel;

  /// No description provided for @locationNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional notes (optional)'**
  String get locationNotesLabel;

  /// No description provided for @locationNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Example: next to pharmacy, back entrance...'**
  String get locationNotesHint;

  /// No description provided for @locationSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save delivery location'**
  String get locationSaveButton;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Enable GPS and try again.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to continue.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Permission permanently denied. Enable location permission from settings.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @locationCantGetCurrent.
  ///
  /// In en, this message translates to:
  /// **'Could not get your current location.'**
  String get locationCantGetCurrent;

  /// No description provided for @locationPickOnMapError.
  ///
  /// In en, this message translates to:
  /// **'Please pick your location on the map.'**
  String get locationPickOnMapError;

  /// No description provided for @locationStreetRequired.
  ///
  /// In en, this message translates to:
  /// **'Street name is required.'**
  String get locationStreetRequired;

  /// No description provided for @locationBuildingRequired.
  ///
  /// In en, this message translates to:
  /// **'Building number is required.'**
  String get locationBuildingRequired;

  /// No description provided for @locationFloorRequired.
  ///
  /// In en, this message translates to:
  /// **'Floor is required.'**
  String get locationFloorRequired;

  /// No description provided for @locationNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User is not logged in.'**
  String get locationNotLoggedIn;

  /// No description provided for @locationSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delivery location saved successfully.'**
  String get locationSavedSuccess;

  /// No description provided for @locationSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save location. Please try again.'**
  String get locationSaveFailed;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name and phone number to complete your account.'**
  String get completeProfileSubtitle;

  /// No description provided for @completeProfileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get completeProfileSaveButton;

  /// No description provided for @savedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data Saved'**
  String get savedSuccess;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send you a link to reset your password.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get resetPasswordSendButton;

  /// No description provided for @resetPasswordEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email.'**
  String get resetPasswordEmailSent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
