package gcx;

abstract Address(AddressType) from AddressType to AddressType {
  @:to public function toString() : String
    return switch this {
      case X(v): 'X$v';
      case Y(v): 'Y$v';
      case Z(v): 'Z$v';
      case I(v): 'I$v';
      case J(v): 'J$v';
      case K(v): 'K$v';
      case P(v): 'P$v';
    };
}