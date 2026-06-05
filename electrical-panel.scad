// Electrical panel - custom distribution enclosure
// Units: millimetres. Front view (looking AT the wall).
// Origin: bottom-left corner of the wall, floor level.
//   X: along wall horizontal (positive = right)
//   Y: vertical (positive = up)
//   Z: out of the wall (positive = towards the room)
//
// Off-the-shelf: Stabilizer (external), Solar Inverter, Solar Input DB,
//                Solar AC DB (has internal solar MCB), Kincony M30, MCCB,
//                MCBs, supply MCB.
// Custom build:  Enclosure shell, internal busbars, partitions, doors.
//
// Compartments (4 doors):
//   1. Supply Module   - bottom strip, full width, rare access
//   2. Monitoring      - left, just above Supply, houses 2x Kincony M30
//   3. Distribution    - left, upper, VTPN with 20 ways (10 each side)
//   4. Solar chain     - right, full height above Supply
//
// Depth layers (Z from wall outward):
//   0..80   backplate + heavy busbars (supply bus, distribution centre bus)
//   80..170 CT clamps + stabilizer RETURN run (low-Z, "deeper" layer)
//   170..350 front layer: MCCB, supply MCB, MCBs, M30s, AC DB body,
//            stabilizer FEED run (high-Z, near user)

// ====== Wall ======
wall_w = 2700;
wall_h = 2600;
wall_t = 5;

// ====== Window ======
window_w = 540;
window_h = 470;
window_sill = 920;
window_x = (wall_w - window_w) / 2;
window_y = window_sill;
window_top = window_y + window_h;

// ====== Mains supply (fixed) ======
supply_dia        = 50;
supply_from_right = 300;
supply_x          = wall_w - supply_from_right;   // 2400

// ====== Off-the-shelf component sizes [W, H, D] ======
inverter   = [300, 610, 200];
stabilizer = [620, 970, 370];
dbox       = [300, 270, 140];   // both solar DBs
m30        = [160,  90,  65];
mccb       = [150, 250, 150];
// (Supply-side MCB lives at the upstream end of the duct, not in this enclosure)

// ====== 3-phase MCBs ======
mcb_unit     = [51, 87, 80];
mcb_per_side = 10;

// ====== Enclosure shell ======
enc_x = 1700;
enc_y = 50;
enc_w = 870;    // grown to provision a left-side cable trunk in the solar column
enc_h = 1850;   // grown to provision an output MCCB at the bottom of the dist busbar
enc_d = 350;
enc_t = 8;

// Internal vertical partition between left (Distribution + Monitoring) and
// right (Solar chain) halves
partition_x = enc_x + 400;
partition_t = 10;

// ====== Horizontal bands (left column ordered bottom-up: Supply, Dist, Monitoring) ======
sup_y  = enc_y + 30;
sup_h  = 320;       // sized to contain a provisional input MCCB (future-proofing)

// Cable Nest: sub-compartment within the Supply band, bottom-left, holds the
// service slack for the 4x10sqmm stab feed + return cables so the stabilizer
// (on wheels) can be rolled out for maintenance with connections intact.
nest_partition_x = enc_x + 220;
nest_partition_t = 10;
nest_inner_x     = enc_x + enc_t + 10;
nest_inner_w     = nest_partition_x - nest_inner_x - 10;
nest_inner_y     = sup_y + 10;
nest_inner_h     = sup_h - 20;
dist_y = sup_y + sup_h + 30;
mon_h  = 180;
dist_h = (enc_y + enc_h) - dist_y - 30 - mon_h - 30;
mon_y  = dist_y + dist_h + 30;
sol_y  = sup_y + sup_h + 30;
sol_h  = (enc_y + enc_h) - sol_y - 30;

// ====== Inner X regions ======
left_x  = enc_x + enc_t + 10;
left_w  = (partition_x - left_x) - 10;
right_x = partition_x + partition_t + 10;
right_w = (enc_x + enc_w - enc_t) - right_x - 10;

// ====== Solar chain (right column) - AC DB at bottom taps supply busbar ======
// Right-aligned in the right column to leave a left-side cable trunk
// (used by right-bank MCB outputs rising to the top exit).
sol_right_margin = 20;
sol_col_left_trunk_w = 70;   // dedicated wireway against the partition
acdb_x = enc_x + enc_w - enc_t - sol_right_margin - dbox[0];
acdb_y = sol_y;
inv_x  = enc_x + enc_w - enc_t - sol_right_margin - inverter[0];
inv_y  = acdb_y + dbox[1] + 40;
sdb_x  = acdb_x;
sdb_y  = inv_y + inverter[1] + 40;

