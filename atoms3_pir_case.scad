// =====================================================================
//  M5Stack AtomS3 + PIR Motion Sensor Unit (AS312) weather-resistant case
// ---------------------------------------------------------------------
//  Materials / hardware
//    - PETG : base, lid
//    - TPU  : perimeter gasket, AtomS3 collar, PIR dome gasket
//    - 4x M3 heat-set inserts (short type, e.g. M3 x 5.7, OD ~4.6)
//    - 4x M3 x 8 button/pan head screws
//    - Grove (HY2.0-4P) cable, 10 cm recommended (20 cm fits, coiled)
//    - Zip ties up to 5 mm wide x 1.5 mm thick
//
//  Layout
//    AtomS3 screen and PIR dome both face out through the lid. The AtomS3
//    sits on posts with room underneath for the Grove plug, which plugs
//    into its bottom face. The cable loops down and over to the PIR's end
//    connector; any extra length coils in the space under the PIR.
//    The AtomS3 USB-C port faces the -X wall, which has a large chamfered
//    opening for the plug overmold.
//    Two zip-tie tunnels run through the floor, with a V-groove underneath
//    so the case sits centered on a pipe or pole.
//
//  Measure your parts before printing. The device dimensions below come
//  from M5Stack specs and photos; everything is parametric.
//
//  Every part prints without supports.
//
//  Render one part at a time with `part`, or from the command line:
//    openscad -D 'part="base"' -o base.stl atoms3_pir_case.scad
// =====================================================================

/* [Output] */
// assembly | exploded | base | lid | gasket | atom_collar | pir_gasket
part = "assembly";

/* [Devices -- measure yours] */
atom      = [24, 24, 13];   // AtomS3 body
atom_r    = 2.5;            // AtomS3 corner radius (plan view)
usb_z     = 8;              // USB-C center height above AtomS3 bottom face
usb_plug_h = 7;             // thickest USB-C plug overmold to clear
// PIR values from the M5Stack U004 drawing
pir       = [32, 24, 8];    // PIR unit body (without dome)
dome_d    = 10.2;           // PIR fresnel dome diameter at its base
dome_h    = 4.5;            // PIR dome height above body
dome_off  = [8, 0];         // dome is 8 mm from the end opposite the Grove port

/* [Internal clearances] */
grove_clear = 12;    // under the AtomS3 for Grove plug + cable bend
plug_gap    = 14;    // AtomS3 to PIR gap, for the PIR's end Grove plug
side_gap    = 3.0;   // AtomS3 to walls (needed for TPU collar + skirt)
pir_end_gap = 1.0;   // PIR to +X wall
atom_proud  = 0.5;   // minimum AtomS3 recess below the lid top surface

/* [Shell] */
wall    = 3.6;
floor_t = 6.0;       // includes zip-tie tunnels
lid_t   = 3.0;
ri      = 1.5;       // inside corner radius

/* [Gasket (TPU)] */
groove_w    = 1.6;
groove_d    = 1.3;
gasket_w    = 1.4;
gasket_h    = 1.8;   // 0.5 mm (~28%) compression when the lid bottoms out

/* [AtomS3 collar (TPU)] */
collar_t      = 1.2;   // nominal wall
collar_grip   = 0.1;   // interference per side on the AtomS3 (0 = slip fit)
collar_press  = 0.1;   // interference per side in the lid opening
flange_w      = 1.2;
flange_t      = 1.0;
skirt_w       = 1.2;   // PETG skirt under the lid that backs the collar
grip_max      = 3.0;   // longest collar grip on the AtomS3 sides

/* [PIR dome gasket (TPU)] */
pg_t        = 1.6;
pg_squeeze  = 0.4;
pg_od       = dome_d + 5;
pir_skin    = 1.2;   // lid thickness over the PIR (pocketed underneath)
pg_id       = dome_d - 0.2;   // hugs the dome base

/* [USB-C opening] */
usb_w       = 13.5;  // opening sized for the plug overmold, not the port
usb_h       = 8.0;
usb_chamfer = 1.0;
usb_rim     = 1.0;   // min material between the opening and the gasket groove

