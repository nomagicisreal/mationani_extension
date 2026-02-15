part of '../../_mationani.dart';

///
/// [PlanesComposerCombiner]
/// [PlanesComposerTranslation]
/// [PlanesComposerCommand]
/// [PlanesComposer]
/// [_PlanesComposerBase]
/// [_PlanesComposerTranslationManager]
/// [_PlanesComposerCommandExecutor]
///   * [_PlanesComposerExecutorListExtension]
///
///
///
///
///

// typedef PlanesComposerCombiner = Combiner<PlanesComposerCommand>;

// enum PlanesComposerTranslation {
//   aAlignB,
//   bAlignA,
//   aEncloseB,
//   bEncloseA,
//   center,
//   centerTouch,
//   centerStagger,
//   centerEnclose,
//   centerEncloseDistance,
//   centerEncloseDistanceFar,
// }
//
// class PlanesComposerCommand {
//   final OnAnimateMatrix4 type;
//   final int childIndex;
//
//   const PlanesComposerCommand({
//     required this.type,
//     required this.childIndex,
//   });
//
//   static final List<PlanesComposerCommand> values = [
//     const PlanesComposerCommand(
//       type: MamionTransformDelegate.onRotating,
//       childIndex: 0,
//     ),
//     const PlanesComposerCommand(
//       type: MamionTransformDelegate.onRotating,
//       childIndex: 1,
//     ),
//     const PlanesComposerCommand(
//       type: MamionTransformDelegate.onTranslating,
//       childIndex: 0,
//     ),
//     const PlanesComposerCommand(
//       type: MamionTransformDelegate.onTranslating,
//       childIndex: 1,
//     ),
//   ];
// }
//
// class PlanesComposer extends _PlanesComposerBase {
//   const PlanesComposer({
//     required super.volume,
//     required super.radianApparentDeep,
//     required super.radianTarget,
//     required super.targetTranslation,
//     super.planesCount = 3,
//     super.borderWidth = 0.0,
//   });
//
//   Coordinate _translate({
//     required bool? isForward,
//     required bool toTarget,
//     required Coordinate target,
//   }) =>
//       isForward == null
//           ? Coordinate.zero
//           : isForward
//               ? toTarget
//                   ? target
//                   : Coordinate.zero
//               : toTarget
//                   ? Coordinate.zero
//                   : target;
//
//   double _rotate({
//     required bool? isForward,
//     required bool toTarget,
//   }) =>
//       isForward == null
//           ? 0
//           : isForward
//               ? toTarget
//                   ? radianTarget
//                   : 0
//               : toTarget
//                   ? 0
//                   : radianTarget;
//
//   List<Widget> _planes({
//     required bool? animationIsForward,
//     required Ani ani,
//     required List<Alignment> alignments,
//     required List<List<_PlanesComposerCommandExecutor>> executorsList,
//     required List<List<WidgetBuilder>> children,
//   }) {
//     assert(
//       alignments.length == executorsList.length &&
//           alignments.length == children.length,
//       'invalid length',
//     );
//     final result = <Widget>[];
//
//     final childrenLength = alignments.length;
//     for (var i = 0; i < childrenLength; i++) {
//       final alignment = alignments[i];
//       final command = executorsList[i];
//       final translate = command.firstTranslate;
//       final rotate = command.firstRotate;
//
//       final translation = _targetTranslation(alignment);
//       result.add(
//         _container(
//           Mationani(
//             ani: ani,
//             mation: Manion.stack(
//               ability: ManionPlanes(
//                 count: planesCount,
//                 alignmentStack: alignment,
//                 deep: radianApparentDeep,
//                 volume: volume,
//                 transform: MamionTransform(
//                   translateBetween: Between(
//                     _translate(
//                       isForward: animationIsForward,
//                       toTarget: translate.haveAnimate,
//                       target: translation,
//                     ),
//                     _translate(
//                       isForward: animationIsForward,
//                       toTarget: translate.shouldAnimate,
//                       target: translation,
//                     ),
//                   ),
//                 ),
//                 rotation: Between(
//                   _rotate(
//                     isForward: animationIsForward,
//                     toTarget: rotate.haveAnimate,
//                   ),
//                   _rotate(
//                     isForward: animationIsForward,
//                     toTarget: rotate.shouldAnimate,
//                   ),
//                 ),
//                 children: children[i],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return result;
//   }
// }
//
// ///
// ///
// /// [borderWidth]
// /// [volume], [planesCount], [radianApparentDeep]
// /// [radianTarget], [targetTranslation]
// ///
// /// [width], [height], [deep]
// /// [_apparentHeight]
// /// [_topPlaneDiagonal]
// /// [_center]
// /// [_containerWidth], [_containerHeight], [_container], [_planesContainer]
// ///
// /// [_topPlaneDiagonalRotate], [_topPlaneDiagonalRotateStart]
// /// [_targetTranslation]
// ///
// ///
// abstract class _PlanesComposerBase {
//   final double borderWidth;
//   final Coordinate volume;
//   final int planesCount;
//   final double radianApparentDeep; // radian
//   final double radianTarget; // radian
//   final PlanesComposerTranslation targetTranslation;
//
//   const _PlanesComposerBase({
//     /// used for container
//     required this.borderWidth,
//
//     /// used for planes setup
//     required this.volume,
//     required this.planesCount,
//     required this.radianApparentDeep,
//
//     /// used for target animation
//     required this.radianTarget,
//     required this.targetTranslation,
//   });
//
//   ///
//   /// getters
//   ///
//
//   double get width => volume.dx;
//
//   double get height => volume.dy;
//
//   double get deep => volume.dz;
//
//   double get _apparentHeight => height * math.sin(radianApparentDeep);
//
//   double get _topPlaneDiagonal => math.sqrt(width * width + deep * deep);
//
//   double get _center =>
//       math.sqrt(width * width + deep * deep + height * height) / 2;
//
//   double get _containerWidth => math.max(width, deep);
//
//   double get _containerHeight => math.max(height, deep);
//
//   Widget _container(Widget child) => borderWidth == 0
//       ? SizedBox(width: _containerWidth, height: _containerHeight, child: child)
//       : Container(
//           width: _containerWidth + borderWidth * 2,
//           height: _containerHeight + borderWidth * 2,
//           decoration: BoxDecoration(border: Border.all(width: borderWidth)),
//           child: child,
//         );
//
//   ///
//   ///
//   /// rotation usages:
//   /// [_topPlaneDiagonalRotateStart]
//   /// [_topPlaneDiagonalRotate]
//   ///
//   ///
//   double get _topPlaneDiagonalRotate =>
//       _topPlaneDiagonalRotateStart + radianTarget;
//
//   double get _topPlaneDiagonalRotateStart {
//     final tangent = deep / width;
//     if (tangent == 1) {
//       return KDoubleExtension.radian_angle45;
//     } else {
//       final isOver45 = tangent > 1;
//
//       double value;
//       double radian = isOver45 ? KDoubleExtension.radian_angle45 : 0.0;
//       final end = isOver45 ? KDoubleExtension.radian_angle90 : KDoubleExtension.radian_angle45;
//       while (radian <= end) {
//         value = tangent - math.tan(radian);
//
//         if (value > 1E-4) {
//           radian += KDoubleExtension.radian_angle1;
//         } else if (value > 1E-1) {
//           radian += KDoubleExtension.radian_angle01;
//         } else {
//           break;
//         }
//       }
//       return radian;
//     }
//   }
//
//   ///
//   ///
//   /// translation
//   ///
//   ///
//   ///
//   Coordinate _targetTranslation(Alignment current) {
//     late final _PlanesComposerTranslationManager translation;
//
//     // top left
//     if (current == Alignment.topLeft) {
//       translation = _PlanesComposerTranslationManager(
//         category: targetTranslation,
//         pair: const MapEntry(Alignment.topLeft, Alignment.bottomRight),
//         radianApparentDeep: radianApparentDeep,
//         radianDeltaTopPlaneDiagonal:
//             _topPlaneDiagonalRotate + KDoubleExtension.radian_angle180,
//         lengthTopPlaneDiagonal: _topPlaneDiagonal,
//         lengthCenter: _center,
//         center: Coordinate(_containerWidth / 2, _containerHeight / 2, 0),
//         corner: Coordinate(
//           _containerWidth,
//           _containerHeight - _apparentHeight,
//           0,
//         ),
//         height: Coordinate.ofY(-_apparentHeight),
//       );
//
//       // bottom right
//     } else if (current == Alignment.bottomRight) {
//       translation = _PlanesComposerTranslationManager(
//         category: targetTranslation,
//         pair: const MapEntry(Alignment.bottomRight, Alignment.topLeft),
//         radianApparentDeep: radianApparentDeep,
//         radianDeltaTopPlaneDiagonal: _topPlaneDiagonalRotate,
//         lengthTopPlaneDiagonal: _topPlaneDiagonal,
//         lengthCenter: _center,
//         center: Coordinate(-_containerWidth / 2, -_containerHeight / 2, 0),
//         corner: Coordinate(
//           -_containerWidth,
//           -_containerHeight + _apparentHeight,
//           0,
//         ),
//         height: Coordinate.ofY(_apparentHeight),
//       );
//     } else {
//       throw UnimplementedError();
//     }
//     return translation.value;
//   }
// }
//
// class _PlanesComposerTranslationManager {
//   final PlanesComposerTranslation category;
//   final MapEntry<Alignment, Alignment> pair;
//   final double radianApparentDeep;
//   final double radianDeltaTopPlaneDiagonal;
//   final double lengthTopPlaneDiagonal;
//   final double lengthCenter;
//   final Coordinate center;
//   final Coordinate corner;
//   final Coordinate height;
//
//   const _PlanesComposerTranslationManager({
//     required this.category,
//     required this.pair,
//     required this.radianApparentDeep,
//     required this.radianDeltaTopPlaneDiagonal,
//     required this.lengthTopPlaneDiagonal,
//     required this.lengthCenter,
//     required this.center,
//     required this.corner,
//     required this.height,
//   });
//
//   bool get isTopLeft => pair.key == Alignment.topLeft;
//
//   Coordinate projectionOf(double distance) => Coordinate.fromDirection(
//         CoordinateRadian(0, 0, radianDeltaTopPlaneDiagonal),
//         distance,
//       ).scaleCoordinate(Coordinate(1, math.cos(radianApparentDeep), 1));
//
//   Coordinate get value {
//     switch (category) {
//       // align
//       case PlanesComposerTranslation.aAlignB:
//         return isTopLeft ? corner : Coordinate.zero;
//       case PlanesComposerTranslation.bAlignA:
//         return isTopLeft ? Coordinate.zero : corner;
//
//       // enclose
//       case PlanesComposerTranslation.bEncloseA:
//         return isTopLeft
//             ? Coordinate.zero
//             : corner + projectionOf(lengthTopPlaneDiagonal);
//
//       case PlanesComposerTranslation.aEncloseB:
//         return isTopLeft
//             ? corner + projectionOf(lengthTopPlaneDiagonal)
//             : Coordinate.zero;
//
//       // center
//       case PlanesComposerTranslation.center:
//         return center;
//
//       case PlanesComposerTranslation.centerTouch:
//         return center + projectionOf(lengthTopPlaneDiagonal) / 2;
//
//       // stagger
//       case PlanesComposerTranslation.centerStagger:
//         return center + projectionOf(lengthTopPlaneDiagonal);
//
//       // enclose
//       case PlanesComposerTranslation.centerEncloseDistanceFar:
//         return center + projectionOf(lengthCenter);
//
//       case PlanesComposerTranslation.centerEncloseDistance:
//         return center + projectionOf(lengthCenter) * 2;
//
//       case PlanesComposerTranslation.centerEnclose:
//         return center + (projectionOf(lengthTopPlaneDiagonal) + height) / 2;
//     }
//   }
// }
//
// /// planes composer command executor
// class _PlanesComposerCommandExecutor {
//   final OnAnimateMatrix4 type;
//   final bool shouldAnimate;
//   final bool haveAnimate;
//
//   const _PlanesComposerCommandExecutor._({
//     required this.type,
//     required this.shouldAnimate,
//     required this.haveAnimate,
//   });
//
//   static List<List<_PlanesComposerCommandExecutor>> fromSteps({
//     required List<OnAnimateMatrix4> categories,
//     required List<Set<OnAnimateMatrix4>> step,
//     required List<Set<OnAnimateMatrix4>> stepped,
//   }) =>
//       step.foldWith(
//         stepped,
//         [],
//         (result, shouldStep, haveStepped) => result
//           ..add(categories
//               .map(
//                 (category) => _PlanesComposerCommandExecutor._(
//                   type: category,
//                   shouldAnimate: shouldStep.contains(category),
//                   haveAnimate: haveStepped.contains(category),
//                 ),
//               )
//               .toList(growable: false)),
//       );
// }
//
// extension _PlanesComposerExecutorListExtension
//     on List<_PlanesComposerCommandExecutor> {
//   _PlanesComposerCommandExecutor get firstTranslate => firstWhere(
//         (element) => element.type == MamionTransformDelegate.onTranslating,
//       );
//
//   _PlanesComposerCommandExecutor get firstRotate => firstWhere(
//         (element) => element.type == MamionTransformDelegate.onRotating,
//       );
//
// // _PlanesComposerCommandExecutor get scale => firstWhere(
// //       (element) => element.category == MamionTransformBase.scale,
// //     );
// }
