package gcx;

import thx.geom.d3.Point;
import gcx.AddressType;
import gcx.Mode;

class Pointer {
  var d : GCodeDriver;
  var mode : Mode;
  var position : Point;
  var feedRate : Float;
  var travelRate : Float;
  public function new(driver : GCodeDriver) {
    this.d = driver;
    mode = Travel;
    position = Point.create(0,0,0);
  }

  public function x(v : Float)
    return abs(v, null, null);

  public function rx(v : Float)
    return rel(v, null, null);

  public function y(v : Float)
    return abs(null, v, null);

  public function ry(v : Float)
    return rel(null, v, null);

  public function z(v : Float)
    return abs(null, null, v);

  public function rz(v : Float)
    return rel(null, null, v);

  public function rel(?x : Float, ?y : Float, ?z : Float)
    return abs(
        null == x ? null : x + position.x,
        null == y ? null : y + position.y,
        null == z ? null : z + position.z
      );

  public function abs(?x : Float, ?y : Float, ?z : Float) {
    var l = [];
    if(null != x && x != position.x) {
      l.push(X(x));
      position.x = x;
    }
    if(null != y && y != position.y) {
      l.push(Y(y));
      position.y = y;
    }
    if(null != z && z != position.z) {
      l.push(Z(z));
      position.z = z;
    }
    if(l.length == 0) return this;
    switch mode {
      case Travel: d.position(l);
      case Mill: d.linear(l);
    }
    return this;
  }

  public function rcircle(rcx : Float, rcy : Float)
    return rarc(rcx, rcy, 0, 0);

  public function circle(cx : Float, cy : Float)
    return arc(cx, cy, position.x, position.y);

  public function rcircleCCW(rcx : Float, rcy : Float)
    return rarcCCW(rcx, rcy, 0, 0);

  public function circleCCW(cx : Float, cy : Float)
    return arcCCW(cx, cy, position.x, position.y);
/*
var r = cx - position.x;
arc(cx, cy, cx, cy + r);
arc(cx, cy, cx + r, cy);
arc(cx, cy, cx, cy - r);
arc(cx, cy, cx - r, cy);
 */

  public function rarc(rcx : Float, rcy : Float, rex : Float, rey : Float)
    return arc(position.x + rcx, position.y + rcy, position.x + rex, position.y + rey);

  public function arc(cx : Float, cy : Float, ex : Float, ey : Float) {
    if(ex == cx && ey == cy) { // full circle
      var dx = cx - position.x,
          dy = cy - position.y;
      arc(cx, cy, position.x + dx, position.y + dy);
      arc(cx, cy, ex, ey);
    } else {
      d.arc([X(ex), Y(ey), I(cx - position.x), J(cy - position.y)]);
      position.x = ex;
      position.y = ey;
    }
    return this;
  }

  public function rarcCCW(rcx : Float, rcy : Float, rex : Float, rey : Float)
    return arcCCW(position.x + rcx, position.y + rcy, position.x + rex, position.y + rey);

  public function arcCCW(cx : Float, cy : Float, ex : Float, ey : Float) {
    if(ex == cx && ey == cy) { // full circle
      var dx = cx - position.x,
          dy = cy - position.y;
      arcCCW(cx, cy, position.x + dx, position.y + dy);
      arcCCW(cx, cy, ex, ey);
    } else {
      d.arcCCW([X(ex), Y(ey), I(cx - position.x), J(cy - position.y)]);
      position.x = ex;
      position.y = ey;
    }
    return this;
  }

  public function hole(toolDiameter : Float, holeDiameter : Float, ?repeats = 1, ?overlap = 0.1) {
    var toolRadius = toolDiameter / 2,
        holeRadius = holeDiameter / 2,
        step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeRadius - toolRadius;

    var counter = 0;
    function circle(cx, cy) {
      if(counter ++ % 2 == 0)
        this.circle(cx, cy);
      else
        this.circleCCW(cx, cy);
    }

    if(rad <= 0)
      return this;
    var lr = [];
    while(dist < rad) {
      lr.push(dist);
      dist += step;
    };

    var center = position.clone();
    var p = 0.0;
    mill();
    for(r in lr) {
      rx(-r + p);
      circle(center.x, center.y);
      p = r;
    }
    rx(-rad + p);
    if(repeats < 1)
      repeats = 1;
    for(_ in 0...repeats) {
      circle(center.x, center.y);
    }
    travel();
    abs(center.x, center.y);
    mill();
    return this;
  }

  public function yHole(toolDiameter : Float, holeDiameter : Float, length : Float, ?overlap = 0.1) {
    var toolRadius = toolDiameter / 2,
        holeRadius = holeDiameter / 2,
        step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeRadius - toolRadius;
    ry(length);
    travel();
    ry(-length);
    mill();
    if(rad <= 0)
      return this;
    var lr = [];
    while(dist < rad) {
      lr.push(dist);
      dist += step;
    };
    lr.push(rad);

    var center = position.clone();
    var p = 0.0;
    mill();
    for(r in lr) {
      rx(-r + p);
      ry(length);
      rarc(r, 0, r * 2, 0);
      ry(-length);
      rarc(-r, 0, -r * 2, 0);

      p = r;
    }
    travel();
    abs(center.x, center.y);
    mill();
    return this;
  }

  public function travel(?travelRate : Float) {
    if(null != travelRate && travelRate != this.travelRate)
      d.position([F(this.travelRate = travelRate)]);
    mode = Travel;
    return this;
  }

  public function mill(?feedRate : Float) {
    if(null != feedRate && feedRate != this.feedRate)
      d.linear([F(this.feedRate = feedRate)]);
    mode = Mill;
    return this;
  }
}

enum Mode {
  Travel;
  Mill;
}