/* [Heat-set inserts / screws] */
insert_d     = 4.0;  // hole diameter for M3 short insert (check vendor)
insert_depth = 6.2;
pilot_d      = 2.6;
pilot_depth  = 4;
screw_d      = 3.4;
lug_off      = 4.6;  // boss center offset from inside corner (diagonal)
lug_r        = 4.2;

/* [Zip-tie mount] */
zt_w      = 6.0;     // tunnel width
zt_h      = 2.6;     // tunnel height
zt_z      = 1.2;     // tunnel floor thickness
vg_depth  = 3.0;     // 90-degree V-groove for poles/pipes

$fn = 48;
eps = 0.01;

// ---------------------------------------------------------------------
//  Derived geometry. Origin = inside corner of the cavity at z = 0
//  (bottom of base). AtomS3 at -X end, PIR at +X end.
//  Both devices face +Z: the AtomS3 display and the PIR dome look out
//  through the lid in the same direction.
// ---------------------------------------------------------------------
in_x = side_gap + atom.x + plug_gap + pir.x + pir_end_gap;
in_y = atom.y + 2 * side_gap;

floor_top = floor_t;

atom_pos  = [side_gap, side_gap, floor_top + grove_clear];
atom_c    = [atom_pos.x + atom.x / 2, atom_pos.y + atom.y / 2];
atom_top  = atom_pos.z + atom.z;
usb_zc    = atom_pos.z + usb_z;

// The rim sits as low as possible but must clear the USB opening and
// gasket groove; a high USB port pushes the lid above the AtomS3.
rim_z     = max(atom_top + atom_proud - lid_t,
                usb_zc + usb_h / 2 + usb_rim + groove_d);
screen_recess = rim_z + lid_t - atom_top;

pir_pocket = lid_t - pir_skin;
pir_top   = rim_z + pir_pocket - pg_t + pg_squeeze;
pir_pos   = [side_gap + atom.x + plug_gap, (in_y - pir.y) / 2, pir_top - pir.z];
dome_c    = [pir_pos.x + pir.x / 2 + dome_off.x, pir_pos.y + pir.y / 2 + dome_off.y];

bosses = [[-lug_off, -lug_off], [in_x + lug_off, -lug_off],
          [-lug_off, in_y + lug_off], [in_x + lug_off, in_y + lug_off]];
corner_c = [[ri, ri], [in_x - ri, ri], [ri, in_y - ri], [in_x - ri, in_y - ri]];

groove_off = wall / 2;
zt_xs = [in_x * 0.22, in_x * 0.78];

collar_out = atom.x + 2 * collar_t;        // lid opening size
// collar bottom: grips the AtomS3 sides, but stays above a USB plug
collar_z0  = min(max(atom_top - grip_max, usb_zc + usb_plug_h / 2), rim_z - flange_t);
collar_h   = rim_z + lid_t - 0.3 - collar_z0;
skirt_h    = rim_z - (collar_z0 + flange_t);  // below lid underside

echo(str("AtomS3 screen sits ", screen_recess, " mm below the lid surface"));
assert(atom_top - collar_z0 >= 1, "collar has under 1 mm of grip on the AtomS3");
assert(collar_out / 2 + collar_press + max(flange_w, skirt_w) < atom.x / 2 + side_gap - 0.2,
       "side_gap too small for the AtomS3 collar flange / skirt");
assert(pg_od < pir.y, "PIR gasket wider than the PIR body");
assert(pg_od / 2 <= pir.x / 2 - abs(dome_off.x), "PIR gasket overhangs the PIR end");

// ---------------------------------------------------------------------
//  2D helpers
// ---------------------------------------------------------------------
module rrect(size, r) {                // corner at origin
    offset(r) offset(-r) square(size);
}
module rrect_c(size, r) {              // centered
    translate(-size / 2) rrect(size, r);
}
module stadium(w, h) {                 // centered, long axis on X
    hull() for (s = [-1, 1]) translate([s * (w - h) / 2, 0]) circle(d = h);
}
module interior2d() { rrect([in_x, in_y], ri); }

