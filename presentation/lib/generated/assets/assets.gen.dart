// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.png');

  /// File path: assets/images/character_happy.png
  AssetGenImage get characterHappy =>
      const AssetGenImage('assets/images/character_happy.png');

  /// File path: assets/images/character_normal.png
  AssetGenImage get characterNormal =>
      const AssetGenImage('assets/images/character_normal.png');

  /// File path: assets/images/character_sad.png
  AssetGenImage get characterSad =>
      const AssetGenImage('assets/images/character_sad.png');

  /// File path: assets/images/level_1_background.png
  AssetGenImage get level1Background =>
      const AssetGenImage('assets/images/level_1_background.png');

  /// File path: assets/images/level_1_button.png
  AssetGenImage get level1Button =>
      const AssetGenImage('assets/images/level_1_button.png');

  /// File path: assets/images/level_2_background.png
  AssetGenImage get level2Background =>
      const AssetGenImage('assets/images/level_2_background.png');

  /// File path: assets/images/level_2_button.png
  AssetGenImage get level2Button =>
      const AssetGenImage('assets/images/level_2_button.png');

  /// File path: assets/images/level_3_background.png
  AssetGenImage get level3Background =>
      const AssetGenImage('assets/images/level_3_background.png');

  /// File path: assets/images/level_3_button.png
  AssetGenImage get level3Button =>
      const AssetGenImage('assets/images/level_3_button.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    background,
    characterHappy,
    characterNormal,
    characterSad,
    level1Background,
    level1Button,
    level2Background,
    level2Button,
    level3Background,
    level3Button,
  ];
}

abstract final class Assets {
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
