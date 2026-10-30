// Parametrisk dubbel rörhållare (bas utan lock) + distansklossar
// Inspirerad av Clas Ohlson 30-9789 (rör 10-16 mm, c/c 40 mm, längd 60 mm)
// part = "holder" | "spacer"
part = "holder";

/* [Rör] */
pipe_d1 = 18;        // rördiameter 1 (mm) Cu EN 1057: 10/12/15/18/22/28, Al-PEX 16/20/25
pipe_d2 = 18;        // rördiameter 2 (mm)
cc = 40;             // centrumavstånd mellan rören
gap = 20;            // vägg -> rörets yta (närmaste periferi), utan klossar
clearance = 0.3;     // spel radiellt
snap_ratio = 0.87;   // öppning / rördiameter
clip_wall = 2.6;     // godstjocklek C-clips (PETG)
/* [Kropp] */
width = 14;          // bredd längs röret (tryckhöjd)
base_t = 4;          // bakplattans tjocklek
base_len = 60;       // bakplattans längd (min = cc + ringar)
/* [Skruv] */
screw_d = 4.2;       // skruvhål
screw_head_d = 8.5;  // försänkning diameter
/* [Klossar] */
spacer_t = 5;        // klosstjocklek (2.5 / 5, stapelbara)
spacer_len = 60;     // klossens längd, oberoende av rördim
peg_x = 24;          // tappavstånd från mitt, fast => en kloss passar alla
peg_d = 4; peg_h = 2; peg_tol = 0.25; pegs = true;
$fn = 96;

d1 = pipe_d1; d2 = pipe_d2;
ro = function(d) d/2 + clearance + clip_wall;
L = max(base_len, 2*peg_x+10, cc + 2*max(ro(d1), ro(d2)) );

module c_ring2d(d) {
  wall_offset = gap + d/2;
  ri = d/2 + clearance; r_o = ri + clip_wall; op = snap_ratio*d;
  difference() {
    union() {
      circle(r_o);
      translate([-r_o*0.7, -(wall_offset)]) square([r_o*1.4, wall_offset]); // fot
    }
    circle(ri);
    translate([-op/2, 0]) square([op, r_o+1]);
  }
  // avfasade inloppsläppar
  for (s=[-1,1]) translate([s*(op/2+ (r_o-op/2)/2), sqrt(max(0,ri*ri-(op/2)*(op/2)))]) circle((r_o-ri)/2*0+clip_wall/2);
}

module holder2d() {
  difference() {
    union() {
      translate([-L/2, 0]) square([L, base_t]);
      translate([-cc/2, gap+d1/2]) c_ring2d(d1);
      translate([ cc/2, gap+d2/2]) c_ring2d(d2);
    }
    translate([-cc/2, gap+d1/2]) circle(d1/2+clearance);
    translate([ cc/2, gap+d2/2]) circle(d2/2+clearance);
    translate([-L, -50]) square([2*L, 50]); // platt mot vägg
  }
}

// teardrop-hål längs Y (horisontellt vid utskrift)
module tear(d, h) { rotate([-90,0,0]) linear_extrude(h) union(){ circle(d/2); rotate(45) square(d/2); } }

module holder() {
  difference() {
    linear_extrude(width) holder2d();
    // skruvhål + försänkning (mitt)
    translate([0,-1,width/2]) tear(screw_d, base_t+2);
    translate([0,base_t,width/2]) rotate([90,0,0]) cylinder(d1=screw_head_d, d2=screw_d, h=(screw_head_d-screw_d)/2+0.01);
    translate([0,base_t-0.01,width/2]) rotate([-90,0,0]) cylinder(d=screw_head_d, h=gap+max(d1,d2));
    if (pegs) for (s=[-1,1]) translate([s*peg_x,-0.01,width/2]) tear(peg_d+2*peg_tol, peg_h+0.5);
  }
}

// kloss: ligger platt (Z=tjocklek), väggsida nedåt; tapp uppåt in i hållare/nästa kloss
module spacer() {
  difference() {
    union() {
      translate([-spacer_len/2,-width/2,0]) cube([spacer_len, width, spacer_t]);
      if (pegs && spacer_t >= peg_h+1.5) for (s=[-1,1]) translate([s*peg_x,0,spacer_t]) cylinder(d=peg_d, h=peg_h);
    }
    translate([0,0,-1]) cylinder(d=screw_d, h=spacer_t+2);
    if (pegs) for (s=[-1,1]) translate([s*peg_x,0,-0.01]) cylinder(d=peg_d+2*peg_tol, h= spacer_t >= peg_h+1.5 ? peg_h+0.5 : spacer_t+1); // tunn kloss: genomgående hål, tappen nedifrån går igenom
  }
}

// Utskriftsorientering: profilen ligger platt på bädden (extruderad i Z)
if (part=="holder") holder(); else spacer();
