import gcx.GCodeDriver;
import gcx.Pointer;
using thx.core.Floats;

class Main {
  static function main() {
    build("clamp", Clamp.build);
    build("plate", Plate.build);
    build("cart-plate", CartPlate.build);
    build("top-plate", TopPlate.build);
  }

  static function build(name : String, callback : Pointer -> Void) {
    var d = new GCodeDriver(),
        p = new Pointer(d);
    callback(p);
    js.node.Fs.writeFileSync('gcode/$name.nc', d.toString());
    trace(name + "\n\n" + d.toString());
  }
}
