part of '../../_mationani.dart';

///
///
/// * [BetweenOffsetExtension]
/// * [BetweenPathOffset]
/// * [BetweenConcurrent]
///
///

typedef OnAnimate<T, S> = S Function(T value);
typedef OnAnimatePath = SizingPath Function(double t);

///
///
///
extension BetweenOffsetExtension on Between<Offset> {
  double get direction => end.direction - begin.direction;
}

// todo: migrate into mationani

///
/// [animateStadium], [animateStadiumLine]
///
/// [BetweenPathOffset.line]
/// [BetweenPathOffset.linePoly]
/// [BetweenPathOffset.linePolyFromGenerator]
///
///
class BetweenPathOffset extends BetweenDepend<SizingPath> {
  BetweenPathOffset(super.onLerp, {super.curve});

  static OnAnimatePath animateStadium(Between<Offset> between, double r) {
    const r90 = DoubleExtension.radian_angle90;
    final o = between.begin,
        direction = between.direction,
        oTop = o.direct(direction - r90, r),
        oBottom = o.direct(direction + r90, r),
        radius = Radius.circular(r),
        transform = between.transform;

    // todo: prevent closure at every tick
    return (t) {
      final direct = transform(t).direct;
      return (_) => Path()
        ..arcFromStartToEnd(oBottom, oTop, radius: radius)
        ..lineToPoint(direct(direction - r90, r))
        ..arcToPoint(direct(direction + r90, r), radius: radius)
        ..lineToPoint(oBottom);
    };
  }

  ///
  /// constructor, factories
  ///

  BetweenPathOffset.line(
    Between<Offset> between,
    double strokeWidth, {
    super.curve,
    StrokeCap strokeCap = StrokeCap.round,
  }) : assert(strokeCap == StrokeCap.round),
       super(animateStadium(between, strokeWidth));

  // // 'width' means stoke width
  //   factory BetweenPathOffset.linePoly(
  //     double width, {
  //     required List<Offset> nodes,
  //     CurveFR? curve,
  //   }) {
  //     final length = nodes.length;
  //     final intervals = List.generate(length, (index) => (index + 1) / length);
  //     final between = MationaniSequence.between(steps: nodes, curve: curve);
  //
  //     int i = 0;
  //     double bound = intervals[i];
  //     OnAnimatePath<Offset> lining(Offset a, Offset b) =>
  //         animateStadium(a, b.direction - a.direction, width);
  //     OnAnimatePath<Offset> drawing = lining(nodes[0], nodes[1]);
  //     SizingPath draw = FSizingPath.circle(nodes[0], width);
  //
  //     return BetweenPathOffset(
  //       between,
  //       onAnimate: (current) {
  //         if (t > bound) {
  //           i++;
  //           bound = intervals[i];
  //           drawing = i == length - 1 ? drawing : lining(nodes[i], nodes[i + 1]);
  //         }
  //         draw = draw.combine(drawing(current));
  //         return draw;
  //       },
  //       curve: curve,
  //     );
  //   }
  //
  //   factory BetweenPathOffset.linePolyFromGenerator(
  //     double width, {
  //     required int totalStep,
  //     required Generator<Offset> step,
  //     required Generator<BetweenInterval> interval,
  //     CurveFR? curve,
  //   }) {
  //     // final offset = Between.sequenceFromGenerator(
  //     //   totalStep: totalStep,
  //     //   step: step,
  //     //   interval: interval,
  //     //   curve: curve,
  //     // );
  //     throw UnimplementedError();
  //   }
}

// class _BetweenPathConcurrent<T> extends BetweenPath<List<T>> {
//   BetweenPathVector3D.progressingCircles({
//     double initialCircleRadius = 5.0,
//     double circleRadiusFactor = 0.1,
//     required AniUpdateIfNotAnimating setting,
//     required Paint paint,
//     required Between<double> radiusOrbit,
//     required int circleCount,
//     required Companion<Vector3D, int> planetGenerator,
//   }) : this(
//     Between<Vector3D>(
//       Vector3D(Point3.zero, radiusOrbit.begin),
//       Vector3D(KRadianPoint3.angleZ_360, radiusOrbit.end),
//     ),
//     onAnimate: (t, vector) =>
//         FSizingPath.combineAll(
//           Iterable.generate(
//             circleCount,
//                 (i) =>
//                 (size) =>
//             Path()
//               ..addOval(
//                 Rect.fromCircle(
//                   center: planetGenerator(vector, i).toPoint3,
//                   radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
//                 ),
//               ),
//           ),
//         ),
//   );
// }
//
// class BetweenPathPolygon extends _BetweenPathConcurrent<double> {
//   BetweenPathPolygon.regularCubicOnEdge({
//     required RRegularPolygonCubicOnEdge polygon,
//     Between<double>? scale,
//     Between<double>? edgeVectorTimes,
//     Mapper<RRegularPolygonCubicOnEdge, Between<double>>? cornerRadius,
//     CurveFR? curve,
//   }) : super(
//     BetweenConcurrent(
//       betweens: [
//         cornerRadius?.call(polygon) ?? Between.of(0.0),
//         edgeVectorTimes ?? Between.of(0.0),
//         scale ?? Between.of(1.0),
//       ],
//       onAnimate: (t, values) =>
//           FSizingPath.polygonCubic(
//             polygon.cubicPointsFrom(values[0], values[1]),
//             scale: values[2],
//             adjust: polygon.cornerAdjust,
//           ),
//       curve: curve,
//     ),
//   );
// }

///
///
///
// class BetweenConcurrent<T, S> {
//   final S begins;
//   final S ends;
//   final Lerper<S> onLerps;
//   final OnAnimate<List<T>, S> onAnimate;
//
//   const BetweenConcurrent._({
//     required this.begins,
//     required this.ends,
//     required this.onLerps,
//     required this.onAnimate,
//   });
//
//   factory BetweenConcurrent({
//     required List<Between<T>> betweens,
//     required OnAnimate<List<T>, S> onAnimate,
//     CurveFR? curve,
//   }) {
//     final begins = <T>[];
//     final ends = <T>[];
//     final onLerps = <Lerper<T>>[];
//     for (var tween in betweens) {
//       begins.add(tween.begin);
//       ends.add(tween.end);
//       onLerps.add(tween.onLerp);
//     }
//
//     return BetweenConcurrent._(
//       begins: onAnimate(0, begins),
//       ends: onAnimate(0, ends),
//       onLerps: (t) {
//         final values = <T>[];
//         for (var onLerp in onLerps) {
//           values.add(onLerp(t));
//         }
//         return onAnimate(t, values);
//       },
//       onAnimate: onAnimate,
//     );
//   }
// }
