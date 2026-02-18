import 'package:datter/datter.dart' show Mamable, Ani;
import 'package:flutter/material.dart';

///
///
/// * [AniSequence]
/// * [AniSeqStep]
/// * [AniSeqInter]
/// * [AniSequenceStyle]
///
///

// todo: migrate into mationani

typedef DurationMamable = (Duration?, Duration?, Mamable);

abstract class Tempt {
  ///
  /// except animation controller repeats forward-reverse (0.0 ~ 1.0 ~ 0.0 ~ 1.0 ...)
  /// no animation when [step] == null
  /// forward when [step] % 2 == 0
  /// reverse when [step] % 2 == 1
  ///
  /// the [AnimationStyle] in [Ani] will be used at [_MationaniState.planForChild]
  ///
  static List<DurationMamable> sequencing<T>({
    required List<T> steps,
    required List<(Duration, Duration?)> durations,
    required Mamable Function(T, T) sequence,
  }) {
    final count = durations.length;
    assert(count + 1 == steps.length);

    final elements = <DurationMamable>[];
    var previous = steps[0];
    for (var i = 0; i < count; i++) {
      final next = steps[i + 1], style = durations[i];
      elements.add(
        i % 2 == 0
            ? (style.$1, style.$2, sequence(previous, next))
            : (style.$2, style.$1, sequence(next, previous)),
      );
      previous = next;
    }

    return elements;
  }
}

/// todo: forward to next step, sequence options:
///   1. forward all (secretly iterating steps)
///   2. forward each (onAnimating forward next)
///
///

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
//   final between = MationaniSequence.between(steps: nodes, curve);
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
//   }, curve);
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
