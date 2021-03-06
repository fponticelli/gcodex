package gcx;

import thx.geom.d2.Point;
import gcx.AddressType;
import thx.geom.Matrix23;
import gcx.Mode;

class Pointer {
  var mode : Mode;
  var d : GCodeDriver;
  var position : Point;
  var feedRate : Float;
  var travelRate : Float;
  public var matrix : Matrix23;
  public function new(driver : GCodeDriver) {
    this.d = driver;
    mode = Travel;
    position = Point.create(0,0);
    matrix = Matrix23.identity;
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
        null == y ? null : y + position.y
      );

  public function abs(?x : Float, ?y : Float, ?z : Float) {
    var np = Point.create(
        null == x ? position.x : x,
        null == y ? position.y : y
      );

    var p = np.transform(matrix),
        l = [X(p.x), Y(p.y), Z(z)];

    position.set(np.x, np.y);

    if(l.length == 0)
      return this;

    switch mode {
      case Travel: d.position(l);
      case Mill: d.linear(l);
    }

    return this;
  }

  public function rcircle(rcx : Float, rcy : Float)
    return circle(position.x + rcx, position.y + rcy);

  public function circle(cx : Float, cy : Float) {
    var r = cx - position.x;
    arc(cx, cy, cx, cy + r);
    arc(cx, cy, cx + r, cy);
    arc(cx, cy, cx, cy - r);
    arc(cx, cy, cx - r, cy);
    return this;
  }

  public function rcircleCCW(rcx : Float, rcy : Float)
  return circleCCW(position.x + rcx, position.y + rcy);

  public function circleCCW(cx : Float, cy : Float) {
    var r = cx - position.x;
    arcCCW(cx, cy, cx - r, cy);
    arcCCW(cx, cy, cx, cy - r);
    arcCCW(cx, cy, cx + r, cy);
    arcCCW(cx, cy, cx, cy + r);
    return this;
  }

  public function rarc(rcx : Float, rcy : Float, rex : Float, rey : Float)
    return arc(position.x + rcx, position.y + rcy, position.x + rex, position.y + rey);

  public function arc(cx : Float, cy : Float, ex : Float, ey : Float) {
    var cp = Point.create(cx, cy).transform(matrix),
        sp = position.transform(matrix);
    position.x = ex;
    position.y = ey;
    var ep = position.transform(matrix);
    d.arc([X(ep.x), Y(ep.y), I(cp.x - sp.x), J(cp.y - sp.y)]);
    return this;
  }

  public function rarcCCW(rcx : Float, rcy : Float, rex : Float, rey : Float)
    return arcCCW(position.x + rcx, position.y + rcy, position.x + rex, position.y + rey);

  public function arcCCW(cx : Float, cy : Float, ex : Float, ey : Float) {
    var cp = Point.create(cx, cy).transform(matrix),
        sp = position.transform(matrix);
    position.x = ex;
    position.y = ey;
    var ep = position.transform(matrix);
    d.arcCCW([X(ep.x), Y(ep.y), I(cp.x - sp.x), J(cp.y - sp.y)]);
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

  public function screwHole(toolDiam : Float, headDiam : Float, headDepth : Float, boreDiam : Float, boreDepth : Float, cutDepth : Float = 1, overlay : Float = 0.2, passes : Int = 2, ?overlap : Float) {
    headDepth = Math.abs(headDepth);
    boreDepth = Math.abs(boreDepth);
    cutDepth  = Math.abs(cutDepth);
    if(cutDepth == 0)
      throw 'cutDepth is 0';

    var sections = [],
        cut = headDepth;
    while(cut > 0) {
      sections.push({ depth : -Math.min(cutDepth, cut), diam : headDiam });
      cut -= cutDepth;
    }
    cut = boreDepth + overlay - headDepth;
    while(cut > 0) {
      sections.push({ depth : -Math.min(cutDepth, cut), diam : boreDiam });
      cut -= cutDepth;
    }
    for(s in sections) {
      rz(s.depth);
      hole(toolDiam, s.diam, passes, overlap);
    }
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
