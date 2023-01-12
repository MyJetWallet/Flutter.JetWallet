# Flutter.JetWallet (Simple App)

## Links
[Spot Images](https://github.com/MyJetWallet/spotimages)

## Logging

All logging in the app is handled by [logging](https://pub.dev/packages/logging) package from the Dart team.


## Git flow

1. We have main branche `master`
2. `master` is considered as release branch
3. When you want to work on a new feature follow this rules:
   * Make checkout to the `<branch-type>/<branch-name>` (e.g. `feat/name`)
   * After you finish development, make a pull request and ask for review from one of your teammates
   * Name your pull requests like this `SPUI-97 > description of the feature` where `SPUI-97` is a Jira id
   * After reviewing pull request and aproving it, reviewer needs to squash it to the `develop` branch
4. Main branch types: `feat`, `fix`, `hotfix`, `debt`
5. You can name branch with ticket id or just name (e.g. feat/spui-135 or feat/some-feature-name)

## Rules

1. Always use `final` in class' parameters to make them immutable
2. All models must be immutable
3. When creating a model use `@freezed`
4. To serialize freezed model use `@json_serializable`
5. Follow already defined structure of the project/feature
6. Every new library should be discussed with the team
7. Always use `const` constructors where possible. Enables ability to use `const` on widgets
8. Always use `const` where possible in widget tree, `const` widgets are not rebuilding during UI change
9. Refactor your widgets into small ones and place them inside seperate files. Keep your widgets small

## Structure

### Project Structure

```
.
├── common
│   ├── api_client
│   │   ├── api_client.dart
│   │   ├── api_errors
│   │   └── interceptors
│   ├── di
│   ├── enums
│   ├── exceptions
│   ├── helpers
│   ├── l10n
│   ├── mixins
│   ├── models
│   ├── network
│   ├── router
│   └── themes
├── constants
├── features
│   ├── app
│   │   ├── data
│   │   │   ├── controllers
│   │   │   ├── data_sources
│   │   │   └── repositories
│   │   └── ui
│   │       ├── l10n
│   │       ├── pages
│   │       └── store
│   ├── home
│   │   └── ui
│   ├── login
│   │   ├── data
│   │   │   ├── controllers
│   │   │   │   └── login_controller.dart
│   │   │   ├── helpers
│   │   │   │   └── login_helper.dart
│   │   │   ├── services
│   │   │   │   └── login_services.dart
│   │   │   ├── data_sources
│   │   │   │   ├── login_local_data_source.dart
│   │   │   │   └── login_remote_data_source.dart
│   │   │   ├── mappers
│   │   │   ├── models
│   │   │   │   ├── authentication_model.dart
│   │   │   │   ├── post_login_request_model.dart
│   │   │   │   ├── post_login_response_model.dart
│   │   │   │   ├── user_model.dart
│   │   │   └── repositories
│   │   │       └── login_repository.dart
│   │   └── ui
│   │       ├── l10n
│   │       │   ├── en.dart
│   │       │   └── hi.dart
│   │       ├── pages
│   │       │   └── login.dart
│   │       └── store
│   │           ├── login_store.dart
│   ├── page_not_found
│   │   └── ui
│   ├── profile
│   │   └── ui
│   └── splash
│       └── ui
├── main.dart
├── services
├── utils
│   ├── alerts
│   └── log
├── widget_extends
└── widgets
```