package gcx;

abstract Address(AddressType) from AddressType to AddressType {
  @:to public function toString() : String
    return switch this {
      case X(v): 'X$v';
      case Y(v): 'Y$v';
      case Z(v): 'Z$v';
    };
}

enum AddressType {
  X(v : Float);
  Y(v : Float);
  Z(v : Float);
}