package gcx;

import gcx.AddressType;

class GCodes {
  public static function hole(d : GCodeDriver, toolDiameter : Float, holeDiameter : Float, ?overlap = 0.1) {

    var toolRadius = toolDiameter / 2,
        holeRadius = holeDiameter / 2,
        step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeRadius - toolRadius;
    if(rad <= toolRadius)
      return;
    while(dist < rad) {
      d.linear([X(-step)]);
      d.arc([dist, 0], [0, 0]);
      dist += step;
    }
    d.linear([X(rad - (dist - step))]);
    d.arc([rad, 0], [0, 0]);
  }
}