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
    var lr = [];
    while(dist < rad) {
      lr.push(dist);
      dist += step;
    };
    lr.push(rad);

    var p = 0.0;
    for(r in lr) {
      d.linear([RX(-(r - p))]);
      d.arc([RX(0), RY(0), I(r), J(0)]);
      p = r;
    }

    d.position([RX(rad)]);
  }

  public static function yHole(d : GCodeDriver, toolDiameter : Float, holeDiameter : Float, length : Float, ?overlap = 0.1) {
    var toolRadius = toolDiameter / 2,
        holeRadius = holeDiameter / 2,
        step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeRadius - toolRadius;
    if(rad <= toolRadius)
      return;
    var lr = [];
    while(dist < rad) {
      lr.push(dist);
      dist += step;
    };
    lr.push(rad);

    var p = 0.0;
    for(r in lr) {
      d.linear([RX(-(r - p))]);
      d.linear([RY(length)]);
      d.arc([RX(2*r), RY(0), I(r), J(0)]);
      d.linear([RY(-length)]);
      d.arc([RX(-2*r), RY(0), I(-r), J(0)]);
      p = r;
    }

    d.position([X(rad)]);
  }
}