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

## Build Scripts

### `build_process.sh`

This script manages Dart and Flutter build processes for the entire project, including plugins.

- **Tasks Performed:**
   1. Runs `flutter pub get` for the root project.
   2. Runs `flutter pub get` for each plugin located in the `plugins` directory.
   3. Executes `dart run build_runner build --delete-conflicting-outputs` for each plugin.
   4. Executes the same `build_runner` command for the root project.

- **Usage:**
   1. Navigate to the `scripts` directory in your terminal.
   2. Ensure the script is executable (on macOS/Linux): `chmod +x build_process.sh`
   3. Run the script: `./build_process.sh`

  **Note:** For Windows users, use Git Bash or a similar Bash emulator to run the script.

### `simple_build_process.sh`

This script runs `flutter pub get` and `build_runner` for the root project only, without involving any plugins.

- **Tasks Performed:**
   1. Runs `flutter pub get` for the root project.
   2. Executes `dart run build_runner build --delete-conflicting-outputs` for the root project.

- **Usage:**
   1. Navigate to the `scripts` directory in your terminal.
   2. Ensure the script is executable (on macOS/Linux): `chmod +x simple_build_process.sh`
   3. Run the script: `./simple_build_process.sh`

  **Note:** For Windows users, use Git Bash or a similar Bash emulator to run the script.

### `generate_release_notes.sh`

This script automatically generates release notes in JSON format for the project, including the current Git branch name and the last 5 commit messages.

- **Tasks Performed:**
    1. Retrieves the current Git branch name.
    2. Retrieves the last 5 Git commit messages.
    3. Creates a `release_notes.json` file in the root directory with the branch name and commit messages.

- **Usage:**
    1. Navigate to the `scripts` directory in your terminal.
    2. Ensure the script is executable (on macOS/Linux): `chmod +x generate_release_notes.sh`
    3. Run the script: `./generate_release_notes.sh`

- **Platform-specific Instructions:**
    - **macOS/Linux:**
        1. Open Terminal and navigate to the `scripts` directory.
        2. Make the script executable: `chmod +x generate_release_notes.sh`
        3. Run the script: `./generate_release_notes.sh`

    - **Windows:**
        1. Open Command Prompt, PowerShell, or Git Bash and navigate to the `scripts` directory.
        2. Use Git Bash or another Bash emulator to run the script.
        3. Run the script: `./generate_release_notes.sh` (or `bash generate_release_notes.sh` in Command Prompt/PowerShell).

- **Note:**
    - Ensure Git is installed and configured in your environment.