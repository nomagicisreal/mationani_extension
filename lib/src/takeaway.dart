part of '../mationani_extension.dart';

///
///
/// * [FMatalue]
/// * [FMatable]
///
///

///
/// [between_double_0From], ...
/// [between_offset_0From], ...
/// [between_double3_0From], ...
///
abstract final class FMatalue {
  ///
  ///
  ///
  static Between<double> between_double_0From(double begin, [BiCurve? curve]) =>
      Between(begin, 0, curve);

  static Between<double> between_double_0To(double end, [BiCurve? curve]) =>
      Between(0, end, curve);

  static Between<double> between_double_1From(double begin, [BiCurve? curve]) =>
      Between(begin, 1, curve);

  static Between<double> between_double_1To(double end, [BiCurve? curve]) =>
      Between(1, end, curve);

  ///
  ///
  ///
  static Between<Offset> between_offset_0From(Offset begin, [BiCurve? curve]) =>
      Between(begin, Offset.zero, curve);

  static Between<Offset> between_offset_0To(Offset end, [BiCurve? curve]) =>
      Between(Offset.zero, end, curve);

  static Between<Offset> between_offset_ofDirection(
    double direction,
    double begin,
    double end, [
    BiCurve? curve,
  ]) => Between(
    Offset.fromDirection(direction, begin),
    Offset.fromDirection(direction, end),
    curve,
  );

  static Between<Offset> between_offset_ofDirection0From(
    double direction,
    double begin, {
    BiCurve? curve,
  }) => between_offset_ofDirection(direction, begin, 0, curve);

  static Between<Offset> between_offset_ofDirection0To(
    double direction,
    double end, {
    BiCurve? curve,
  }) => between_offset_ofDirection(direction, 0, end, curve);

  ///
  ///
  ///
  static Between<(double, double, double)> between_double3_0From(
    (double, double, double) begin, [
    BiCurve? curve,
  ]) => Between(begin, zeroDouble3, curve);

  static Between<(double, double, double)> between_double3_0To(
    (double, double, double) end, [
    BiCurve? curve,
  ]) => Between(zeroDouble3, end, curve);

  static const (double, double, double) zeroDouble3 = (0, 0, 0);
}

///
///
/// [generator_mamableSet_spill]
/// [generator_mamableSet_shoot],
///
///
abstract final class FMatable {
  const FMatable();

  ///
  /// [mamableSet_appear]
  /// [mamableSet_spill]
  /// [mamableSet_penetrate]
  ///
  static MamableSet mamableSet_appear({
    Alignment alignmentScale = Alignment.center,
    required Between<double> fading,
    required Between<double> scaling,
  }) => MamableSet([
    MamableTransition.fade(fading),
    MamableTransition.scale(scaling, alignment: alignmentScale),
  ]);

  static MamableSet mamableSet_spill({
    required Between<double> fading,
    required Between<Offset> sliding,
  }) => MamableSet([
    MamableTransition.fade(fading),
    MamableTransition.slide(sliding),
  ]);

  static MamableSet mamableSet_penetrate({
    double opacityShowing = 1.0,
    BiCurve? curve,
    Clip clip = Clip.hardEdge,
    required Between<double> fading,
    required Between<Rect> recting,
    required SizingPathFrom<Rect> sizingPathFrom,
  }) {
    final transform = recting.transform;
    return MamableSet([
      MamableTransition.fade(fading),
      MamableClip.pathAdjust(
        BetweenDepend((t) => sizingPathFrom(transform(t)), curve: curve),
        clipBehavior: clip,
      ),
    ]);
  }

  ///
  /// [mamableSet_drift]
  /// [mamableSet_drift3D]
  /// [mamableSet_fadeOutDrift]
  /// [mamableSet_fadeOutDrift3D]
  ///
  static MamableSet mamableSet_drift({
    Alignment rotationAlignment = Alignment.topLeft,
    required Between<double> rotation,
    required Between<Offset> sliding,
  }) => MamableSet([
    MamableTransition.rotate(rotation, alignment: rotationAlignment),
    MamableTransition.slide(sliding),
  ]);

