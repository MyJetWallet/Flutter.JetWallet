import 'package:flutter/material.dart';

NetworkImage? setCircleBackgroundImage(String? imageUrl) {
  return (imageUrl != null) ? NetworkImage(imageUrl) : null;
}
