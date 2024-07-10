// TODO (Yaroslav): Refactor

final errorCodesDescriptionEn = {
  'InternalServerError': 'Something went wrong. Please try again later.',
  'WalletDoNotExist': 'Wallet is not found.',
  'CannotProcessWithdrawal': 'Withdrawal request failed. Please try again later.',
  'AddressIsNotValid': 'Invalid address.',
  'AssetDoNotFound': 'Asset is not found.',
  'AssetIsDisabled': 'Trading is not available for this asset now. Please try again later.',
  'AmountIsSmall': 'Your amount is too small.',
  'InvalidInstrument': 'Asset is not supported.',
  'KycNotPassed': 'Your account is not verified. Complete KYC verification now.',
  'AssetDoNotSupported': 'Trading is not available for this asset now. Please try again later.',
  'AmountToLarge': 'Amount to large',
  'NotSupported': 'There was a problem loading wallet address. Try again in a moment.',
  'PaymentFailed': 'Payment failed. Please try again later or contact support.',
  'InvalidCode': 'The code you entered is incorrect',
  'UnsuccessfulSend': 'Something went wrong',
  'InvalidPhone': 'Invalid phone',
  'OperationBlocked': 'Operation blocked',
  'OperationNotAllowed': 'Operation not allowed',

  //Auth
  'InvalidUserNameOrPassword': 'Invalid login or password',
  'UserNotExist': 'User not found',
  'OldPasswordNotMatch': 'You entered the wrong current password',
  'Expired': 'Session has expired. Please log in again',
  'CountryIsRestricted': 'Registration from your country is not allowed',
  'SocialNetworkNotSupported': 'Social network is not available for log in',
  'SocialNetworkNotAvailable': 'Social network is not available for log in',
  'BrandNotFound': 'Something went wrong. Please try again',
  'InvalidToken': 'Invalid token. Please log in again',
  'RecaptchaFailed': 'The CAPTCHA verification failed. Please try again',

  //Circle, Cards
  'InvalidBillingName': 'Invalid Name',
  'InvalidBillingCity': 'Invalid city',
  'InvalidBillingCountry': 'Invalid country',
  'InvalidBillingDistrict': 'Invalid district',
  'InvalidBillingPostalCode': 'Invalid postal code',
  'InvalidExpMonth': 'Invalid expiration month',
  'InvalidExpYear': 'Invalid expiration year',
  'CardCvvInvalid': 'Invalid CVV code',
  'CardExpired': 'Card is expired',
  'CardNotHonored': 'Card is not honored',
  'PhoneDuplicate': 'Phone duplicate',
  'InvalidCardNumber': 'Invalid card number',
};

final errorCodesDescriptionRu = {
  'InternalServerError': 'Что-то пошло не так. Пожалуйста, повторите попытку позже.',
  'WalletDoNotExist': 'Кошелек не найден.',
  'CannotProcessWithdrawal': 'Запрос на вывод средств не выполнен. Пожалуйста, повторите попытку'
      ' позже.',
  'AddressIsNotValid': 'Неверный адрес.',
  'AssetDoNotFound': 'Актив не найден.',
  'AssetIsDisabled': 'Торговля этим активом сейчас недоступна. Пожалуйста, повторите попытку'
      ' позже.',
  'AmountIsSmall': 'Ваша сумма слишком мала.',
  'InvalidInstrument': 'Актив не поддерживается.',
  'KycNotPassed': 'Ваш аккаунт не подтвержден. Завершите проверку KYC прямо сейчас.',
  'AssetDoNotSupported': 'Торговля этим активом сейчас недоступна. Пожалуйста, повторите попытку'
      ' позже.',
  'AmountToLarge': 'Сумма большая',
  'NotSupported': 'Не удалось загрузить адрес кошелька. Повторите попытку через мгновение.',
  'PaymentFailed': 'Платеж не прошел. Повторите попытку позже или обратитесь в службу'
      ' поддержки.',

  //Auth
  'InvalidUserNameOrPassword': 'Неправильный логин или пароль',
  'UserNotExist': 'Пользователь не найден',
  'OldPasswordNotMatch': 'Вы ввели неправильный текущий пароль',
  'Expired': 'Срок действия сеанса истек. Пожалуйста, войдите снова',
  'CountryIsRestricted': 'Регистрация из вашей страны запрещена',
  'SocialNetworkNotSupported': 'Социальная сеть недоступна для авторизации',
  'SocialNetworkNotAvailable': 'Социальная сеть недоступна для авторизации',
  'BrandNotFound': 'Что-то пошло не так. Пожалуйста, попробуйте еще раз',
  'InvalidToken': 'Неверный токен. Пожалуйста, войдите снова',
  'RecaptchaFailed': 'Проверка CAPTCHA не удалась. Пожалуйста, попробуйте еще раз',

  //Circle, Cards
  'InvalidBillingName': 'Неправильное имя',
  'InvalidBillingCity': 'Неверный город',
  'InvalidBillingCountry': 'Неверная страна',
  'InvalidBillingDistrict': 'Неверный район',
  'InvalidBillingPostalCode': 'Неверный почтовый индекс',
  'InvalidExpMonth': 'Неверный месяц истечения срока действия',
  'InvalidExpYear': 'Неверный год истечения срока действия',
  'CardCvvInvalid': 'Неверный код CVV',
  'CardExpired': 'Срок действия карты истек',
  'PhoneDuplicate': 'Дубликат телефона',
  'InvalidCardNumber': 'Инвалидная карта',
};

const emailPasswordIncorrectEn = 'The email or password you entered is incorrect';

const pinIncorrectFinalEn = 'Wrong code. Too many attempts. Try again later';

const pinIncorrectEn = 'The code you entered is incorrect';

//const emailPasswordIncorrectRu =
//'Электронная почта или пароль, которые вы ввели, неверны';

const attemptsRemainingEn = 'attempts remaining';
//const attemptsRemainingRu = 'осталось попыток';

const timeRemainingHoursEn = 'hours';

const timeRemainingHourEn = 'hour';

const timeRemainingMinutesEn = 'minutes';

const timeRemainingMinuteEn = 'minute';