// ====== Supply Module ======
sup_inner_x = nest_partition_x + nest_partition_t + 10;
sup_inner_w = (enc_x + enc_w - enc_t) - sup_inner_x - 10;

// Input MCCB is PROVISIONED but unused today (stabilizer has a built-in input
// MCB). Future-proofing for a replacement stabilizer that omits the input MCB.
// Shifted right by 40mm so a left-side cable trunk inside Supply Module stays
// clear for stab feed/return.
mccb_x = sup_inner_x + 40;
mccb_y = sup_y + 30;

busbar_x = mccb_x + mccb[0] + 30;
busbar_y = sup_y + sup_h / 2 - 25;
busbar_w = (sup_inner_x + sup_inner_w) - busbar_x - 10;
busbar_h = 50;
busbar_z = 15;
busbar_t = 12;

// CT clamps around each pole of the supply busbar, at one section
ct_clamp_z      = 110;
ct_clamp_dia    = 38;
ct_section_x    = busbar_x + busbar_w * 0.35;

// ====== Distribution Module (VTPN) ======
// Output MCCB (4-pole) provisioned at the bottom of the central busbar - acts as
// distribution-side incomer / maintenance isolator after the stabilizer.
dist_mccb       = mccb;                       // same envelope as supply MCCB
dist_bb_w       = 60;
dist_bb_x       = left_x + (left_w - dist_bb_w) / 2;
dist_mccb_x     = dist_bb_x + dist_bb_w / 2 - dist_mccb[0] / 2;
dist_mccb_y     = dist_y + 30;

dist_bb_y       = dist_mccb_y + dist_mccb[1] + 20;
dist_bb_h       = (dist_y + dist_h) - dist_bb_y - 30;
dist_bb_z       = 15;

mcb_left_x   = dist_bb_x - mcb_unit[0] - 20;
mcb_right_x  = dist_bb_x + dist_bb_w + 20;
mcb_block_h  = mcb_per_side * mcb_unit[1];
mcbs_y       = dist_bb_y + (dist_bb_h - mcb_block_h) / 2;

// ====== Monitoring compartment (2x Kincony M30) ======
m30_y       = mon_y + (mon_h - m30[1]) / 2;
m30_pitch   = m30[0] + 30;
m30_block_w = 2 * m30[0] + 30;
m30_x0      = left_x + (left_w - m30_block_w) / 2;

// ====== External: Stabilizer (off-the-shelf) ======
// Right edge tight against enclosure left edge. Ports face right.
// Output @ low Z (near wall), Input @ high Z (near user).
stab_x = enc_x - stabilizer[0];
stab_y = 0;
stab_in_z  = stabilizer[2] - 80;
stab_out_z = 80;
stab_ports_y = 200;

// ====== Window-top conduit row ======
conduit_dia    = 25;
conduit_row_y  = window_top + 200;
conduit_count  = 8;
conduit_pitch  = 60;
conduit_x0     = window_x + (window_w - (conduit_count - 1) * conduit_pitch) / 2;

// ====== Z anchors for cable layers ======
z_front = enc_d - 60;   // front-layer routing (MCCB feed, stab IN)
z_mid   = ct_clamp_z;   // CT layer (stab RETURN, CT signal)
z_back  = busbar_z + busbar_t / 2;

// =========================================================================
// MODULES
// =========================================================================

module wall_panel() {
    color("gainsboro") translate([0, 0, -wall_t])
        cube([wall_w, wall_h, wall_t]);
}

module grid() {
    color("lightgray", 0.25) {
        for (x = [0 : 200 : wall_w])
            translate([x, 0, -wall_t + 0.1]) cube([1, wall_h, 0.2]);
        for (y = [0 : 200 : wall_h])
            translate([0, y, -wall_t + 0.1]) cube([wall_w, 1, 0.2]);
    }
}

module window_cutout() {
    color("skyblue", 0.55) translate([window_x, window_y, -wall_t - 0.1])
        cube([window_w, window_h, wall_t + 0.2]);
}

module labeled_box(dim, name, col) {
    color(col) cube(dim);
    color("white") translate([4, dim[1] - 8, dim[2] + 0.1])
        linear_extrude(0.5) text(name, size = 28, valign = "top");
}

// Cable polyline as hulled spheres
module cable(points, dia = 10, col = "red") {
    for (i = [0 : len(points) - 2])
        color(col) hull() {
            translate(points[i])     sphere(d = dia, $fn = 10);
            translate(points[i + 1]) sphere(d = dia, $fn = 10);
        }
}

