import 'package:flutter/material.dart';

class CustomPage<T> extends Page<T> {
  const CustomPage({
    @required this.builder,
    String name,
    Key key,
  }) : super(key: key, name: name);
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: builder,
    );
  }

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Page) {
      return key == other.key;
    } else {
      return super == other;
    }
  }
}
