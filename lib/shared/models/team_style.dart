import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'jersey_pattern.dart';

part 'team_style.freezed.dart';

@freezed
class KitStyle with _$KitStyle {
  const factory KitStyle({
    required Color primary,
    @Default(Colors.white) Color secondary,
    @Default(Colors.white) Color border,
    @Default(Colors.white) Color text,
    @Default(3.0) double borderWidth,
    @Default(JerseyPattern.solid) JerseyPattern pattern,
    @Default(5) int stripeCount,
    @Default(0.5) double stripeRatio,
    @Default(-45) double sashAngleDeg,
    String? numberFontFamily,
    @Default(16.0) double numberFontSize,
    @Default(FontWeight.w700) FontWeight numberFontWeight,
  }) = _KitStyle;

  const KitStyle._();

  // Handy presets
  factory KitStyle.solid({
    required Color primary,
    Color text = Colors.white,
    Color border = Colors.white,
    double borderWidth = 3.0,
  }) => KitStyle(
    primary: primary,
    text: text,
    border: border,
    borderWidth: borderWidth,
  );
}

@freezed
class TeamStyle with _$TeamStyle {
  const factory TeamStyle({
    required KitStyle regular,
    required KitStyle libero,
  }) = _TeamStyle;

  const TeamStyle._();

  factory TeamStyle.homeDefault() => TeamStyle(
    regular: KitStyle(
      primary: const Color(0xFF1565C0),
      pattern: JerseyPattern.solid,
    ),
    libero: KitStyle(
      primary: const Color(0xFFFFA000),
      pattern: JerseyPattern.solid,
    ),
  );

  factory TeamStyle.awayDefault() => TeamStyle(
    regular: KitStyle(
      primary: const Color(0xFFD32F2F),
      pattern: JerseyPattern.solid,
    ),
    libero: KitStyle(
      primary: const Color(0xFFFFA000),
      pattern: JerseyPattern.solid,
    ),
  );
}