// ====== Enclosure shell + partitions ======
module enclosure_shell() {
    // backplate
    color("lightgray", 0.85) translate([enc_x, enc_y, 0])
        cube([enc_w, enc_h, enc_t]);
    // outer walls
    color("lightgray", 0.4) {
        translate([enc_x, enc_y, 0]) cube([enc_t, enc_h, enc_d]);
        translate([enc_x + enc_w - enc_t, enc_y, 0]) cube([enc_t, enc_h, enc_d]);
        translate([enc_x, enc_y, 0]) cube([enc_w, enc_t, enc_d]);
        translate([enc_x, enc_y + enc_h - enc_t, 0]) cube([enc_w, enc_t, enc_d]);
    }
    // vertical partition between left and right halves
    color("lightgray", 0.4)
        translate([partition_x, enc_y + enc_t, 0])
            cube([partition_t, enc_h - 2 * enc_t, enc_d - 30]);
    // nest partition (separates Cable Nest from Supply Module, both in Supply band)
    color("lightgray", 0.4)
        translate([nest_partition_x, sup_y, 0])
            cube([nest_partition_t, sup_h, enc_d - 30]);
    // horizontal shelves on the LEFT half: top of Supply, top of Distribution
    color("lightgray", 0.4) {
        translate([enc_x + enc_t, sup_y + sup_h, 0])
            cube([partition_x - enc_x - enc_t, 5, enc_d - 30]);
        translate([enc_x + enc_t, dist_y + dist_h, 0])
            cube([partition_x - enc_x - enc_t, 5, enc_d - 30]);
    }
    // horizontal shelf on the RIGHT half: top of Supply
    color("lightgray", 0.4)
        translate([partition_x + partition_t, sup_y + sup_h, 0])
            cube([enc_x + enc_w - partition_x - partition_t - enc_t, 5, enc_d - 30]);
}

// Door outlines drawn as transparent front-face plates
module enclosure_doors() {
    door_z = enc_d - 4;
    door_t = 3;
    // 1a. Cable Nest door (bottom-left of Supply band)
    color("teal", 0.22)
        translate([enc_x + 10, sup_y, door_z])
            cube([nest_partition_x - enc_x - 15, sup_h, door_t]);
    // 1b. Supply Module door (bottom, right of nest)
    color("steelblue", 0.22)
        translate([nest_partition_x + nest_partition_t + 5, sup_y, door_z])
            cube([enc_x + enc_w - nest_partition_x - nest_partition_t - 15,
                  sup_h, door_t]);
    // 2. Monitoring door (left, middle-low)
    color("seagreen", 0.22)
        translate([enc_x + 10, mon_y, door_z])
            cube([partition_x - enc_x - 20, mon_h, door_t]);
    // 3. Distribution Module door (left, upper)
    color("orange", 0.22)
        translate([enc_x + 10, dist_y, door_z])
            cube([partition_x - enc_x - 20, dist_h, door_t]);
    // 4. Solar chain door (right, full height above Supply)
    color("plum", 0.22)
        translate([partition_x + partition_t + 5, sup_y + sup_h + 10, door_z])
            cube([enc_x + enc_w - partition_x - partition_t - 25,
                  enc_h - sup_h - 50, door_t]);
}

// ====== Cable Nest (slack for 4x10sqmm stab feed + return) ======
module cable_nest() {
    cx = nest_inner_x + nest_inner_w / 2;
    cy_top = nest_inner_y + nest_inner_h - 30;
    cy_bot = nest_inner_y + 30;

    // Stab FEED slack (front layer) - enters at left wall, loops, exits right wall
    cable([[enc_x - 3,                stab_ports_y, z_front],
           [nest_inner_x + 10,        stab_ports_y, z_front],
           [nest_inner_x + 10,        cy_top,       z_front],
           [cx + 40,                  cy_top,       z_front],
           [cx + 40,                  cy_bot,       z_front],
           [nest_partition_x - 5,     cy_bot,       z_front],
           [nest_partition_x - 5,     stab_ports_y, z_front]],
          dia = 22, col = "royalblue");

    // Stab RETURN slack (mid layer) - enters at left, loops, exits top of nest
    cable([[enc_x - 3,                stab_ports_y, z_mid],
           [nest_inner_x + 30,        stab_ports_y, z_mid],
           [nest_inner_x + 30,        cy_bot,       z_mid],
           [cx - 30,                  cy_bot,       z_mid],
           [cx - 30,                  cy_top,       z_mid],
           [nest_partition_x - 25,    cy_top,       z_mid],
           [nest_partition_x - 25,    nest_inner_y + nest_inner_h - 5, z_mid]],
          dia = 22, col = "midnightblue");

    color("white")
        translate([enc_x + 15, sup_y + sup_h - 12, enc_d - 5])
            linear_extrude(0.5) text("CABLE NEST", size = 22, valign = "top");
}

