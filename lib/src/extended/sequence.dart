part of '../../mationani_extension.dart';

///
///
/// * [AniSequence]
/// * [AniSequenceStep]
/// * [AniSequenceInterval]
/// * [AniSequenceStyle]
///
///

// todo: migrate into mationani

///
///
///
typedef AniSequencer<M extends Matable> =
    Mapper<int, M> Function(
      AniSequenceStep previous,
      AniSequenceStep next,
      AniSequenceInterval interval,
    );

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
///
final class AniSequence {
  final List<Duration> durations;
  final List<Mamable> mamables;

  const AniSequence._(this.mamables, this.durations);

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
      mamable: sequence.mamables[i],
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

// extension BetweenOffsetExtension on Between<Offset> {
//   double get direction {
//     final begin = this.begin, end = this.end;
//     return math.atan2(end.dy - begin.dy, end.dx - begin.dx);
//   }
//
//   double get distance {
//     final begin = this.begin,
//         end = this.end,
//         dx = end.dx - begin.dx,
//         dy = end.dy - begin.dy;
//     return math.sqrt(dx * dx + dy * dy);
//   }
// }
