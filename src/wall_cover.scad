// Parametrisk täckplatta (rosett) för väggenomföring av dubbla radiatorrör
// Två IDENTISKA halvor (skriv ut 2 st), delning genom rörens centrum.
// Fog: genomgående laxstjärt (dovetail) i skarven, skjuts ihop längs rören.
// Inget som böjs -> PETG-säkert. Halvorna skrivs ut platt (framsida upp) utan support.
// part = "half" | "assembled" | "exploded" | "print"
part = "half";

/* [Rör] */
pipe_preset = 18;      // 15 | 18 | 22 (Cu EN 1057)
pipe_d_custom = 0;     // >0 åsidosätter preset
pipe_clearance = 0.8;  // spel på diametern (0.5-1)
cc = 40;               // centrumavstånd (samma som rörhållaren)
/* [Platta] */
width_preset = 40;     // 40 | 50 | 60 (bredd tvärs rören)
width_custom = 0;      // >0 åsidosätter preset
height_custom = 0;     // >0 åsidosätter standard (cc + bredd)
thick_preset = 3;      // 3 | 5
thick_custom = 0;      // >0 åsidosätter preset
edge_chamfer_custom = -1; // >=0 åsidosätter; annars 1 mm vid <=3 mm, 1.5 mm vid 5 mm
corner_chamfer_custom = -1; // >=0 åsidosätter; annars 3 med skruvhål, 6 utan (tejp oförändrad). liten så den inte krockar med skruvhålen
waist_notch = 3;       // V-midja mellan rören per sida, 0 = rak
/* [Fog: laxstjärt] */
dt_neck = 3;           // halsbredd i skarven
dt_head = 5.5;         // huvudets bredd
dt_depth = 3;          // hur långt in i motsatt halva
dt_tol = 0.15;         // spel per sida (lätt presspassning)
dt_mid_custom = 0;     // >0 åsidosätter; annars (cc-hål)/4, ryms även för 22 mm
/* [Skruvhål (standard: dubbelhäftande tejp, platt baksida)] */
screw_holes = false;
screw_size = "ws3.0";  // träskruv, försänkt huvud: "ws3.0" | "ws3.5" | "ws4.0" (även "M2.5", "M3.5")
// Huvud-Ø enligt DIN 7997 dk nom: 3.0->5.6, 3.5->6.5, 4.0->7.5 (fasten.it/en/norms/norm/din_7997);
// fickan görs ~0.4-0.5 större så huvudet går i plan även för spånskivsskruv (~6/7/8).
screw_hole_d_custom = 0; // >0 åsidosätter
screw_head_d_custom = 0; // >0 åsidosätter (90° försänkning)
min_floor = 1.2;
screw_inset_custom = 0; // >0 åsidosätter; annars max(4.5, minsta som ger 1.2 mm kantmarginal i ovanytan)
min_margin = 1.2;       // minsta raka hålparti under försänkningen
explode = 12;
$fn = 128;

corner_chamfer = corner_chamfer_custom >= 0 ? corner_chamfer_custom : (screw_holes ? 2 : 6);
thick = thick_custom > 0 ? thick_custom : thick_preset;
edge_chamfer = edge_chamfer_custom >= 0 ? edge_chamfer_custom : (thick <= 3 ? 1 : 1.5);
pipe_d = pipe_d_custom > 0 ? pipe_d_custom : pipe_preset;
hole_d = pipe_d + pipe_clearance;
W = width_custom > 0 ? width_custom : width_preset;
H = height_custom > 0 ? height_custom : cc + W;
dt_mid = dt_mid_custom > 0 ? dt_mid_custom : (cc - hole_d)/4;
ends = cc/2 + hole_d/2;                 // rörhålets kant
dt_end = (ends + H/2) / 2;              // mitt i ändpartiet
assert(H/2 - ends >= dt_head + 2, "För kort ändparti för fogen – öka höjden");
assert(2*dt_mid >= dt_head + 2*dt_tol + 1 && dt_mid + dt_head/2 + dt_tol <= (cc-hole_d)/2 - 1, "För litet avstånd mellan rören för fogen");
assert(W/2 - dt_depth >= 4, "För smal platta för fogen");