// ====== Supply Module ======
module supply_module() {
    // Input MCCB - PROVISIONED ONLY (current stabilizer has built-in input MCB).
    // Translucent to mark reserved space; routing avoids this volume.
    color("darkorange", 0.3)
        translate([mccb_x, mccb_y, z_front - mccb[2]])
            cube(mccb);
    color("white") translate([mccb_x + 4, mccb_y + mccb[1] - 8, z_front + 0.1])
        linear_extrude(0.5) text("MCCB (provision)", size = 22, valign = "top");
    // 4-pole horizontal busbar (4 parallel bars stacked in Y)
    for (i = [0 : 3])
        color("saddlebrown")
            translate([busbar_x,
                       busbar_y + i * (busbar_h / 4),
                       busbar_z])
                cube([busbar_w, busbar_h / 4 - 2, busbar_t]);
    color("white")
        translate([busbar_x + 8, busbar_y - 18, busbar_z + busbar_t + 0.1])
            linear_extrude(0.5) text("4P SUPPLY BUSBAR", size = 22);
    // CT clamps - one per pole at ct_section_x
    for (i = [0 : 3])
        color("dimgray")
            translate([ct_section_x,
                       busbar_y + i * (busbar_h / 4) + busbar_h / 8,
                       ct_clamp_z])
                rotate([0, 90, 0])
                    cylinder(h = 25, d = ct_clamp_dia, center = true, $fn = 24);
}

// ====== Solar chain ======
module solar_chain() {
    translate([acdb_x, acdb_y, z_front - dbox[2]])
        labeled_box(dbox, "Solar AC DB", "indianred");
    translate([inv_x, inv_y, z_front - inverter[2]])
        labeled_box(inverter, "INVERTER", "steelblue");
    translate([sdb_x, sdb_y, z_front - dbox[2]])
        labeled_box(dbox, "SOLAR DC DB", "indianred");
}

// ====== Distribution Module (VTPN) ======
module distribution_module() {
    // Output / incomer MCCB at the bottom of the central busbar
    translate([dist_mccb_x, dist_mccb_y, z_front - dist_mccb[2]])
        labeled_box(dist_mccb, "OUT MCCB", "darkorange");
    // Central 4P vertical busbar (4 bars side-by-side in X)
    for (i = [0 : 3])
        color("saddlebrown")
            translate([dist_bb_x + i * (dist_bb_w / 4),
                       dist_bb_y, dist_bb_z])
                cube([dist_bb_w / 4 - 2, dist_bb_h, 14]);
    // Left bank of 10 MCBs
    for (i = [0 : mcb_per_side - 1])
        color("black")
            translate([mcb_left_x, mcbs_y + i * mcb_unit[1], enc_t + 20])
                cube([mcb_unit[0] - 2, mcb_unit[1] - 2, mcb_unit[2]]);
    // Right bank of 10 MCBs
    for (i = [0 : mcb_per_side - 1])
        color("black")
            translate([mcb_right_x, mcbs_y + i * mcb_unit[1], enc_t + 20])
                cube([mcb_unit[0] - 2, mcb_unit[1] - 2, mcb_unit[2]]);
    color("white")
        translate([left_x + 5, dist_y + dist_h - 15, enc_t + mcb_unit[2] + 25])
            linear_extrude(0.5)
                text("DISTRIBUTION (VTPN, 20 ways)", size = 22);
}

// ====== Monitoring compartment ======
module monitoring_module() {
    // DIN rail
    color("silver")
        translate([left_x + 20, m30_y + m30[1] - 25, enc_t + 8])
            cube([left_w - 40, 35, 7]);
    // Two M30s side by side
    for (i = [0, 1])
        translate([m30_x0 + i * m30_pitch, m30_y, enc_t + 15])
            labeled_box(m30, str("M30 #", i + 1), "navy");
    color("white")
        translate([left_x + 5, mon_y + mon_h - 12, enc_t + m30[2] + 25])
            linear_extrude(0.5) text("MONITORING", size = 22);
}

// ====== Stabilizer (external) ======
module stabilizer_unit() {
    translate([stab_x, stab_y, 0])
        labeled_box(stabilizer, "STABILIZER", "darkolivegreen");
    // Port indicators on right side - input (high Z, yellow) and output (low Z, cyan)
    color("yellow")
        translate([stab_x + stabilizer[0], stab_ports_y, stab_in_z])
            rotate([0, 90, 0]) cylinder(h = 30, d = 22, $fn = 16);
    color("cyan")
        translate([stab_x + stabilizer[0], stab_ports_y, stab_out_z])
            rotate([0, 90, 0]) cylinder(h = 30, d = 22, $fn = 16);
}