  static MamableSet mamableSet_drift3D({
    Alignment rotationAlignment = Alignment.topLeft,
    required Between<(double, double, double)> rotation,
    required Between<Offset> sliding,
  }) => MamableSet([
    MamableTransform.rotation(rotate: rotation, alignment: rotationAlignment),
    MamableTransition.slide(sliding),
  ]);

  static MamableSet mamableSet_fadeOutDrift({
    BiCurve? fadeOutCurve,
    Alignment rotationAlignment = Alignment.topLeft,
    required Between<double> rotation,
    required Between<Offset> sliding,
  }) => MamableSet([
    MamableTransition.fadeOut(curve: fadeOutCurve),
    MamableTransition.rotate(rotation, alignment: rotationAlignment),
    MamableTransition.slide(sliding),
  ]);

  static MamableSet mamableSet_fadeOutDrift3D({
    BiCurve? fadeOutCurve,
    Alignment rotationAlignment = Alignment.topLeft,
    required Between<(double, double, double)> rotation,
    required Between<Offset> sliding,
  }) => MamableSet([
    MamableTransition.fadeOut(curve: fadeOutCurve),
    MamableTransform.rotation(rotate: rotation, alignment: rotationAlignment),
    MamableTransition.slide(sliding),
  ]);

  ///
  /// [mamableSet_enlarge]
  /// [mamableSet_zoom]
  /// [mamableSet_zoomFixed]
  ///
  static MamableSet mamableSet_enlarge({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<double> scaling,
    required Between<Offset> sliding,
  }) => MamableSet([
    MamableTransition.scale(scaling, alignment: alignmentScale),
    MamableTransition.slide(sliding),
  ]);

  static MamableSet mamableSet_zoom({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<Offset> sliding,
    required Between<double> scaling,
  }) => MamableSet([
    MamableTransition.slide(sliding),
    MamableTransition.scale(scaling, alignment: alignmentScale),
  ]);

  static MamableSet mamableSet_zoomFixed({
    required Offset destination,
    required double scaleEnd,
    double interval = 0.5, // must between 0.0 ~ 1.0
    BiCurve curveScale = (Curves.linear, Curves.linear),
    BiCurve curveSlide = (Curves.linear, Curves.linear),
  }) => MamableSet([
    MamableTransition.slide(
      Between(Offset.zero, destination, (
        curveSlide.$1.interval(0, interval),
        curveSlide.$2.interval(0, interval),
      )),
    ),
    MamableTransition.scale(
      Between(1.0, scaleEnd, (
        curveSlide.$1.interval(interval, 1),
        curveSlide.$2.interval(interval, 1),
      )),
      alignment: Alignment.center,
    ),
  ]);

  ///
  ///
  ///
  static Generator<MamableSet> generator_mamableSet_spill(
    Generator<double> direction,
    double distance, {
    BiCurve? curve,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => FMatable.mamableSet_spill(
      fading: Between(0.0, 1.0, curve),
      sliding: FMatalue.between_offset_ofDirection(
        direction(index),
        0,
        distance,
        curve.nullOrMap(BiCurveExtension.applyIntervalToEnd(interval * index)),
      ),
    );
  }

  static Generator<MamableSet> generator_mamableSet_shoot(
    Offset delta, {
    Generator<double> distribution = FKeep.generateDouble,
    BiCurve? curve,
    required Alignment alignmentScale,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => FMatable.mamableSet_zoom(
      alignmentScale: alignmentScale,
      sliding: FMatalue.between_offset_0To(delta * distribution(index), curve),
      scaling: FMatalue.between_double_1From(
        0.0,
        curve.nullOrMap(BiCurveExtension.applyIntervalToEnd(interval * index)),
      ),
    );
  }
}
