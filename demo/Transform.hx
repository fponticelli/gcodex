import gcx.Pointer;
using thx.Floats;

class Transform {
  public static function build(po : Pointer) {
    //po.matrix = thx.geom.Matrix23.rotationZ(Math.PI / 4);
		po.abs(0, 0, 0)
			.mill(100)
			.x(20)
			.ry(20)
			.rx(-20)
			.y(0);

    po.abs(0, 0, 0)
			.mill(100)
			.x(20)
			.rarcCCW(0, 10, 0, 20)
			.rel(-20, -10)
			.arc(0, 5, 0, 0);
  }
}
