part of '../../_mationani.dart';

// ///
// ///
// /// [PlanesComposition]
// /// [PlanesShelf]
// ///
// ///
// ///
// ///
//
// /// planes composition
// class PlanesComposition extends StatefulWidget {
//   const PlanesComposition({
//     super.key,
//     required this.trigger,
//     required this.composer,
//     // required this.combiner,
//     required this.aniFromUpdater,
//     this.children = WGridPaper.simpleListList,
//   });
//
//   final bool trigger;
//   final AniFromUpdater aniFromUpdater;
//   final PlanesComposer composer;
//
//   ///
//   /// total amount:
//   /// (in1) C4_4 +
//   /// (in2) C4_1 * C3_3 * 2! + C4_2 * C2_2 * 2! / 2! +
//   /// (in3) C4_2 * C2_1 * C1_1 * 3! / 2! +
//   /// (in4) C4_1 * C3_1 * C2_1 * C1_1 * 4! / 4! =
//   /// 1 + 14 + 36 + 24 = 75 #
//   ///
//   // final PlanesComposerCombiner combiner;
//   final List<List<Widget>> children;
//
//   Map<int, List<Set<OnAnimateMatrix4>>> get steps => {
//         1: [PlanesComposerCommand.values[0], PlanesComposerCommand.values[2]],
//         2: [PlanesComposerCommand.values[3]],
//         3: [PlanesComposerCommand.values[1]],
//       }.map(
//         (index, step) => MapEntry(index, [
//           step.where((e) => e.childIndex == 0).map((e) => e.type).toSet(),
//           step.where((e) => e.childIndex == 1).map((e) => e.type).toSet(),
//         ]),
//       );
//
//   @override
//   State<PlanesComposition> createState() => _PlanesCompositionState();
// }
//
// class _PlanesCompositionState extends State<PlanesComposition> {
//   bool _composed = false;
//   bool _isAnimating = false;
//   bool? _stepForwardOrReverse;
//   late int _stepIndex;
//   late int _childrenCount;
//   late int _stepIndexLast;
//   final List<Set<OnAnimateMatrix4>> _step = [];
//   final List<Set<OnAnimateMatrix4>> _stepped = [];
//
//   void _update() {
//     _childrenCount = widget.children.length;
//
//     assert(
//       widget.children.lengths == _childrenCount * widget.composer.planesCount,
//     );
//
//     _step.addAll(List.generate(_childrenCount, (_) => {}));
//     _stepped.addAll(List.generate(_childrenCount, (_) => {}));
//   }
//
//   @override
//   void initState() {
//     _update();
//     updateIndex(from: 1, to: maxStepIndex);
//     super.initState();
//   }
//
//   void updateIndex({required int from, required int to}) {
//     _stepIndex = from;
//     _stepIndexLast = to;
//     _stepForwardOrReverse = widget.trigger;
//     _findStep();
//   }
//
//   int get maxStepIndex => widget.steps.length * _childrenCount;
//
//   @override
//   void didUpdateWidget(covariant PlanesComposition oldWidget) {
//     if (!_isAnimating && oldWidget.trigger != widget.trigger) {
//       _step.clear();
//       _stepped.clear();
//       _update();
//
//       updateIndex(
//         from: _composed ? maxStepIndex : 1,
//         to: _composed ? 1 : maxStepIndex,
//       );
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   /// find forward step or reverse step
//   void _findStep({bool isFinish = false, bool shouldSetState = false}) =>
//       isFinish
//           ? _composed = !_composed
//           : () {
//               _step.forEachAddAll(
//                 widget.steps[(_stepIndex / _childrenCount).ceil()],
//               );
//               shouldSetState ? setState(() {}) : null;
//             }();
//
//   /// stepping controller
//   void _steppingListener(AnimationController controller) {
//     _isAnimating = true;
//     controller.reset();
//     controller.forward().then((_) {
//       _stepped.forEachAddAll(_step);
//       _stepIndex == _stepIndexLast
//           ? _isAnimating = false
//           : () {
//               _stepIndex += _stepForwardOrReverse! ? 1 : -1;
//               _findStep(
//                 isFinish: _stepIndex == _stepIndexLast,
//                 shouldSetState: true,
//               );
//             }();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: widget.composer._planes(
//         animationIsForward: _stepForwardOrReverse,
//         ani: widget.aniFromUpdater(_steppingListener),
//         alignments: [Alignment.topLeft, Alignment.bottomRight],
//         executorsList: _PlanesComposerCommandExecutor.fromSteps(
//           categories: [
//             MamionTransformDelegate.onTranslating,
//             MamionTransformDelegate.onRotating,
//           ],
//           step: _step,
//           stepped: _stepped,
//         ),
//         children: widget.children.map((e) => WWidgetBuilder.ofList(e)).toList(),
//       ),
//     );
//   }
// }
//
// class PlanesShelf extends StatefulWidget {
//   final bool toggle;
//   final Coordinate volume;
//   final double radianApparentDeep;
//   final double radianTarget;
//   final PlanesComposerTranslation targetTranslation;
//   final AniFromUpdater aniFromUpdater;
//
//   // final PlanesComposerCombiner combiner;
//
//   const PlanesShelf({
//     super.key,
//     required this.toggle,
//     this.aniFromUpdater = _aniFromUpdater,
//     this.volume = KCoordinate.cube_100,
//     this.radianApparentDeep = KDoubleExtension.radian_angle50,
//     this.radianTarget = KDoubleExtension.radian_angle30,
//     this.targetTranslation = PlanesComposerTranslation.centerEnclose,
//     // this.combiner = PccCombinations.in3_1AT_2AR_3B,
//     this.columnAlignment = MainAxisAlignment.center,
//     this.rowAlignment = MainAxisAlignment.center,
//   });
//
//   static Ani _aniFromUpdater(Consumer<AnimationController> consumer) =>
//       AniUpdateIfNotAnimating(
//         duration: KDurationFR.milli500,
//         consumer: consumer,
//       );
//
//   /// alignment
//   final MainAxisAlignment columnAlignment;
//   final MainAxisAlignment rowAlignment;
//
//   PlanesComposer get composer => PlanesComposer(
//         volume: volume,
//         radianApparentDeep: radianApparentDeep,
//         radianTarget: radianTarget,
//         targetTranslation: targetTranslation,
//       );
//
//   @override
//   State<PlanesShelf> createState() => _PlanesShelfState();
// }
//
// class _PlanesShelfState extends State<PlanesShelf> {
//   final List<List<bool>> togglesList = [];
//
//   @override
//   void initState() {
//     _update();
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(covariant PlanesShelf oldWidget) {
//     _update();
//     super.didUpdateWidget(oldWidget);
//   }
//
//   ///
//   /// 1. calculate the column, row amount, create [togglesList] in correct amount
//   /// 2, align each item from center
//   /// 2. generate a stream of [togglesList], toggle each one after another, listen to [widget.toggle]'s changes
//   ///
//   void _update() {
//     final toggle = widget.toggle;
//     togglesList.clear();
//     togglesList.addAll(List.generate(
//       3,
//       (_) => List.generate(3, (_) => toggle),
//     ));
//   }
//
//   ClipRRect _clipperRRect(Color color) => WClipping.rRectColored(
//         borderRadius: KBorderRadius.allCircular_8,
//         color: color,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     final appColor = context.preference.appColor;
//
//     return SizedBox(
//       width: 500,
//       height: 500,
//       child: Column(
//         mainAxisAlignment: widget.columnAlignment,
//         children: togglesList
//             .map(
//               (toggles) => Row(
//                 mainAxisAlignment: widget.rowAlignment,
//                 children: toggles
//                     .map(
//                       (toggle) => PlanesComposition(
//                         trigger: toggle,
//                         composer: widget.composer,
//                         // combiner: widget.combiner,
//                         aniFromUpdater: widget.aniFromUpdater,
//                         children: [
//                           [
//                             _clipperRRect(appColor.colorB1),
//                             _clipperRRect(appColor.colorB2.withOpacity(0.6)),
//                             _clipperRRect(appColor.colorB3.withOpacity(0.6)),
//                           ],
//                           [
//                             _clipperRRect(appColor.colorB3),
//                             _clipperRRect(appColor.colorB2.withOpacity(0.5)),
//                             _clipperRRect(appColor.colorB3.withOpacity(0.5)),
//                           ],
//                         ],
//                       ),
//                     )
//                     .toList(growable: false),
//               ),
//             )
//             .toList(growable: false),
//       ),
//     );
//   }
// }
