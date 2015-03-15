package gcx;

using thx.core.Floats;

abstract Address(AddressType) from AddressType to AddressType {
  @:to public function toString() : String
    return switch this {
      case X(v): 'X${r(v)}';
      case Y(v): 'Y${r(v)}';
      case Z(v): 'Z${r(v)}';
      case RX(v), U(v): 'U${r(v)}';
      case RY(v), V(v): 'V${r(v)}';
      case RZ(v), W(v): 'W${r(v)}';
      case I(v): 'I${r(v)}';
      case J(v): 'J${r(v)}';
      case K(v): 'K${r(v)}';
      case P(v): 'P${r(v)}';
    };

  static function r(f : Float) : String {
    return ""+f.roundTo(8);
  }
}