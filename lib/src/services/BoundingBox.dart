class BoundingBox {
  final double x1, y1, x2, y2;
  final double cx, cy, w, h;
  final double confidence;
  final int classIndex;
  final String className;

  BoundingBox({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.cx,
    required this.cy,
    required this.w,
    required this.h,
    required this.confidence,
    required this.classIndex,
    required this.className,
  });
}
