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
  /// **'Location permission is denied. You can still pick manually on the map.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Enable it from Settings, or pick manually on the map.'**
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
  /// **'Failed to save location: {error}'**
  String locationSaveFailed(Object error);

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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Abukaf Herbs'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get ordersTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @ordersPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Orders Page (Later)'**
  String get ordersPlaceholder;

  /// No description provided for @profilePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Profile Page (Later)'**
  String get profilePlaceholder;

  /// No description provided for @categoryProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get categoryProductsTitle;

  /// No description provided for @categoryProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products of {categoryName}'**
  String categoryProductsSubtitle(String categoryName);

  /// No description provided for @catHerbs.
  ///
  /// In en, this message translates to:
  /// **'Herbs'**
  String get catHerbs;

  /// No description provided for @catSpices.
  ///
  /// In en, this message translates to:
  /// **'Spices'**
  String get catSpices;

  /// No description provided for @catOils.
  ///
  /// In en, this message translates to:
  /// **'Oils'**
  String get catOils;

  /// No description provided for @catHoney.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get catHoney;

  /// No description provided for @catCosmetics.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get catCosmetics;

  /// No description provided for @catBestSellers.
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get catBestSellers;

  /// No description provided for @catBundles.
  ///
  /// In en, this message translates to:
  /// **'Bundles'**
  String get catBundles;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search herbs'**
  String get searchHint;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(Object name);

  /// No description provided for @ourPicks.
  ///
  /// In en, this message translates to:
  /// **'Our Picks'**
  String get ourPicks;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @forYouTitle.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get forYouTitle;

  /// No description provided for @searchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResultsTitle;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @searchStartTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search herbs'**
  String get searchStartTyping;

  /// No description provided for @searchResultPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Temporary search result'**
  String get searchResultPlaceholder;

  /// No description provided for @actionViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get actionViewDetails;

  /// No description provided for @actionAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get actionAddToCart;

  /// No description provided for @toastAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get toastAddedToCart;

  /// No description provided for @labelForYou.
  ///
  /// In en, this message translates to:
  /// **'Our picks'**
  String get labelForYou;

  /// No description provided for @sectionBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get sectionBenefits;

  /// No description provided for @sectionHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get sectionHowToUse;

  /// No description provided for @sectionQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get sectionQuantity;

  /// No description provided for @labelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// No description provided for @labelMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get labelMin;

  /// No description provided for @labelMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get labelMax;

  /// No description provided for @labelStep.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get labelStep;

  /// No description provided for @labelAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get labelAvailable;

  /// No description provided for @labelHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get labelHidden;

  /// No description provided for @currencyJOD.
  ///
  /// In en, this message translates to:
  /// **'JOD'**
  String get currencyJOD;

  /// No description provided for @placeholderDash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get placeholderDash;

  /// No description provided for @unitGram.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitGram;

  /// No description provided for @unitKilogram.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKilogram;

  /// No description provided for @unitMilliliter.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMilliliter;

  /// No description provided for @unitLiter.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitLiter;

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get unitPiece;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorGeneric;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetBody.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get noInternetBody;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add items to your cart to see them here.'**
  String get cartEmptySubtitle;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get startShopping;

  /// No description provided for @actionViewCart.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get actionViewCart;

  /// No description provided for @orderSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummaryTitle;

  /// No description provided for @labelSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get labelSubtotal;

  /// No description provided for @labelDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get labelDeliveryFee;

  /// No description provided for @labelGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelGrandTotal;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodTitle;

  /// No description provided for @paymentCODOnly.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery (only option for now)'**
  String get paymentCODOnly;

  /// No description provided for @actionCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get actionCheckout;

  /// No description provided for @checkoutComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: checkout and location flow.'**
  String get checkoutComingSoon;

  /// No description provided for @labelQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get labelQty;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get actionShowMore;

  /// No description provided for @actionShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get actionShowLess;

  /// No description provided for @locationGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationGateTitle;

  /// No description provided for @locationSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your location'**
  String get locationSetupTitle;

  /// No description provided for @locationEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get locationEditTitle;

  /// No description provided for @locationEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address details'**
  String get locationEnterAddress;

  /// No description provided for @locationGovLabel.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get locationGovLabel;

  /// No description provided for @locationAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area (e.g., Jubaiha)'**
  String get locationAreaLabel;

  /// No description provided for @locationApartmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Apartment number'**
  String get locationApartmentLabel;

  /// No description provided for @locationNextToMap.
  ///
  /// In en, this message translates to:
  /// **'Next: Pick on map'**
  String get locationNextToMap;

  /// No description provided for @locationPickOnMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick location on map'**
  String get locationPickOnMapTitle;

  /// No description provided for @locationSave.
  ///
  /// In en, this message translates to:
  /// **'Save location'**
  String get locationSave;

  /// No description provided for @locationPickFirst.
  ///
  /// In en, this message translates to:
  /// **'Please pick your location on the map first.'**
  String get locationPickFirst;

  /// No description provided for @locationDetecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get locationDetecting;

  /// No description provided for @locationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get locationFieldRequired;

  /// No description provided for @locationChooseGov.
  ///
  /// In en, this message translates to:
  /// **'Please choose a governorate'**
  String get locationChooseGov;

  /// No description provided for @govAmman.
  ///
  /// In en, this message translates to:
  /// **'Amman'**
  String get govAmman;

  /// No description provided for @govIrbid.
  ///
  /// In en, this message translates to:
  /// **'Irbid'**
  String get govIrbid;

  /// No description provided for @govZarqa.
  ///
  /// In en, this message translates to:
  /// **'Zarqa'**
  String get govZarqa;

  /// No description provided for @govBalqa.
  ///
  /// In en, this message translates to:
  /// **'Balqa'**
  String get govBalqa;

  /// No description provided for @govMafraq.
  ///
  /// In en, this message translates to:
  /// **'Mafraq'**
  String get govMafraq;

  /// No description provided for @govJerash.
  ///
  /// In en, this message translates to:
  /// **'Jerash'**
  String get govJerash;

  /// No description provided for @govAjloun.
  ///
  /// In en, this message translates to:
  /// **'Ajloun'**
  String get govAjloun;

  /// No description provided for @govMadaba.
  ///
  /// In en, this message translates to:
  /// **'Madaba'**
  String get govMadaba;

  /// No description provided for @govKarak.
  ///
  /// In en, this message translates to:
  /// **'Karak'**
  String get govKarak;

  /// No description provided for @govTafilah.
  ///
  /// In en, this message translates to:
  /// **'Tafilah'**
  String get govTafilah;

  /// No description provided for @govMaan.
  ///
  /// In en, this message translates to:
  /// **'Ma\'an'**
  String get govMaan;

  /// No description provided for @govAqaba.
  ///
  /// In en, this message translates to:
  /// **'Aqaba'**
  String get govAqaba;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'The app cannot work without location permission. Please allow location access to continue.'**
  String get locationPermissionRequiredMessage;

  /// No description provided for @locationPermissionDeniedForeverMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please open settings and grant permission to continue.'**
  String get locationPermissionDeniedForeverMessage;

  /// No description provided for @locationServiceDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Location services (GPS) are disabled. Please enable them to continue.'**
  String get locationServiceDisabledMessage;

  /// No description provided for @locationRequestAgain.
  ///
  /// In en, this message translates to:
  /// **'Request permission again'**
  String get locationRequestAgain;

  /// No description provided for @actionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get actionOpenSettings;

  /// No description provided for @locationWaitingPermission.
  ///
  /// In en, this message translates to:
  /// **'Waiting for location permission...'**
  String get locationWaitingPermission;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @locationMissingInProfile.
  ///
  /// In en, this message translates to:
  /// **'Cannot calculate delivery fee because your location data is incomplete. Please set your location first.'**
  String get locationMissingInProfile;

  /// No description provided for @labelItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get labelItems;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get orderStatusPreparing;

  /// No description provided for @orderStatusDelivering.
  ///
  /// In en, this message translates to:
  /// **'Delivering'**
  String get orderStatusDelivering;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully.'**
  String get orderCancelledSuccess;

  /// No description provided for @orderItemsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Items not available'**
  String get orderItemsUnknown;

  /// No description provided for @actionCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get actionCancelOrder;

  /// No description provided for @actionContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get actionContactUs;
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
