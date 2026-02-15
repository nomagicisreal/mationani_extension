part of '../../_mationani.dart';

///
/// [AniFromUpdater], [AniUpdaterCommand]
/// [PlaneGenerator]
/// [PlaneAlignmentGenerator]
/// [PlaneRotationGenerator]
/// [PlaneRotationRotatorGenerator]
/// [PlaneMationTransformGenerator]
///
/// [ManionPlanes]
///
///

typedef AniFromUpdater = Mapper<Consumer<AnimationController>, Ani>;
enum AniUpdaterCommand {
  reverse,
  reset,
  conditionalReverse,
  conditionalReset,
}

///
/// 
/// 
typedef PlaneRotationRotatorGenerator = Point3 Function(
  int index,
  double radian,
);
typedef PlaneRotationGenerator = MamableSet Function(
  int index,
  Between<double> radian,
);

typedef PlaneMationTransformBaseGenerator = MamableSet Function(
  int index,
);
typedef PlaneMationTransformGenerator = MamableSet Function(
  int index,
  AlignmentGeometry alignments,
  PlaneRotationGenerator rotating,
);

// ///
// ///
// /// [count]
// /// [volume]
// /// [deep], or apparent deep in radian
// /// [alignmentStack]
// /// [alignmentStackShouldDeviate]
// /// [alignments]
// ///
// /// * belows is describing the [alignments] after deviation if [alignmentStackShouldDeviate] == true  and [count] == 3,
// ///   - topLeft:
// ///     - bottomLeft --- center
// ///     - bottomRight -- left
// ///     - topLeft ------ topCenter
// ///     - topRight ----- topLeft
// ///   - bottomRight:
// ///     - topRight ----- center       (== topLeft.bottomLeft rotate 180)
// ///     - topLeft ------ right        (== topLeft.bottomRight rotate 180)
// ///     - bottomLeft --- bottomRight  (== topLeft.topRight rotate 180)
// ///     - bottomRight -- bottomCenter (== topLeft.topLeft rotate 180)
// ///
// class ManionPlanes extends ManionChildren<MamionTransform> {
//   final int count;
//   final Point3 volume;
//   final double deep;
//   final AlignmentGeometry alignmentStack;
//   final bool alignmentStackShouldDeviate;
//   final Generator<AlignmentGeometry>? alignments;
//
//   ///
//   /// [rotateStart] in here can only describe the rotation on each plane,
//   /// see [MationStackTransform.host] for rotating, translating, scaling all planes.
//   ///
//   final Between<double> rotation;
//
//   ManionPlanes({
//     this.count = 3,
//     required this.volume,
//     required this.deep,
//     required this.alignmentStack,
//     this.alignmentStackShouldDeviate = true,
//     this.alignments,
//     required List<WidgetBuilder> children,
//
//     /// mation
//     required this.rotation,
//     MamionTransform? transform,
//   }) : super(
//           children: List.generate(
//             count,
//             (i) => Mamion(
//               ability: _generatorRotation(count, deep)(i, rotation).alignAll(
//                 rotation: alignments?.call(i) ?? alignmentStack,
//               ),
//               builder: _generatorPlane(count, volume, children)(i),
//             ),
//           ),
//         );
//
//   ///
//   ///
//   ///
//   ///
//   /// private getters and methods:
//   /// [_generatorPlane]
//   /// [_generatorRotator]
//   /// [_generatorRotation]
//   ///
//   ///
//
//   ///
//   /// when [count] == 3, 'XZ plane' is the top plane
//   ///
//   static Generator<WidgetBuilder> _generatorPlane(
//     int count,
//     Point3 volume,
//     List<WidgetBuilder> children,
//   ) {
//     final builders = children;
//     final sizes = switch (count) {
//       3 => [
//           volume.retainXZAsXY.toSize,
//           volume.retainXY.toSize,
//           volume.retainYZAsYX.toSize,
//         ],
//       _ => throw UnimplementedError(),
//     };
//     return (index) {
//       final size = sizes[index];
//       final build = builders[index];
//       return (context) => SizedBox.fromSize(
//             size: size,
//             child: build(context),
//           );
//     };
//   }
//
//   ///
//   /// [deep] means apparent deep in radian
//   ///
//   static PlaneRotationGenerator _generatorRotation(int count, double deep) {
//     final deepComplementary = FDoubleExtension.radian_complementaryOf(deep);
//     final directions = switch (count) {
//       3 => [
//           Point3(deep, 0, 0),
//           Point3(deepComplementary, 0, 0),
//           Point3(deepComplementary, KDoubleExtension.radian_angle90, 0),
//         ],
//       _ => throw UnimplementedError(),
//     };
//     final rotators = _generatorRotator(count);
//
//     return (index, radian) => MamionTransform(
//           rotateBetween: Between(
//             directions[index] + rotators(index, radian.begin),
//             directions[index] + rotators(index, radian.end),
//           ),
//         );
//   }
//
//   static PlaneRotationRotatorGenerator _generatorRotator(int count) {
//     return switch (count) {
//       3 => (i, r) => i == 0 ? Point3.ofZ(r) : Point3.ofY(r),
//       _ => throw UnimplementedError(),
//     };
//   }
// }