// ====== Mains conduit ======
module supply_conduit() {
    color("orange")
        translate([supply_x, 0, supply_dia / 2])
            rotate([-90, 0, 0])
                cylinder(h = sup_y + 30, d = supply_dia, $fn = 32);
    color("black") translate([supply_x, 0, 0])
        cylinder(h = 1, d = supply_dia + 10, $fn = 32);
}

// ====== Window-top conduit row ======
module conduit_row() {
    for (i = [0 : conduit_count - 1])
        color("dimgray")
            translate([conduit_x0 + i * conduit_pitch, conduit_row_y, -wall_t])
                cylinder(h = 50, d = conduit_dia, $fn = 24);
}

// =========================================================================
// CABLE RUNS
// =========================================================================

// FRONT-layer feed: Supply busbar tap -> Stabilizer input.
// Today bypasses the provisional MCCB; route runs through the left trunk in the
// Supply Module (x < mccb_x = 1758), never behind the MCCB volume.
// Busbar tap -> down to Supply left trunk -> RIGHT through nest partition
// gland -> the nest holds the service slack -> exits enclosure left wall to
// the stabilizer. Never behind a panel.
module run_busbar_to_stab() {
    p_tap        = [busbar_x + 20, busbar_y + busbar_h / 2, busbar_z + busbar_t + 5];
    p_above      = [busbar_x + 20, sup_y + sup_h - 30, z_front];
    p_supply_trunk_x = mccb_x - 20;
    p_supply_y200    = [p_supply_trunk_x, stab_ports_y, z_front];
    p_nest_right     = [nest_partition_x + nest_partition_t + 3, stab_ports_y, z_front];
    cable([p_tap,
           p_above,
           [p_supply_trunk_x, sup_y + sup_h - 30, z_front],
           p_supply_y200,
           p_nest_right], dia = 18, col = "blue");
    // (the nest itself draws the slack loop and the segment exiting at enc_x)
    p_stab = [stab_x + stabilizer[0] + 3, stab_ports_y, stab_in_z];
    cable([[enc_x - 3, stab_ports_y, z_front], p_stab], dia = 18, col = "blue");
}

// MID-layer return: Stabilizer output -> Output MCCB (bottom) -> central busbar
// Routes via the left-side Supply trunk (x < mccb_x), then OVER the MCCB top,
// then up the left perimeter into the Output MCCB. Never behind MCCB.
// Stab side -> enclosure left wall -> the nest holds the slack -> exits the
// nest TOP -> rises through the left perimeter trunk past Distribution Module
// equipment -> into the Output MCCB bottom.
module run_stab_to_dist() {
    p_stab     = [stab_x + stabilizer[0] + 3, stab_ports_y, stab_out_z];
    cable([p_stab, [enc_x - 3, stab_ports_y, z_mid]], dia = 18, col = "navy");
    // (slack inside the nest is drawn by cable_nest())
    // From nest top to Output MCCB via the left perimeter trunk
    perim_x    = nest_partition_x - 25;
    p_mccb_in  = [dist_mccb_x + dist_mccb[0] / 2, dist_mccb_y - 5, z_mid];
    cable([[perim_x, nest_inner_y + nest_inner_h - 5, z_mid],
           [perim_x, sup_y + sup_h + 15,              z_mid],   // above Supply shelf
           [perim_x, dist_mccb_y - 25,                z_mid],
           [p_mccb_in[0], dist_mccb_y - 25,           z_mid],
           p_mccb_in], dia = 18, col = "navy");
    // Output MCCB top -> central busbar via a SIDE drop-link path: cable exits
    // MCCB top at the front layer, routes around the LEFT side of the MCCB
    // (clear of any panel), drops in Z to the back layer in open space, then
    // connects up to the busbar bottom. Never behind the MCCB body.
    p_mccb_out = [dist_mccb_x + dist_mccb[0] / 2,
                  dist_mccb_y + dist_mccb[1] + 5, z_front - dist_mccb[2] / 2];
    side_x     = dist_mccb_x - 25;
    p_bb_in    = [dist_bb_x + dist_bb_w / 2, dist_bb_y + 5, z_back];
    cable([p_mccb_out,
           [p_mccb_out[0], dist_mccb_y + dist_mccb[1] + 20, z_front - dist_mccb[2] / 2],
           [side_x,        dist_mccb_y + dist_mccb[1] + 20, z_front - dist_mccb[2] / 2],
           [side_x,        dist_mccb_y + dist_mccb[1] + 20, z_back],
           [side_x,        dist_bb_y - 10, z_back],
           p_bb_in], dia = 16, col = "navy");
}

