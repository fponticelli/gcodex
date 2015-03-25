import gcx.Pointer;
using thx.core.Floats;
using thx.geom.Matrix44;

class TopPlateRotated {
  public static function build(po : Pointer) {
    po.matrix = Matrix44
    .rotationZ(Math.PI / 2)
      .multiply(Matrix44.translation(TopPlate.emD / 2 + TopPlate.h1, TopPlate.emD / 2, 0));
    TopPlate.build(po);
  }
}
