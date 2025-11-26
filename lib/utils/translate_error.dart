String translateFirebaseError(String errorCode) {
  switch (errorCode) {
    case '[firebase_auth/invalid-email] The email address is badly formatted.':
      return 'صيغة البريد الإلكتروني غير صحيحة.';

    case '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.':
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
    case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
      return 'هذا البريد الإلكتروني مستخدم من قبل.';
    case '[firebase_auth/weak-password] Password should be at least 6 characters':
      return 'كلمة المرور قصيرة جدًا. يجب أن تتكون من 6 أحرف على الأقل.';

    case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
      return 'تعذر الاتصال بالإنترنت. يرجى التحقق من الشبكة.';
    case '[firebase_auth/channel-error] "dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.createUserWithEmailAndPassword".':
      return 'يرجى التأكد من إدخال البريد الإلكتروني وكلمة المرور.';
      // case 'invalid-action-code':
      return 'رابط التفعيل أو إعادة التعيين غير صالح.';


    case "LateInitializationError: Field 'UserName' has not been initialized.":
      return 'بالرجاء ملء جميع الحقول.';
    case "LateInitializationError: Field 'email' has not been initialized.":
    case "LateInitializationError: Field 'password' has not been initialized.":
    case '[firebase_auth/channel-error] "dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.signInWithEmailAndPassword".':
      return 'يرجى التأكد من إدخال البريد الإلكتروني وكلمة المرور.';

    default:
      return 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
  }
}
