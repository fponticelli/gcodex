import gcx.GCodeDriver;
import gcx.Pointer;
using thx.core.Floats;

class Main {
  static function main() {
    build("clamp", Clamp.build);
    build("plate", Plate.build);
    build("cart-plate", CartPlate.build);
    build("top-plate", TopPlate.build);
    build("transform", Transform.build);
    build("projector-plate", ProjectorPlate.build);
    build("bottom-plate", BottomPlate.build);
    build("l-plate", LPlate.build);
    build("t-plate", TPlate.build);
  }

  static function build(name : String, callback : Pointer -> Void) {
    var d = new GCodeDriver(),
        p = new Pointer(d);
    callback(p);
    js.node.Fs.writeFileSync('gcode/$name.ngc', d.toString());
    trace(name + "\n\n" + d.toString());
  }
}