module outline2d() {
    offset(r = wall) interior2d();
    for (i = [0:3]) hull() {
        translate(bosses[i]) circle(r = lug_r);
        translate(corner_c[i]) circle(r = ri + wall);
    }
}
module ring2d(center_off, w) {
    difference() {
        offset(r = center_off + w / 2) interior2d();
        offset(r = center_off - w / 2) interior2d();
    }
}

// extrude a 2D shape (x -> world Y, y -> world Z) along +X
module along_x(h) { rotate([90, 0, 90]) linear_extrude(h) children(); }

// ---------------------------------------------------------------------
//  Base (PETG) -- print upright, no supports
// ---------------------------------------------------------------------
module base() {
    difference() {
        linear_extrude(rim_z) outline2d();

        // cavity
        translate([0, 0, floor_top]) linear_extrude(rim_z) interior2d();

        // gasket groove
        translate([0, 0, rim_z - groove_d]) linear_extrude(groove_d + 1)
            ring2d(groove_off, groove_w);

        // heat-set insert bores
        for (b = bosses) translate([b.x, b.y, 0]) {
            translate([0, 0, rim_z - insert_depth]) cylinder(d = insert_d, h = insert_depth + 1);
            translate([0, 0, rim_z - insert_depth - pilot_depth])
                cylinder(d = pilot_d, h = pilot_depth + eps);
        }

        // USB-C opening, chamfered on the outside
        translate([-wall - 1, atom_c.y, usb_zc]) along_x(wall + 2) stadium(usb_w, usb_h);
        translate([-wall - eps, atom_c.y, usb_zc]) rotate([90, 0, 90])
            linear_extrude(usb_chamfer + eps,
                           scale = [usb_w / (usb_w + 2 * usb_chamfer),
                                    usb_h / (usb_h + 2 * usb_chamfer)])
                stadium(usb_w + 2 * usb_chamfer, usb_h + 2 * usb_chamfer);

        // zip-tie tunnels (along Y)
        for (x = zt_xs) translate([x - zt_w / 2, -30, zt_z]) cube([zt_w, in_y + 60, zt_h]);

        // V-groove (along X)
        translate([in_x / 2, in_y / 2, 0]) rotate([45, 0, 0])
            cube([in_x + 40, vg_depth * sqrt(2), vg_depth * sqrt(2)], center = true);
    }

    atom_posts();
    pir_posts();
}

module atom_posts() {
    p = 4; h = atom_pos.z - floor_top;
    for (i = [0, 1], j = [0, 1])
        translate([atom_pos.x + 0.5 + i * (atom.x - p - 1),
                   atom_pos.y + 0.5 + j * (atom.y - p - 1), floor_top - eps])
            cube([p, p, h + eps]);
    // backstop lips on the +X side: resist USB cable insertion force
    for (j = [0, 1])
        translate([atom_pos.x + atom.x + 0.3, atom_pos.y + 0.5 + j * (atom.y - p - 1), floor_top - eps])
            cube([1.5, p, h + 2]);
}

module pir_posts() {
    p = 4; h = pir_pos.z - floor_top; lip = 1.2; c = 0.3;
    for (i = [0, 1], j = [0, 1]) {
        x = pir_pos.x + i * (pir.x - p);
        y = pir_pos.y + j * (pir.y - p);
        translate([x, y, floor_top - eps]) cube([p, p, h + eps]);
        // L-shaped locating lips on the outside corners
        translate([i ? pir_pos.x + pir.x + c : pir_pos.x - c - lip, y, floor_top - eps])
            cube([lip, p, h + 2]);
        translate([x, j ? pir_pos.y + pir.y + c : pir_pos.y - c - lip, floor_top - eps])
            cube([p, lip, h + 2]);
    }
}

