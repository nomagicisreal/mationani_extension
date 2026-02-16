part of '../../mationani_extension.dart';

///
///
/// * [AniSequence]
/// * [AniSequenceStep]
/// * [AniSequenceInterval]
/// * [AniSequenceStyle]
///
/// * [MationaniSequence]
/// * [BetweenInterval]
///
///

///
///
///
typedef AniSequencer<M extends Matable> =
    Sequencer<AniSequenceStep, AniSequenceInterval, M>;

///
///
///
final class AniSequence {
  final List<Mamable> abilities;
  final List<Duration> durations;

  const AniSequence._(this.abilities, this.durations);

  factory AniSequence({
    required int totalStep,
    required AniSequenceStyle style,
    required Generator<AniSequenceStep> step,
    required Generator<AniSequenceInterval> interval,
  }) {
    final durations = <Duration>[];
    AniSequenceInterval intervalGenerator(int index) {
      final i = interval(index);
      durations.add(i.duration);
      return i;
    }

    var i = -1;
    final sequencer = AniSequence._sequencerOf(style);
    return AniSequence._(
      step.linkToListTill<AniSequenceInterval, Mamable>(
        totalStep,
        intervalGenerator,
        (previous, next, interval) => sequencer(previous, next, interval)(++i),
      ),
      durations,
    );
  }

  ///
  /// if [step] == null, there is no animation,
  /// if [step] % 2 == 0, there is forward animation,
  /// if [step] % 2 == 1, there is reverse animation,
  ///
  static Mationani mationani_mamionSequence(
    int? step, {
    Key? key,
    required AniSequence sequence,
    required Widget child,
    required AnimationControllerInitializer initializer,
  }) {
    final i = step ?? 0;
    return Mationani.mamion(
      key: key,
      ani: Ani.updateSequencingWhen(
        step == null ? null : i % 2 == 0,
        duration: sequence.durations[i],
        initializer: initializer,
      ),
      mamable: sequence.abilities[i],
      child: child,
    );
  }

  static AniSequencer<Mamable> _sequencerOf(AniSequenceStyle style) =>
      switch (style) {
        AniSequenceStyle.transformTRS => (previous, next, interval) {
          final curve = (interval.curves[0], interval.curves[0]);
          return AniSequenceStyle._sequence(
            previous: previous,
            next: next,
            combine: (begin, end) {
              final a = begin.points3;
              final b = end.points3;
              return MamableSet([
                MamableTransform.translation(
                  translate: Between(begin: a[0], end: b[0], curve: curve),
                  alignment: Alignment.topLeft,
                ),
                MamableTransform.rotation(
                  rotate: Between(begin: a[1], end: b[1], curve: curve),
                  alignment: Alignment.topLeft,
                ),
                MamableTransform.scale(
                  scale: Between(begin: a[2], end: b[2], curve: curve),
                  alignment: Alignment.topLeft,
                ),
              ]);
            },
          );
        },
        AniSequenceStyle.transitionRotateSlideBezierCubic =>
          (previous, next, interval) {
            final curve = (interval.curves[0], interval.curves[0]);
            final controlPoints = interval.offsets;
            return AniSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) => MamableSet([
                MamableTransition.rotate(
                  Between(
                    begin: begin.values[0],
                    end: end.values[0],
                    curve: curve,
                  ),
                ),
                MamableTransition.slide(
                  BetweenDepend(
                    BetweenDepend.offsetBezierCubic(
                      begin: begin.offsets[0],
                      end: end.offsets[0],
                      c1: previous.offsets[0] + controlPoints[0],
                      c2: previous.offsets[0] + controlPoints[1],
                    ),
                    curve: curve,
                  ),
                ),
              ]),
            );
          },
      };
}

///
///
final class AniSequenceStep {
  final List<double> values;
  final List<Offset> offsets;
  final List<(double, double, double)> points3;

  const AniSequenceStep({
    this.values = const [],
    this.offsets = const [],
    this.points3 = const [],
  });
}

///
///
final class AniSequenceInterval {
  final Duration duration;
  final List<Curve> curves;
  final List<Offset> offsets; // for curving control, interval step

  const AniSequenceInterval({
    this.duration = DurationExtension.second1,
    required this.curves,
    this.offsets = const [],
  });
}

///
///
enum AniSequenceStyle {
  // TRS: Translation, Rotation, Scaling
  transformTRS,

  // rotate, slide in bezier cubic
  transitionRotateSlideBezierCubic;

  ///
  /// [_forwardOrReverse] is the only way to sequence [Mamable] for now
  ///
  static bool _forwardOrReverse(int i) => i % 2 == 0;

  static Mapper<int, Mamable> _sequence({
    Predicator<int> predicator = _forwardOrReverse,
    required AniSequenceStep previous,
    required AniSequenceStep next,
    required Fusionor<AniSequenceStep, Mamable> combine,
  }) =>
      (i) => combine(
        predicator(i) ? previous : next,
        predicator(i) ? next : previous,
      );
}

