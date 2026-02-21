// List<(double, double)> divergentBinaryPartition(
//   List<(Alignment, Alignment)> pairs,
// ) {
//   assert(
//     pairs.every((pair) => pair.$1.x.abs() == 1 || pair.$2.y.abs() == 1),
//     'Every alignment must be on border.',
//   );
//
//   assert(
//     pairs.every((pair) => pair.$1.x.abs() == 1 || pair.$2.y.abs() == 1),
//     'Direction of pair.\$1 cannot higher than direction of pair.\$2',
//   );
//
//   assert(
//     !pairs.any((pair) {
//       final a = pair.$1, b = pair.$2;
//       return a.x == b.x || a.y == b.y;
//     }),
//     'Pairs cannot exist on the same border.',
//   );
//
//   final directions = pairs.mapToList((p) {
//     final pA = p.$1, pB = p.$2;
//     return math.atan2(pB.y - pA.y, pB.x - pA.x);
//   });
//
//   assert(
//     !directions.isOrdered(order: OrderLinear.increase, strictly: true),
//     'Input pairs must be sorted by their resulting direction.',
//   );
//
//   assert(
//     !_hasIntersections(pairs),
//     'Invalid binary partition: Lines intersect within the rectangle.',
//   );
//
//   final r90 = DoubleExtension.radian_angle90,
//       r270 = DoubleExtension.radian_angle270;
//   return directions.mapToList(
//     (r) => (r < -r90 ? r + r270 : r - r90, r > r90 ? r - r270 : r + r90),
//   );
// }
//
// bool _hasIntersections(List<(Alignment, Alignment)> pairs) {
//   double distanceFromTopLeft(Alignment p) {
//     if (p.y == -1) return p.x + 1; // top: 0 to 2
//     if (p.x == 1) return p.y + 3; // right: 2 to 4
//     if (p.y == 1) return p.x + 5; // bottom: 4 to 6
//     return p.y + 7; // left: 6 to 8
//   }
//
//   final length = pairs.length;
//   for (var i = 0; i < length; i++) {
//     final pA = pairs[i];
//     for (var j = i + 1; j < length; j++) {
//       final pB = pairs[j];
//       final a1 = distanceFromTopLeft(pA.$1),
//           a2 = distanceFromTopLeft(pA.$2),
//           b1 = distanceFromTopLeft(pB.$1),
//           b2 = distanceFromTopLeft(pB.$2),
//           rangeA = a1 < a2 ? (a1, a2) : (a2, a1);
//
//       if (b1 > rangeA.$2) {
//         // a1---b2---a2---b1
//         if (b2 < rangeA.$2 && b2 > rangeA.$1) return true;
//         continue;
//       }
//       if (b1 > rangeA.$1) {
//         // b2---a1---b1---a2
//         // a1---b1---a2---b2
//         if (b2 < rangeA.$1 || b2 > rangeA.$2) return true;
//         continue;
//       }
//       if (b2 > rangeA.$2) continue;
//
//       // b1---a1---b2---a2
//       if (b2 > rangeA.$1) return true;
//     }
//   }
//   return false;
// }