// Solar feed: left-wall duct -> across top of wall -> into enclosure top-right
//             -> drop into Solar IN DB top
module run_solar_in() {
    p_duct  = [0, wall_h - 50, 60];
    p_corner = [enc_x + enc_w - 60, wall_h - 50, 60];
    p_top   = [sdb_x + dbox[0] * 0.3, enc_y + enc_h - 25, 60];
    p_sdb   = [sdb_x + dbox[0] * 0.3, sdb_y + dbox[1] + 2, z_front - dbox[2] / 2];
    cable([p_duct, p_corner, p_top, p_sdb], dia = 14, col = "red");
}

// Solar IN DB bottom -> Inverter bottom-left.
// Drops via the LEFT trunk in the right column (the dedicated lane next to the
// partition) - never inside the Inverter body.
module run_sdb_to_inv() {
    z = z_front - dbox[2] / 2;
    p_out = [sdb_x + dbox[0] * 0.7, sdb_y - 2, z];
    p_in  = [inv_x + 40, inv_y - 2, z_front - inverter[2] / 2];
    trunk_x = right_x + sol_col_left_trunk_w / 2;     // inside left trunk
    cable([p_out,
           [p_out[0], sdb_y - 25, z],
           [trunk_x,  sdb_y - 25, z],
           [trunk_x,  inv_y - 25, z],   // descends past inverter on its LEFT
           [p_in[0],  inv_y - 25, z],
           p_in], dia = 12, col = "crimson");
}

// Inverter bottom-right -> AC DB top
module run_inv_to_acdb() {
    p_inv = [inv_x + inverter[0] - 40, inv_y - 2, z_front - inverter[2] / 2];
    p_acdb = [acdb_x + dbox[0] * 0.3, acdb_y + dbox[1] + 2, z_front - dbox[2] / 2];
    cable([p_inv,
           [p_inv[0], acdb_y + dbox[1] + 25, z_front - inverter[2] / 2],
           [p_acdb[0], acdb_y + dbox[1] + 25, z_front - dbox[2] / 2],
           p_acdb], dia = 12, col = "purple");
}

// AC DB drop links: 4 solid copper bars from the AC DB's internal MCB load side
// straight down through a shelf cutout onto the 4P supply busbar. Not a cable
// run - the AC DB bolts directly onto the busbar via these drop links.
// AC DB drop links: 4 solid copper bars rising from the supply busbar up
// through a dedicated shelf cutout to the AC DB's internal MCB load terminals.
// Mechanical busbar tap (part of AC DB mounting) - not a cable.
module acdb_drop_link() {
    link_w   = 18;
    link_t   = 8;
    z_acdb   = z_front - dbox[2] / 2;     // mid-depth of AC DB body
    for (i = [0 : 3]) {
        x_link = acdb_x + 30 + i * ((dbox[0] - 60) / 3) - link_w / 2;
        y_top  = acdb_y;
        y_bot  = busbar_y + i * (busbar_h / 4) + busbar_h / 8;
        color("peru")
            hull() {
                translate([x_link, y_bot,        busbar_z + busbar_t / 2])
                    cube([link_w, link_t, link_t]);
                translate([x_link, y_top - link_t, z_acdb - link_t / 2])
                    cube([link_w, link_t, link_t]);
            }
    }
}

// Visible cable wireways: light translucent boxes marking the provisioned
// trunking lanes so no cable has to route behind a panel.
module wireways() {
    // Left-side signal trunk: Supply top -> Monitoring, hugging left interior wall
    color("palegreen", 0.18)
        translate([enc_x + enc_t + 5, sup_y + sup_h - 50, ct_clamp_z - 15])
            cube([35, mon_y - sup_y - sup_h + 50, 35]);
    // Solar column LEFT trunk: Distribution right exit -> top of enclosure
    color("khaki", 0.22)
        translate([partition_x + partition_t + 5, dist_y + 100, 170])
            cube([sol_col_left_trunk_w,
                  enc_y + enc_h - dist_y - 110, 80]);
    // Wireway shelf above MCCB in Supply Module (front-to-back access for pigtails)
    color("palegreen", 0.18)
        translate([sup_inner_x, sup_y + sup_h - 50, ct_clamp_z - 15])
            cube([sup_inner_w, 45, 35]);
}

// Distribution LEFT MCB outputs (10 ways) -> exit left of enclosure -> conduits row
module run_dist_left_to_conduits() {
    for (i = [0 : mcb_per_side - 1]) {
        p_mcb = [mcb_left_x, mcbs_y + i * mcb_unit[1] + mcb_unit[1] / 2,
                 enc_t + 20 + mcb_unit[2] / 2];
        ci = i % conduit_count;
        cx = conduit_x0 + ci * conduit_pitch;
        cable([p_mcb,
               [enc_x - 5, p_mcb[1], 110],
               [enc_x - 5, conduit_row_y, 110],
               [cx, conduit_row_y, 110],
               [cx, conduit_row_y, 0]], dia = 6, col = "brown");
    }
}