///
///
///
abstract final class MationaniSequence {
  // static Between<T> between<T>({
  //   BetweenInterval weight = BetweenInterval.linear,
  //   BiCurve? curve,
  //   required List<T> steps,
  // }) =>
  //     Between(
  //       begin: steps.first,
  //       end: steps.last,
  //       onLerp: BetweenInterval._link(
  //         totalStep: steps.length,
  //         step: (i) => steps[i],
  //         interval: (i) => weight,
  //       ),
  //       curve: curve,
  //     );
  //
  // static Between<T> between_generator<T>({
  //   required int totalStep,
  //   required Generator<T> step,
  //   required Generator<BetweenInterval> interval,
  //   BiCurve? curve,
  //   Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  // }) =>
  //     Between(
  //       begin: step(0),
  //       end: step(totalStep - 1),
  //       onLerp: BetweenInterval._link(
  //         totalStep: totalStep,
  //         step: step,
  //         interval: interval,
  //         sequencer: sequencer,
  //       ),
  //       curve: curve,
  //     );
  //
  // static Between<T> outAndBack<T>({
  //   required T begin,
  //   required T target,
  //   BiCurve? curve,
  //   double ratio = 1.0,
  //   Curve curveOut = Curves.fastOutSlowIn,
  //   Curve curveBack = Curves.fastOutSlowIn,
  //   Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  // }) =>
  //     Between(
  //       begin: begin,
  //       end: begin,
  //       onLerp: BetweenInterval._link(
  //         totalStep: 3,
  //         step: (i) => i == 1 ? target : begin,
  //         interval: (i) => i == 0
  //             ? BetweenInterval(ratio, curve: curveOut)
  //             : BetweenInterval(1 / ratio, curve: curveBack),
  //         sequencer: sequencer,
  //       ),
  //       curve: curve,
  //     );
}

///
///
///
class BetweenInterval {
  final double weight;
  final Curve curve;

  Lerper<T> lerp<T>(T a, T b) {
    final curving = curve.transform;
    final onLerp = Between<T>(begin: a, end: b).transform;
    return (t) => onLerp(curving(t));
  }

  const BetweenInterval(this.weight, {this.curve = Curves.linear});

  static const BetweenInterval linear = BetweenInterval(1);

  ///
  ///
  /// the index 0 of [interval] is between index 0 and 1 of [step]
  /// the index 1 of [interval] is between index 1 and 2 of [step], and so on.
  ///
  ///
  // ignore: unused_element
  static Lerper<T> _link<T>({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  }) {
    final seq = sequencer ?? _sequencer<T>;
    var i = -1;
    return TweenSequence(
      step.linkToListTill(
        totalStep,
        interval,
        (previous, next, interval) => TweenSequenceItem<T>(
          tween: seq(previous, next, interval.lerp(previous, next))(++i),
          weight: interval.weight,
        ),
      ),
    ).transform;
  }

  static Mapper<int, Between<T>> _sequencer<T>(
    T previous,
    T next,
    Lerper<T> onLerp,
  ) =>
      (_) => Between(begin: previous, end: next, curve: null);
}


// todo: migrate into mationani

///
///
/// * [BetweenOffsetExtension]
///
///
extension BetweenOffsetExtension on Between<Offset> {
  double get direction {
    final begin = this.begin, end = this.end;
    return math.atan2(end.dy - begin.dy, end.dx - begin.dx);
  }

  double get distance {
    final begin = this.begin,
        end = this.end,
        dx = end.dx - begin.dx,
        dy = end.dy - begin.dy;
    return math.sqrt(dx * dx + dy * dy);
  }
}


///
///
///
// factory BetweenPath.linePoly(
//   double width, {
//   required List<Offset> nodes,
//   BiCurve? curve,
//   StrokeCap strokeCap = StrokeCap.round,
// }) {
//   assert(strokeCap != StrokeCap.square);
//   final length = nodes.length;
//   final intervals = List.generate(length, (index) => (index + 1) / length);
//   final between = MationaniSequence.between(steps: nodes, curve: curve);
//
//   int i = 0;
//   double bound = intervals[i];
//   Lerper<Path> lining(Offset a, Offset b) => _line(a, b, width, strokeCap);
//   Lerper<Path> drawing = lining(nodes[0], nodes[1]);
//   SizingPath draw = FSizingPath.circle(nodes[0], width);
//
//   return BetweenPath((t) {
//     if (t > bound) {
//       i++;
//       bound = intervals[i];
//       drawing = i == length - 1 ? drawing : lining(nodes[i], nodes[i + 1]);
//     }
//     draw = draw.combine(drawing(current));
//     return draw;
//   }, curve: curve);
// }

// factory BetweenPath.linePolyFromGenerator(
//   double width, {
//   required int totalStep,
//   required Generator<Offset> step,
//   required Generator<BetweenInterval> interval,
//   BiCurve? curve,
// }) {
//   throw UnimplementedError();
// }
