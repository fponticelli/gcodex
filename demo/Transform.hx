import gcx.Pointer;
using thx.core.Floats;

class Transform {
  public static function build(po : Pointer) {
    po.matrix = thx.geom.Matrix44.rotationZ(Math.PI / 2);
    po.abs(0, 0, 0)
			.mill(100)
			.x(20)
			.rarcCCW(0, 10, 0, 20)
			.rel(-20, -10)
			.arc(0, 5, 0, 0);
  }
}
