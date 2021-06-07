# Flutter.JetWallet

SPOT Front-End Application

<https://jetwallet-spot.mnftx.biz/#/>

<https://myjetwallet.github.io/Flutter.JetWallet/>

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
notifier: name_notifier.dart, name_state.dart, name_union.dart
provider: name_pod.dart, name_fpod.dart, name_spod.dart, name_stpod.dart, name_notipod.dart
widget: name.dart
helpers: name.dart
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
|   |   |   ├── some_state.dart (optional)
|   |   |   ├── some_state.freezed.dart (gen)
|   |   |   ├── some_union.dart (optional)
|   |   |   └── some_union.freezed.dart (gen)
|   |   └── some_other_notifier.dart  
|   ├── provider
|   |   ├── some_fpod.dart 
|   |   ├── some_notipod.dart 
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
