# Рефакторинг и улучшения кода

## Критичные (нужно исправить)

### 1. TapGestureRecognizer утечка памяти в WelcomePage
**Файл:** `lib/features/bank_auth/presentation/pages/welcome_page.dart`

**Проблема:** `TapGestureRecognizer` создаётся но не dispose'ится

**Решение:**
```dart
class _WelcomePageState extends State<WelcomePage> {
  late TapGestureRecognizer _privacyTapRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyTapRecognizer = TapGestureRecognizer()
      ..onTap = _openPrivacyPolicy;
  }

  @override
  void dispose() {
    _privacyTapRecognizer.dispose();
    super.dispose();
  }
}
```

### 2. SystemChrome в build() — антипаттерн
**Файлы:**
- `lib/features/bank_auth/presentation/pages/create_pin_page.dart`
- `lib/features/bank_auth/presentation/pages/confirm_pin_page.dart`

**Проблема:** `SystemChrome.setEnabledSystemUIMode()` вызывается в `build()`, который может вызываться много раз

**Решение:** Перенести в `initState()`

---

## Важные (улучшение архитектуры)

### 3. Дублирование NumPad кода
**Файлы:**
- `lib/features/bank_auth/presentation/pages/create_pin_page.dart`
- `lib/features/bank_auth/presentation/pages/confirm_pin_page.dart`
- `lib/features/pin/presentation/pages/pin_page.dart`

**Проблема:** `_buildNumberPad()`, `_buildNumberButton()`, `_DeleteButtonClipper` дублируются

**Решение:** Создать `lib/features/shared/presentation/widgets/pin_keyboard.dart`

### 4. BiometricPermissionPage не сохраняет выбор
**Файл:** `lib/features/bank_auth/presentation/pages/biometric_permission_page.dart`

**Проблема:** Кнопка "Дозволити" не сохраняет разрешение на биометрию

---

## Желательные (качество кода)

### 5. Hardcoded цвета
Создать `lib/core/theme/app_colors.dart` с константами цветов

### 6. Hardcoded строки
Создать `lib/core/constants/app_strings.dart` с текстами UI

### 7. Magic numbers
Создать `lib/core/constants/app_config.dart` с константами (pinLength, delays и т.д.)

---

## Опциональные

### 8. BLoC для PIN flow
Создать `PinCreationBloc` для логики создания/подтверждения PIN

---

## Из TODO в коде

### 9. Переход на CreatePinPage из BankWebView
**Файл:** `lib/features/bank_auth/presentation/pages/bank_webview_page.dart:74`
**Задача:** Раскомментировать переход на CreatePinPage после успешной авторизации банка

### 10. Вернуть 6 часов после тестирования
**Файл:** `lib/features/document/data/repositories/document_repository_impl.dart:110`
**Задача:** Изменить время обновления документа обратно на 6 часов

### 11. Навигация на смену PIN-кода
**Файл:** `lib/features/menu/presentation/pages/settings/settings_page.dart:101`
**Задача:** Реализовать переход на экран смены PIN-кода

---

## Статус

- [ ] 1. TapGestureRecognizer dispose
- [ ] 2. SystemChrome из build()
- [ ] 3. PinKeyboard виджет
- [ ] 4. Сохранение биометрии
- [ ] 5. AppColors
- [ ] 6. AppStrings
- [ ] 7. AppConfig
- [ ] 8. PinCreationBloc
- [ ] 9. Переход на CreatePinPage из BankWebView
- [ ] 10. Вернуть 6 часов
- [ ] 11. Смена PIN-кода в настройках