// ---------------------------------------------------------------------
//  Lid (PETG) -- print top face down, no supports
// ---------------------------------------------------------------------
module lid() {
    difference() {
        union() {
            linear_extrude(lid_t) outline2d();
            // skirt under the AtomS3 opening, backs the TPU collar
            if (skirt_h > 0) translate([atom_c.x, atom_c.y, -skirt_h])
                linear_extrude(skirt_h + eps)
                    rrect_c([collar_out + 2 * skirt_w, collar_out + 2 * skirt_w],
                            atom_r + collar_t + skirt_w);
        }

        for (b = bosses) translate([b.x, b.y, -1]) cylinder(d = screw_d, h = lid_t + 2);

        // AtomS3 opening (TPU collar presses in here)
        translate([atom_c.x, atom_c.y, -skirt_h - 1]) linear_extrude(skirt_h + lid_t + 2)
            rrect_c([collar_out, collar_out], atom_r + collar_t);

        // pocket over the PIR body thins the lid so the low dome sees out
        translate([pir_pos.x - 0.3, pir_pos.y - 0.3, -eps])
            cube([pir.x + 0.6, pir.y + 0.6, pir_pocket + eps]);

        // PIR dome opening, chamfered 45 degrees to keep the field of view clear
        translate([dome_c.x, dome_c.y, pir_pocket - eps])
            cylinder(d1 = dome_d + 0.6, d2 = dome_d + 0.6 + 2 * pir_skin, h = pir_skin + 2 * eps);
    }
}

// ---------------------------------------------------------------------
//  TPU parts
// ---------------------------------------------------------------------
module gasket() {
    linear_extrude(gasket_h) ring2d(groove_off, gasket_w);
}

module atom_collar() {                 // print flange down
    outer = collar_out + 2 * collar_press;
    inner = atom.x - 2 * collar_grip;
    difference() {
        union() {
            linear_extrude(flange_t) rrect_c([outer + 2 * flange_w, outer + 2 * flange_w],
                                             atom_r + collar_t + flange_w);
            linear_extrude(collar_h) rrect_c([outer, outer], atom_r + collar_t);
        }
        translate([0, 0, -1]) linear_extrude(collar_h + 2) rrect_c([inner, inner], atom_r);
    }
}

module pir_gasket() {
    difference() {
        cylinder(d = pg_od, h = pg_t);
        translate([0, 0, -1]) cylinder(d = pg_id, h = pg_t + 2);
    }
}

// ---------------------------------------------------------------------
//  Device ghosts (visual reference only)
// ---------------------------------------------------------------------
module atom_ghost() {
    color("DimGray") translate(atom_pos)
        linear_extrude(atom.z) translate(atom / 2) rrect_c([atom.x, atom.y], atom_r);
    color("Black", 0.8) translate([atom_c.x, atom_c.y, atom_pos.z + atom.z - 0.1])
        linear_extrude(0.2) square(17, center = true);
    // Grove plug + cable
    color("White") translate([atom_c.x - 4, atom_c.y - 2.5, atom_pos.z - 6]) cube([8, 5, 6]);
    color("Gold") translate([-wall - 0.1, atom_c.y, usb_zc]) along_x(side_gap + wall) stadium(8.9, 3.2);
}

module pir_ghost() {
    color("LightGray") translate(pir_pos) cube(pir);
    color("White") translate([dome_c.x, dome_c.y, pir_top])
        scale([1, 1, dome_h / (dome_d / 2)]) sphere(d = dome_d);
    color("White") translate([pir_pos.x - 6, pir_pos.y + pir.y / 2 - 4, pir_pos.z + 1.5]) cube([6, 8, 5]);
}

// ---------------------------------------------------------------------
//  Assembly
// ---------------------------------------------------------------------
module assembly(e = 0) {
    color("SteelBlue") base();
    color("Black") translate([0, 0, rim_z - groove_d + e]) gasket();
    color("SteelBlue", 0.6) translate([0, 0, rim_z + 2 * e]) lid();
    color("Black") translate([atom_c.x, atom_c.y, collar_z0 + 1.5 * e]) atom_collar();
    color("Black") translate([dome_c.x, dome_c.y, rim_z + pir_pocket - pg_t + 1.2 * e]) pir_gasket();
    %atom_ghost();
    %pir_ghost();
}

if      (part == "assembly")    assembly();
else if (part == "exploded")    assembly(15);
else if (part == "base")        base();
else if (part == "lid")         translate([0, 0, lid_t]) mirror([0, 0, 1]) lid();
else if (part == "gasket")      gasket();
else if (part == "atom_collar") atom_collar();
else if (part == "pir_gasket")  pir_gasket();
