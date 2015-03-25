import gcx.Pointer;
using thx.core.Floats;

class TopPlateRotated {
  public static function build(po : Pointer) {
    po.matrix = thx.geom.Matrix44.rotationZ(Math.PI / 2);
    TopPlate.build(po);
  }
}
