# Accessor

A simple variable accessor.

## Documentation

Defining variable is like
```dart
    Accessor<int>("number").data = 5;
```

Also you can access the variable with same method
```dart
    Accessor<int>("number").data;
```

You can listen variable
```dart
    Accessor<int>("number").listen((data) => print(data.toString()));
```

>Note: Listen function triggered when value is changed or removed.

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
