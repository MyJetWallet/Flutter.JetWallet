# Flutter.SimpleNetworking

## Project Structure

```
├── core # Library executable files
│   ├── simple_networking.dart # Abstract class SimpleNetworking
│   └── simple_networking_impl.dart # Implementation of SimpleNetworking
├── api_client # The main http client, through which requests to the API are made
│   ├── interceptors
│   └── api_client.dart
├── config # Some constants and configurations
│   ├── options.dart # SimpleOptions - Here we store all the settings
│   └── constants.dart
├── helpers # Various methods, functions and additional models
│   ├── api_errors
│   └── models
└── modules # Folder with basic modules
    └── auth-api # Api Module
        ├── models # Models
        │   └── model_name.dart
        ├── data_sources # Requests post, get
        │   └── auth_data_sources.dart
        ├── mappers/helpers # Various mappers and helpers for this module
        │   └── auth_mapper.dart
        ├── usecases/tests # Tests for this module
        │   └── use_case_for_some_event.dart
        └── repositories #
            └── auth_repository.dart # Repository for working with data obtained through/in data_sources
```
