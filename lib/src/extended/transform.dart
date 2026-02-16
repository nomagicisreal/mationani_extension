part of '../../mationani_extension.dart';

///
///
/// * [OnAnimateMatrix4]
/// * [Matrix4Extension]
///
///

typedef OnAnimateMatrix4 = Matrix4 Function(Matrix4 matrix4, Point3 p);

///
/// static methods, constants:
/// [applier_translating], ...
/// [fixed_translating], ...
/// [formFromDirection]
///
/// instance methods, getters:
/// [setPerspective], ...
/// [getPerspective], ...
/// [perspectiveIdentity], ...
///
extension Matrix4Extension on Matrix4 {
  ///
  ///
  ///
  static OnAnimateMatrix4 applier_translating(Applier<Point3> apply) =>
      (matrix4, value) => matrix4
        ..perspectiveIdentity
        ..translateOf(apply(value));

  static OnAnimateMatrix4 applier_rotating(Applier<Point3> apply) =>
      (matrix4, value) => matrix4
        ..setRotation(
          (Matrix4.identity()..rotateOf(apply(value))).getRotation(),
        );

  static OnAnimateMatrix4 applier_scaling(Applier<Point3> apply) =>
      (matrix4, value) => matrix4.scaledOf(apply(value));

  // with fixed value
  static OnAnimateMatrix4 fixed_translating(Point3 fixed) =>
      (matrix4, value) => matrix4
        ..perspectiveIdentity
        ..translateOf(value + fixed);

  static OnAnimateMatrix4 fixed_rotating(Point3 fixed) =>
      (matrix4, value) => matrix4
        ..setRotation(
          (Matrix4.identity()..rotateOf(fixed + value)).getRotation(),
        );

  static OnAnimateMatrix4 fixed_scaling(Point3 fixed) =>
      (matrix4, value) => matrix4.scaledOf(value + fixed);

  ///
  /// instance methods
  ///
  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  void copyPerspective(Matrix4 matrix4) =>
      setPerspective(matrix4.getPerspective());

  Matrix4 get perspectiveIdentity => Matrix4.identity()..copyPerspective(this);

  void translateOf(Point3 point3) =>
      translateByDouble(point3.x, point3.y, point3.z, 0);

  void translateFor(Offset offset) =>
      translateByDouble(offset.dx, offset.dy, 0, 0);

  void rotateOf(Point3 point3) => this
    ..rotateX(point3.x)
    ..rotateY(point3.y)
    ..rotateZ(point3.z);

  void rotateOn(Point3 point3, double radian) =>
      rotate(v64.Vector3(point3.x, point3.y, point3.z), radian);

  double getPerspective() => entry(3, 2);

  Matrix4 scaledOf(Point3 point3) =>
      scaledByDouble(point3.x, point3.y, point3.z, 1);

  Matrix4 scaledFor(Offset offset) =>
      scaledByDouble(offset.dx, offset.dy, 1, 1);
}
