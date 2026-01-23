// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'AbuKaf Herbs';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get welcomeTitle => 'أهلاً بك في AbuKaf Herbs';

  @override
  String get registerWelcomeTitle => 'مرحبًا بك في عائلة أبو كف 🌿';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get googleLoginButton => 'الدخول باستخدام Google';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get noAccountRegister => 'ليس لديك حساب؟ أنشئ حسابًا';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccountLogin => 'لديك حساب؟ تسجيل الدخول';

  @override
  String get errorRequired => 'هذا الحقل مطلوب';

  @override
  String get errorSomethingWrong => 'حدث خطأ، يرجى المحاولة مرة أخرى';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorUnauthorized => 'غير مصرح لك';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع';

  @override
  String get errorEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get errorInvalidEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String get errorEmailAlreadyUsed => 'البريد الإلكتروني مستخدم مسبقًا';

  @override
  String get errorEmailNotFound => 'لا يوجد حساب بهذا البريد الإلكتروني';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errorPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get errorPasswordShort => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get errorPasswordWeak => 'كلمة المرور ضعيفة';

  @override
  String get errorWrongPassword => 'كلمة المرور غير صحيحة';

  @override
  String get errorConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get errorPasswordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorFirstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get errorLastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get errorPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get errorInvalidPhone => 'رقم الهاتف غير صحيح';

  @override
  String get errorPhoneAlreadyUsed => 'رقم الهاتف مستخدم مسبقًا';

  @override
  String get errorLoginFailed => 'فشل تسجيل الدخول';

  @override
  String get errorRegisterFailed => 'فشل إنشاء الحساب';

  @override
  String get errorAccountDisabled => 'تم تعطيل هذا الحساب';

  @override
  String get errorUserNotFound => 'المستخدم غير موجود';

  @override
  String get errorGoogleCanceled => 'تم إلغاء تسجيل الدخول عبر Google';

  @override
  String get errorGoogleFailed => 'فشل تسجيل الدخول عبر Google';

  @override
  String get errorLocationRequired => 'الموقع مطلوب';

  @override
  String get errorLocationDenied => 'تم رفض إذن الموقع';

  @override
  String get errorLocationDisabled => 'خدمات الموقع غير مفعلة';

  @override
  String get errorEmptyCart => 'سلة المشتريات فارغة';

  @override
  String get errorOrderFailed => 'فشل تنفيذ الطلب';

  @override
  String get errorPaymentFailed => 'فشل الدفع';

  @override
  String get locationTitle => 'حدد موقع التوصيل';

  @override
  String get locationMyLocation => 'موقعي';

  @override
  String get locationMoveMapHint => 'حرّك الخريطة وضع الدبوس على بيتك بدقة';

  @override
  String get locationStreetLabel => 'اسم الشارع';

  @override
  String get locationBuildingLabel => 'رقم البناية';

  @override
  String get locationFloorLabel => 'الطابق';

  @override
  String get locationNotesLabel => 'ملاحظات إضافية (اختياري)';

  @override
  String get locationNotesHint => 'مثال: بجانب الصيدلية، مدخل خلفي...';

  @override
  String get locationSaveButton => 'حفظ موقع التوصيل';

  @override
  String get locationServiceDisabled =>
      'خدمة الموقع مطفأة. فعّل GPS ثم أعد المحاولة.';

  @override
  String get locationPermissionDenied => 'لا يمكن المتابعة بدون إذن الموقع.';

  @override
  String get locationPermissionDeniedForever =>
      'الإذن مرفوض نهائيًا. افتح إعدادات التطبيق وفعّل إذن الموقع.';

  @override
  String get locationCantGetCurrent => 'تعذر الحصول على موقعك الحالي.';

  @override
  String get locationPickOnMapError => 'حدد موقعك على الخريطة.';

  @override
  String get locationStreetRequired => 'أدخل اسم الشارع.';

  @override
  String get locationBuildingRequired => 'أدخل رقم البناية.';

  @override
  String get locationFloorRequired => 'أدخل رقم الطابق.';

  @override
  String get locationNotLoggedIn => 'المستخدم غير مسجل دخول.';

  @override
  String get locationSavedSuccess => 'تم حفظ موقع التوصيل بنجاح.';

  @override
  String get locationSaveFailed => 'فشل حفظ الموقع. حاول مرة أخرى.';

  @override
  String get completeProfileTitle => 'إكمال الملف الشخصي';

  @override
  String get completeProfileSubtitle =>
      'يرجى إدخال اسمك ورقم هاتفك لإكمال حسابك.';

  @override
  String get completeProfileSaveButton => 'حفظ وإكمال';

  @override
  String get savedSuccess => 'تم حفظ البيانات';

  @override
  String get followUs => 'تابعنا';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get resetPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get resetPasswordSendButton => 'إرسال رابط الاستعادة';

  @override
  String get resetPasswordEmailSent =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني.';

  @override
  String get appTitle => 'أبوكاف للأعشاب';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navOrders => 'الطلبات';

  @override
  String get navProfile => 'حسابي';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String get ordersTitle => 'طلباتي';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get ordersPlaceholder => 'صفحة الطلبات (لاحقًا)';

  @override
  String get profilePlaceholder => 'صفحة الحساب (لاحقًا)';

  @override
  String get categoryProductsTitle => 'المنتجات';

  @override
  String categoryProductsSubtitle(String categoryName) {
    return 'منتجات فئة $categoryName';
  }

  @override
  String get catHerbs => 'أعشاب';

  @override
  String get catSpices => 'بهارات';

  @override
  String get catOils => 'زيوت';

  @override
  String get catHoney => 'عسل';

  @override
  String get catCosmetics => 'مستحضرات تجميل';

  @override
  String get catBestSellers => 'الأكثر مبيعًا';

  @override
  String get catBundles => 'البكجات';

  @override
  String get searchHint => 'ابحث عن الأعشاب';

  @override
  String helloUser(Object name) {
    return 'مرحباً، $name';
  }

  @override
  String get ourPicks => 'اخترنالك';

  @override
  String get settings => 'الإعدادات';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get guest => 'زائر';

  @override
  String get forYouTitle => 'من أجلك';

  @override
  String get searchResultsTitle => 'نتائج البحث';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get searchStartTyping => 'ابدأ بالكتابة للبحث عن الأعشاب';

  @override
  String get searchResultPlaceholder => 'نتيجة بحث مؤقتة';

  @override
  String get actionViewDetails => 'عرض التفاصيل';

  @override
  String get actionAddToCart => 'إضافة إلى السلة';

  @override
  String get toastAddedToCart => 'تمت الإضافة إلى السلة';

  @override
  String get labelForYou => 'اخترنالك';

  @override
  String get sectionBenefits => 'الفوائد';

  @override
  String get sectionHowToUse => 'طريقة الاستعمال';

  @override
  String get sectionQuantity => 'الكمية';

  @override
  String get labelTotal => 'الإجمالي';

  @override
  String get labelMin => 'الحد الأدنى';

  @override
  String get labelMax => 'الحد الأعلى';

  @override
  String get labelStep => 'الزيادة';

  @override
  String get labelAvailable => 'متاح';

  @override
  String get labelHidden => 'مخفي';

  @override
  String get currencyJOD => 'د.أ';

  @override
  String get placeholderDash => '—';

  @override
  String get unitGram => 'غ';

  @override
  String get unitKilogram => 'كغ';

  @override
  String get unitMilliliter => 'مل';

  @override
  String get unitLiter => 'لتر';

  @override
  String get unitPiece => 'قطعة';

  @override
  String get errorGeneric => 'حدث خطأ';

  @override
  String get noProductsFound => 'لا توجد منتجات';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetBody => 'تحقق من الاتصال ثم حاول مرة أخرى.';

  @override
  String get navCart => 'السلة';

  @override
  String get cartEmptyTitle => 'السلة فارغة';

  @override
  String get cartEmptySubtitle => 'أضف بعض المنتجات لبدء الطلب';

  @override
  String get startShopping => 'ابدأ التسوق';
}