// Distribution RIGHT MCB outputs (10 ways) -> up through solar trunk -> top of
//  enclosure -> left across top of wall -> exit into left-wall duct
module run_dist_right_to_duct() {
    // Riser sits INSIDE the provisioned solar-column left trunk (to the LEFT of
    // every solar component; never behind a panel).
    riser_x   = partition_x + partition_t + sol_col_left_trunk_w / 2;
    top_lane  = enc_y + enc_h - 25;
    duct_lane = wall_h - 80;
    for (i = [0 : mcb_per_side - 1]) {
        p_mcb = [mcb_right_x + mcb_unit[0],
                 mcbs_y + i * mcb_unit[1] + mcb_unit[1] / 2,
                 enc_t + 20 + mcb_unit[2] / 2];
        cable([p_mcb,
               // through partition gland plate into solar-column left trunk
               [riser_x, p_mcb[1], 210],
               // rise to top of enclosure inside the trunk
               [riser_x, top_lane, 210],
               // exit out the top, run left along top-of-wall lane to duct
               [enc_x + 30, top_lane, 210],
               [enc_x + 30, duct_lane, 210],
               [0,          duct_lane, 210]], dia = 6, col = "saddlebrown");
    }
}

// CT pigtails: from CTs at supply busbar UP through the left-side signal trunk,
// past the Distribution Module, into the M30s at the top of the enclosure.
// Routed at ct_clamp_z (mid layer), in a dedicated low-voltage signal lane
// hugging the left interior wall so they stay separate from heavy conductors.
module run_ct_pigtails() {
    // Signal lane hugs the left interior wall (outside MCCB X range), rising
    // from the wireway shelf above the MCCB up to the Monitoring compartment.
    signal_lane_x = enc_x + enc_t + 18;     // left of MCCB (x=mccb_x=1718)
    shelf_y       = sup_y + sup_h - 30;     // wireway shelf above MCCB top
    for (i = [0 : 3]) {
        p_ct  = [ct_section_x,
                 busbar_y + i * (busbar_h / 4) + busbar_h / 8,
                 ct_clamp_z];
        which_m30 = (i < 2) ? 0 : 1;
        p_m30 = [m30_x0 + which_m30 * m30_pitch + m30[0] / 2,
                 m30_y + m30[1] * 0.4,
                 enc_t + 15 + m30[2] - 5];
        cable([p_ct,
               [p_ct[0],       shelf_y,    ct_clamp_z],   // up over MCCB top
               [signal_lane_x, shelf_y,    ct_clamp_z],   // left across shelf
               [signal_lane_x, mon_y - 10, ct_clamp_z],   // up perimeter
               [p_m30[0],      mon_y - 10, ct_clamp_z],
               p_m30], dia = 3, col = "limegreen");
    }
}

// =========================================================================
// DIMENSION ANNOTATIONS (pattern adapted from cabinetry/common.scad)
// =========================================================================
show_dimensions = true;
dim_color       = "orange";
dim_text_color  = "red";
dim_line_d      = 3;
dim_tick_d      = 4;
dim_text_h      = 50;       // typical text height
dim_text_thk    = 2;
dim_z           = 320;      // draw in front of all components

// Horizontal dimension between x1 and x2, drawn at vertical line y_anchor,
// dimension line offset by `off` in Y (positive=above, negative=below).
module dim_h(x1, x2, y_anchor, label, off=-100, text_size=undef) {
    ts = text_size == undef ? dim_text_h : text_size;
    yd = y_anchor + off;
    color(dim_color, 0.7) {
        hull() {
            translate([x1, yd, dim_z]) sphere(d=dim_line_d, $fn=12);
            translate([x2, yd, dim_z]) sphere(d=dim_line_d, $fn=12);
        }
        hull() {
            translate([x1, y_anchor, dim_z]) sphere(d=dim_tick_d, $fn=12);
            translate([x1, yd,       dim_z]) sphere(d=dim_tick_d, $fn=12);
        }
        hull() {
            translate([x2, y_anchor, dim_z]) sphere(d=dim_tick_d, $fn=12);
            translate([x2, yd,       dim_z]) sphere(d=dim_tick_d, $fn=12);
        }
    }
    color(dim_text_color)
        translate([(x1 + x2) / 2,
                   yd + (off >= 0 ? ts*0.7 : -ts*0.7),
                   dim_z])
            linear_extrude(dim_text_thk)
                text(label, size=ts, halign="center", valign="center");
}

