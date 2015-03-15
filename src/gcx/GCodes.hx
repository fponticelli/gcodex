package gcx;

import gcx.AddressType;

class GCodes {
  public static function hole(d : GCodeDriver, toolDiameter : Float, holeDiameter : Float, ?overlap = 0.1) {
    var step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeDiameter / 2 - toolDiameter;
    while(dist < rad) {
      d.linear([X(-step)]);
      d.arc([dist, 0], [0, 0]);
      dist += step;
    }
    d.linear([X(-rad)]);
    d.arc([rad, 0], [0, 0]);
  }
}