// [namn, hål, försänkning]
SCREWS = [["ws3.0",3.3,6.0],["ws3.5",3.8,7.0],["ws4.0",4.3,8.0],["M2.5",2.7,5],["M3.5",3.8,7]];
scr = SCREWS[search([screw_size], SCREWS)[0]];
screw_hole_d = screw_hole_d_custom > 0 ? screw_hole_d_custom : scr[1];
screw_head_d = screw_head_d_custom > 0 ? screw_head_d_custom : scr[2];
cs_depth = min((screw_head_d - screw_hole_d)/2, thick - min_floor);
cs_top_d = screw_hole_d + 2*cs_depth;   // faktisk försänkningsdiameter i ytan
if (screw_holes) echo(str("COUNTERSINK depth=",cs_depth," floor_left=",thick-cs_depth, cs_top_d < screw_head_d ? str("  VARNING: försänkningen begränsad till Ø",cs_top_d," (min_floor) – huvudet sticker upp") : ""));
screw_inset = screw_inset_custom > 0 ? screw_inset_custom : max(4.5, ceil((cs_top_d/2 + edge_chamfer + min_margin)*10)/10);
screw_pos = [[-W/2+screw_inset, H/2-screw_inset], [-W/2+screw_inset, -H/2+screw_inset]];
// marginaler från försänkningens kant (i ovanytan, efter kantfas)
m_edge = screw_inset - cs_top_d/2 - edge_chamfer;
m_chamf = (2*screw_inset - corner_chamfer)/sqrt(2) - cs_top_d/2 - edge_chamfer;
m_pipe = norm([screw_inset - W/2, H/2-screw_inset - cc/2]) - hole_d/2 - cs_top_d/2;
m_dt = (W/2 - screw_inset - cs_top_d/2) - (dt_depth + dt_tol);
echo(str("SCREW ",screw_size," hole=",screw_hole_d," cs=",cs_top_d," inset=",screw_inset," corner_chamfer=",corner_chamfer));
echo(str("MARGINS edge=",m_edge," chamfer=",m_chamf," pipe=",m_pipe," dovetail=",m_dt, " cs_top_d=",cs_top_d));
if (screw_holes) assert(min(m_edge, m_chamf, m_pipe, m_dt) >= min_margin, "För lite material runt försänkningen");
module screw_cut() {
  translate([0,0,-1]) cylinder(d=screw_hole_d, h=thick+2, $fn=48);
  translate([0,0,thick-cs_depth]) cylinder(d1=screw_hole_d, d2=cs_top_d, h=cs_depth+0.001, $fn=48);
  translate([0,0,thick]) cylinder(d=cs_top_d, h=1, $fn=48);
}
module outline() {
  c = corner_chamfer; n = waist_notch;
  polygon([[-W/2+c,-H/2],[W/2-c,-H/2],[W/2,-H/2+c],[W/2,-n],[W/2-n,0],[W/2,n],[W/2,H/2-c],
           [W/2-c,H/2],[-W/2+c,H/2],[-W/2,H/2-c],[-W/2,n],[-W/2+n,0],[-W/2,-n],[-W/2,-H/2+c]]);
}
module plate() {
  ch = edge_chamfer;
  minkowski() {
    linear_extrude(thick - ch) offset(delta=-ch) outline();
    cylinder(h=ch, r1=ch, r2=0, $fn=4*8);
  }
}
// laxstjärtsprofil, x=0 i skarven, pekar mot +x, s=extra per sida
module dt2d(s) {
  polygon([[-0.01, -dt_neck/2 - s], [dt_depth + s, -dt_head/2 - s],
           [dt_depth + s, dt_head/2 + s], [-0.01, dt_neck/2 + s]]);
}
module dt3d(s) translate([0,0,-1]) linear_extrude(thick + 2) dt2d(s);
// Halva på -x-sidan; tappar vid +y pekar in i +x, spår vid -y.
module half() {
  difference() {
    union() {
      intersection() { plate(); translate([-W, -H, -1]) cube([W, 2*H, thick + 2]); }
      intersection() {
        for (y = [dt_mid, dt_end]) translate([0, y, 0]) linear_extrude(thick) dt2d(0);
        plate();
      }
    }
    for (y = [cc/2, -cc/2]) translate([0, y, -1]) cylinder(d=hole_d, h=thick + 2);
    if (screw_holes) for (p = screw_pos) translate([p[0], p[1], 0]) screw_cut();
    for (y = [-dt_mid, -dt_end]) translate([0, y, 0]) mirror([1,0,0]) dt3d(dt_tol);
  }
}
module other() rotate([0,0,180]) half();
if (part == "half") half();
else if (part == "assembled") { color("white") half(); color("lightgrey") other(); }
else if (part == "exploded") { color("white") half(); color("orange") translate([0,0,explode*2]) other(); }
else if (part == "print") { translate([-dt_depth-3,0,0]) half(); translate([dt_depth+3,0,0]) other(); }