// Vertical dimension between y1 and y2, drawn at horizontal line x_anchor,
// dimension line offset by `off` in X (positive=right, negative=left).
module dim_v(y1, y2, x_anchor, label, off=-100, text_size=undef) {
    ts = text_size == undef ? dim_text_h : text_size;
    xd = x_anchor + off;
    color(dim_color, 0.7) {
        hull() {
            translate([xd, y1, dim_z]) sphere(d=dim_line_d, $fn=12);
            translate([xd, y2, dim_z]) sphere(d=dim_line_d, $fn=12);
        }
        hull() {
            translate([x_anchor, y1, dim_z]) sphere(d=dim_tick_d, $fn=12);
            translate([xd,       y1, dim_z]) sphere(d=dim_tick_d, $fn=12);
        }
        hull() {
            translate([x_anchor, y2, dim_z]) sphere(d=dim_tick_d, $fn=12);
            translate([xd,       y2, dim_z]) sphere(d=dim_tick_d, $fn=12);
        }
    }
    color(dim_text_color)
        translate([xd + (off >= 0 ? ts*0.7 : -ts*0.7),
                   (y1 + y2) / 2,
                   dim_z])
            rotate([0, 0, 90])
                linear_extrude(dim_text_thk)
                    text(label, size=ts, halign="center", valign="center");
}

module dimensions() {
    // ---- Enclosure overall (outer W & H) ----
    dim_h(enc_x, enc_x + enc_w,
          enc_y + enc_h, str("ENC ", enc_w), off=80, text_size=60);
    dim_v(enc_y, enc_y + enc_h,
          enc_x + enc_w, str(enc_h), off=80, text_size=60);

    // ---- Internal vertical split (left half / right half widths) ----
    dim_h(enc_x, partition_x,
          enc_y, str(partition_x - enc_x), off=-90);
    dim_h(partition_x + partition_t, enc_x + enc_w,
          enc_y, str(enc_x + enc_w - partition_x - partition_t), off=-90);

    // ---- Cable Nest width (inside Supply band) ----
    dim_h(enc_x, nest_partition_x,
          sup_y + sup_h, str("Nest ", nest_partition_x - enc_x), off=35, text_size=35);
    dim_h(nest_partition_x + nest_partition_t, partition_x,
          sup_y + sup_h, str(partition_x - nest_partition_x - nest_partition_t),
          off=35, text_size=35);

    // ---- Compartment band heights (on the right edge of the enclosure) ----
    bands_x = enc_x + enc_w;
    dim_v(sup_y,  sup_y + sup_h,   bands_x, str("Sup ",  sup_h),  off=200, text_size=40);
    dim_v(dist_y, dist_y + dist_h, bands_x, str("Dist ", dist_h), off=200, text_size=40);
    dim_v(mon_y,  mon_y + mon_h,   bands_x, str("Mon ",  mon_h),  off=200, text_size=40);
}

// =========================================================================
// RENDER
// =========================================================================
wall_panel();
grid();
window_cutout();

enclosure_shell();
cable_nest();
supply_module();
solar_chain();
distribution_module();
monitoring_module();

stabilizer_unit();
supply_conduit();
conduit_row();

wireways();
acdb_drop_link();

run_busbar_to_stab();
run_stab_to_dist();
run_solar_in();
run_sdb_to_inv();
run_inv_to_acdb();
run_dist_left_to_conduits();
run_dist_right_to_duct();
run_ct_pigtails();

enclosure_doors();

if (show_dimensions) dimensions();

// =========================================================================
// ECHO SUMMARY
// =========================================================================
echo(str("Enclosure   : ", [enc_x, enc_y], " size ", [enc_w, enc_h, enc_d]));
echo(str("  Supply band   y=", sup_y, "..", sup_y + sup_h));
echo(str("    Cable Nest    x=", enc_x, "..", nest_partition_x,
         "  (", nest_inner_w, "mm wide for stab cable slack)"));
echo(str("    Supply mod    x=", nest_partition_x + nest_partition_t, "..", enc_x + enc_w));
echo(str("  Monitoring    y=", mon_y, "..", mon_y + mon_h));
echo(str("  Distribution  y=", dist_y, "..", dist_y + dist_h));
echo(str("  Solar chain   y=", sol_y, "..", sol_y + sol_h));
echo(str("Solar IN DB  : ", [sdb_x, sdb_y], " top y=", sdb_y + dbox[1]));
echo(str("Inverter     : ", [inv_x, inv_y], " top y=", inv_y + inverter[1]));
echo(str("AC DB        : ", [acdb_x, acdb_y]));
echo(str("Stabilizer   : ", [stab_x, stab_y], " right edge x=", stab_x + stabilizer[0]));
echo(str("Mains conduit @ x=", supply_x));
