# Flutter.JetWallet

## Links
[Spot Images](https://github.com/MyJetWallet/spotimages)

## Logging

All logging in the app is handled by [logging](https://pub.dev/packages/logging) package from the Dart team.

### Levels

1. **transport** (used in the service method) - Exception
2. **contract** (used in the service method) - Exception
3. **stateFlow** (used in the StateNotifier) - Exception
4. **notifier** (used to indicate that StateNotifier method triggered) - Info
5. **signalR** (used to log signalR events) - Exception or Info
6. **firebaseNotifications** (used to log Cloud Messaging functionality) - Exception or Info

For more info check package's documentation or source code of the app (lib/shared/logging)

## Git flow

1. We have 2 branches `master` and `develop`
2. `master` is considered as stable branch
3. We are merging `develop` into `master` at the end of each sprint (usually every 2 weeks)
4. While merging `develop` don't use squash because it will affect the history of development
5. When you want to work on a new feature follow this rules:
   * Make checkout to the `feature/my-feature`, `bug/my-bug` or techdebt/my-techdebt
   * After finishing your development make pull request on the one of your teammates.
   * Name your pull requests like this (e.g. "SPUI-97 - description of the feature" where SPUI-97 is a Jira id)
   * After reviewing pull-request and aproving it, reviewer need to squash it to the `develop` branch

## Rules

1. Always use `final` in class' parameters to make them immutable
2. All models must be immutable
3. When creating a model use `@freezed`
4. To serialize freezed model use `@json_serializable`
5. Inject all dependecies to your StateNotifiers
6. Follow already defined structure of the project/feature
7. Every new library should be discussed with the team
8. Don't use `ref.read()` inside the body of Provider, instead use `ref.watch()`
9. Always use `const` constructors where possible. Enables ability to use `const` on widgets
10. Always use `const` where possible in widget tree, `const` widgets are not rebuilding during UI change
11. Refactor your widgets into small ones and place them inside seperate files. Keep your widgets small

## Naming

### Classes

```dart
// Service
class NameService {} // facade for single units
Future<T> nameService() // single service unit (endpoint)

// Model
class NameModel {}

// State
class NameState {}
class NameUnion {}
class NameNotifier extends StateNotifier {}

// UI
class Name extends StatelessWidget {}
```

### Providers

```dart
final namePod = Provider()
final nameFpod = FutureProvider()
final nameSpod = StreamProvider()
final nameStpod = StateProvider()
final nameNotipod = StateNotifierProvider()
```

### Files

1. snake_case
2. Name of the file must mimic the name of the class/func defined inside

```text
model: name_model.dart
service: name_service.dart
notifier: name_notifier.dart, name_notipod.dart, name_state.dart, name_union.dart
provider: name_pod.dart, name_fpod.dart, name_spod.dart, name_stpod.dart
widget: name.dart
helper: name.dart
```

## Structure

### Project Structure

```text
.
├── ...
├── app                      
│   ├── screens (screen consolidates small features defined in the shared and implements its own)
|   |   ├── navigation (structure of feature)
|   |   ├── wallet (structure of feature)
|   |   └── ...
|   └── shared
|       ├── components (small ui components like button)
|       ├── models (high level models shared between screens or other features)
|       └── plugins (this folder contains all features shared between screens)
├── auth (structure of feature)
├── router (structure of feature) - decides what to show (auth or app)
├── shared
|   ├── components (small ui components shared between app, auth or router)
|   ├── services (small services - usually some libs)
|   ├── theme
|   ├── constants
|   └── ... some other small parts that are not related to any feature
└── ...
```

### Feature Structure

```text
.
├── ...
├── feature                      
│   ├── model
|   |   └── some_model.dart
|   ├── notifier
|   |   ├── some_notifier
|   |   |   ├── some_notifier.dart
|   |   |   ├── some_notipod.dart 
|   |   |   ├── some_state.dart (optional)
|   |   |   ├── some_state.freezed.dart (gen)
|   |   |   ├── some_union.dart (optional)
|   |   |   └── some_union.freezed.dart (gen)
|   |   └── some_other_notifier.dart  
|   ├── provider
|   |   ├── some_fpod.dart 
|   |   ├── some_pod.dart 
|   |   ├── some_spod.dart 
|   |   └── some_stpod.dart  
|   └── view
|       ├── components
|       |   ├── some_complex_component
|       |   |   ├── components
|       |   |   |   ├── some_part.dart
|       |   |   |   └── some_other_part.dart
|       |   |   └── some_complex_component.dart
|       |   ├── some_button.dart
|       |   └── some_text.dart
|       └── feature.dart  
└── ...
```

### Service lib Structure

```text
.
├── servcies                      
│   └── authentication
|       ├── model
|       |   ├── some_model.dart
|       |   ├── some_model.freezed.dart (gen)
|       |   └── some_model.g.dart (gen)
|       ├── service
|       |   ├── helpers (optional)
|       |   ├── services
|       |   |   └── a_service.dart
|       |   └── authentication_service.dart (acts like facade for all services of authentication)
|       └── test (tests for current service)
└── shared
        ├── models
        ├── helpers
        └── ...

```

### Notes on structuring provider, model and notifier layer

Consider the following example:

```text
notifier
    └── some_notifier
        ├── some_notifier.dart
        ├── some_notipod.dart 
        ├── some_state.dart (optional)
        ├── some_state.freezed.dart (gen)
        ├── some_union.dart (optional)
        └── some_union.freezed.dart (gen)
```

It's better to simplify it since there is only one notifier and there is no need to make additional folders:

```text
notifier
    ├── some_notifier.dart
    ├── some_notipod.dart 
    ├── some_state.dart (optional)
    ├── some_state.freezed.dart (gen)
    ├── some_union.dart (optional)
    └── some_union.freezed.dart (gen)
```

But if you will have one more notifier, now it's better to structure them by folders like that:

```text
notifier
    ├── some_notifier
    |   ├── some_notifier.dart
    |   ├── some_notipod.dart 
    |   ├── some_state.dart (optional)
    |   ├── some_state.freezed.dart (gen)
    |   ├── some_union.dart (optional)
    |   └── some_union.freezed.dart (gen)
    └── some_other_notifier
        ├── some_other_notifier.dart
        └── some_notipod.dart

```

This idea applies to model and provider layer as well.

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Algorithm for adding a new translation to the app

1. Define a feature to which that specific translation belongs. (Example: login)
2. Create a name:
   * name must start from the feature name + `_`
   * after `_` short name of the translation must be provided in camelCase

   (Example: login_credentialsError)
3. Provide description that describes use case of the transaltion and other useful information related to it
4. Add translation to the core file `lib/l10n/app_en.arb`
5. Import `app_en.arb` to the [Poeditor](https://poeditor.com/)
6. Generate other languages if there are languages other than English
7. Export all updated arb files(en, es, ru...) from Poeditor and add them under `l10n` folder
8. Inform translators or product owners about the new change

### Adding Strings (Manual)

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
@override
Widget build(BuildContext context) {
  final intl = useProvider(intlPod);
  return Text(intl.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization