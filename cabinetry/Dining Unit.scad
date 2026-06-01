use <common.scad>

// Dining Unit
// Layout (left to right, full width):
//   - Left section:  2 cols × 3 rows of teal drawers, full-height carcass.
//   - Center section: 1 row of 2 teal drawers up top, with an open void
//     below housing a freestanding walnut bench.
//   - Right section: 2 cols × 2 drawer rows with a walnut interior niche
//     occupying the middle row.
// A continuous walnut top board spans the whole unit; a teal toe kick
// runs under the left + right sections only (center is open).

// --- Top-level dimensions ---
total_width   = 4220;
depth         = 430;
total_height  = 920;
top_thickness = 30;

usable_w = total_width;

// --- Section widths ---
center_w = 1220;
right_w  = (usable_w - center_w) / 2;
left_w   = usable_w - right_w - center_w;

// --- Heights ---
toe_kick_h     = 80;
usable_h       = total_height - top_thickness - toe_kick_h;   // 790
row1_h         = 205;
row2_h         = 305;
row3_h         = 305;
center_void_h  = row2_h + row3_h + toe_kick_h;
center_box_h   = total_height - top_thickness - center_void_h;

// --- Section X origins ---
x_left   = 0;
x_center = left_w;
x_right  = left_w + center_w;

// --- Common ---
wall_th  = 19;
door_th  = 19;                 // overlay drawer-front thickness

// Carcasses are sunk back by `door_th` so the drawer fronts sit overlaid
// on the front face. `depth` is the visible outer depth (wood panels +
// drawer fronts); carcasses are shorter so panel fronts and drawer fronts
// land on the same Y plane.
carcass_d = depth - door_th;   // 411

// Colors
color_teal     = [0.0, 0.5, 0.55];
color_wood     = [0.55, 0.35, 0.20];
color_white    = [0.97, 0.97, 0.97];
color_internal = [0.9, 0.9, 0.9];

// Thin teal cladding on every carcass wall that's visible when the
// drawers are closed. That's both ends of the unit *and* the inner
// faces flanking the center bench void. Everything else (dividers,
// top, bottom, back, hidden walls) stays white.
end_clad_t = 1;

$fn = 32;

// Exploded view: top board lifts in Z, sections splay outward in X, toe
// kicks drop in Z, drawers push out in Y, bench slides out from center
// void in Y. explode = 0 → assembled.
explode = 00;

// =====================================================================
// Components
// =====================================================================

module wood_niche(w, h, d, wall_th=wall_th) {
    color(color_wood) carcass(w, d, h, wall_th);
}

// =====================================================================
// Sections — each places its own geometry and (when annotate=true) emits
// its own dimension annotations.
// =====================================================================

module left_section(annotate = false) {
    w = left_w;
    col_w = w / 2;

    color(color_white)
    translate([0, 0, toe_kick_h])
    carcass(w, carcass_d, usable_h, wall_th=wall_th);

    // Teal cladding on the two visible faces: the leftmost outside wall
    // and the inner wall facing the center bench void.
    color(color_teal)
    translate([-end_clad_t, 0, toe_kick_h])
    cube([end_clad_t, carcass_d, usable_h]);
    color(color_teal)
    translate([w, 0, toe_kick_h])
    cube([end_clad_t, carcass_d, usable_h]);

    // Vertical divider between the two columns.
    color(color_white)
    translate([w/2 - wall_th/2, wall_th, toe_kick_h])
    cube([wall_th, carcass_d - wall_th, usable_h]);

    // Drawer fronts (6 total: 2 cols × 3 rows). Overlaid on the carcass
    // front; pushed out in Y when exploded.
    translate([0, carcass_d + explode, toe_kick_h]) {
        // Bottom row (row3)
        drawer_front(col_w, row3_h, col=color_teal);
        translate([col_w, 0, 0]) drawer_front(col_w, row3_h, col=color_teal);

        // Middle row (row2)
        translate([0, 0, row3_h]) {
            drawer_front(col_w, row2_h, col=color_teal);
            translate([col_w, 0, 0]) drawer_front(col_w, row2_h, col=color_teal);
        }

        // Top row (row1)
        translate([0, 0, row3_h + row2_h]) {
            drawer_front(col_w, row1_h, col=color_teal);
            translate([col_w, 0, 0]) drawer_front(col_w, row1_h, col=color_teal);
        }
    }

    if (annotate) {
        // Width label across the bottom-front edge.
        dimension([0, depth, 0], [w, depth, 0],
                  str("LEFT SECTION: ", w), [0, 0, -100]);

        // Heights stack on the far left, outside any explode splay.
        dimension([0, depth, 0], [0, depth, toe_kick_h],
                  str("TOE KICK: ", toe_kick_h), [-100, 0, 0]);
        dimension([0, depth, toe_kick_h],
                  [0, depth, toe_kick_h + row3_h],
                  str("DRAWER H: ", row3_h), [-100, 0, 0]);
        dimension([0, depth, toe_kick_h + row3_h],
                  [0, depth, toe_kick_h + row3_h + row2_h],
                  str("DRAWER H: ", row2_h), [-100, 0, 0]);
        dimension([0, depth, toe_kick_h + row3_h + row2_h],
                  [0, depth, toe_kick_h + row3_h + row2_h + row1_h],
                  str("DRAWER H: ", row1_h), [-100, 0, 0]);

        // Total depth annotated from this leftmost section.
        dimension([0, depth, 0], [0, 0, 0],
                  str("DEPTH: ", depth), [-400, 0, 0]);
    }
}

module center_section(annotate = false) {
    w = center_w;
    col_w = w / 2;

    // Upper carcass only (lower half is the open bench void).
    color(color_white)
    translate([0, 0, center_void_h])
    carcass(w, carcass_d, center_box_h, wall_th=wall_th);

    // Teal cladding on the underside — visible from the bench void below.
    color(color_teal)
    translate([0, 0, center_void_h - end_clad_t])
    cube([w, carcass_d, end_clad_t]);

    // Divider in the upper carcass.
    color(color_white)
    translate([w/2 - wall_th/2, wall_th, center_void_h])
    cube([wall_th, carcass_d - wall_th, center_box_h]);

    // Top-row drawers, overlaid on carcass front; pushed out in Y when exploded.
    translate([0, carcass_d + explode, center_void_h]) {
        drawer_front(col_w, row1_h, col=color_teal);
        translate([col_w, 0, 0]) drawer_front(col_w, row1_h, col=color_teal);
    }

    // Bench underneath, pushed out further in Y so it clears the void.
    bench_w = 1100;
    translate([(w - bench_w) / 2, depth - 370 + 2*explode, 0])
    bench(bench_w, 460, 350);

    if (annotate) {
        dimension([0, depth, 0], [w, depth, 0],
                  str("CENTER SECTION: ", w), [0, 0, -100]);
        center_x = w / 2;
        dimension([center_x, depth, 0], [center_x, depth, center_void_h],
                  str("OPEN VOID: ", center_void_h, "mm (Bench Storage)"),
                  [0, 100, 0]);
        dimension([center_x, depth, center_void_h],
                  [center_x, depth, center_void_h + row1_h],
                  str("DRAWER H: ", row1_h), [0, 100, 0]);
    }
}

module right_section(annotate = false) {
    w = right_w;
    col_w = w / 2;

    // Full-height carcass.
    color(color_white)
    translate([0, 0, toe_kick_h])
    carcass(w, carcass_d, usable_h, wall_th=wall_th);

    // Teal cladding on the two visible faces: the inner wall facing the
    // center bench void and the rightmost outside wall.
    color(color_teal)
    translate([-end_clad_t, 0, toe_kick_h])
    cube([end_clad_t, carcass_d, usable_h]);
    color(color_teal)
    translate([w, 0, toe_kick_h])
    cube([end_clad_t, carcass_d, usable_h]);

    // Walnut niche — front flush with the drawer-front plane. Inset 1mm
    // in X and pushed forward 1mm in Y so its back wall doesn't share the
    // Y=0 plane with the surrounding carcass back wall (avoids a
    // coplanar-faces render glitch on the back). Front still lands at
    // Y = depth alongside the drawer fronts, which is fine — the glitch
    // only showed up on the back.
    translate([1, 1, toe_kick_h + row3_h])
    wood_niche(w - 2, row2_h, depth - 1, wall_th=wall_th);

    // Top divider (top row drawers split into 2).
    color(color_white)
    translate([w/2 - wall_th/2, wall_th, toe_kick_h + row2_h + row3_h])
    cube([wall_th, carcass_d - wall_th, row1_h]);

    // Bottom divider (bottom row drawers split into 2).
    color(color_white)
    translate([w/2 - wall_th/2, wall_th, toe_kick_h])
    cube([wall_th, carcass_d - wall_th, row3_h]);

    // Drawer fronts (4 total: 2 cols × 2 rows — no drawers on niche row).
    // Overlaid on carcass front; pushed out in Y when exploded.
    translate([0, carcass_d + explode, toe_kick_h]) {
        drawer_front(col_w, row3_h, col=color_teal);
        translate([col_w, 0, 0]) drawer_front(col_w, row3_h, col=color_teal);

        translate([0, 0, row3_h + row2_h]) {
            drawer_front(col_w, row1_h, col=color_teal);
            translate([col_w, 0, 0]) drawer_front(col_w, row1_h, col=color_teal);
        }
    }

    if (annotate) {
        dimension([0, depth, 0], [w, depth, 0],
                  str("RIGHT SECTION: ", w), [0, 0, -100]);
        // Total height annotated off the far-right edge.
        dimension([w, depth, 0], [w, depth, total_height],
                  str("TOTAL HEIGHT: ", total_height), [200, 0, 0]);
    }
}

module bench(w, h, d_bench) {
    color(color_wood) {
        translate([0, 0, h - 30])           cube([w, d_bench, 30]);          // top
        translate([10, 10, 0])              cube([30, d_bench - 20, h - 30]); // left leg
        translate([w - 40, 10, 0])          cube([30, d_bench - 20, h - 30]); // right leg
        translate([10, d_bench/2 - 10, 100]) cube([w - 20, 20, 50]);          // back brace
    }
}

// =====================================================================
// Full-width parts: top board and toe kicks.
// =====================================================================

// Top board is split into 3 fabricable pieces at the section seams
// (x_center, x_right). 4220mm is too wide for a single board, and the
// seams already align with the carcass joints below. In exploded view,
// the three pieces splay outward in X at the same ranks (-1, 0, +1) as
// the sections below them so they track their respective carcasses.
module top_board(annotate = false) {
    z = total_height - top_thickness + explode;
    ex = [-1, 0, 1] * explode;

    translate([x_left   + ex[0], 0, z]) color(color_wood)
        cube([left_w,   depth, top_thickness]);
    translate([x_center + ex[1], 0, z]) color(color_wood)
        cube([center_w, depth, top_thickness]);
    translate([x_right  + ex[2], 0, z]) color(color_wood)
        cube([right_w,  depth, top_thickness]);

    if (annotate) {
        dimension([0, depth, z], [0, depth, z + top_thickness],
                  str("TOP BOARD: ", top_thickness), [-400, 0, 0]);
        // Each piece's width annotated above its top-back edge so the
        // labels stay readable even when the pieces splay apart.
        dimension([x_left   + ex[0], depth, z + top_thickness],
                  [x_left   + ex[0] + left_w,   depth, z + top_thickness],
                  str("TOP L: ", left_w),   [0, 0, 100]);
        dimension([x_center + ex[1], depth, z + top_thickness],
                  [x_center + ex[1] + center_w, depth, z + top_thickness],
                  str("TOP C: ", center_w), [0, 0, 100]);
        dimension([x_right  + ex[2], depth, z + top_thickness],
                  [x_right  + ex[2] + right_w,  depth, z + top_thickness],
                  str("TOP R: ", right_w),  [0, 0, 100]);
    }
}

// Toe kick: two recessed teal panels under the left and right sections.
// Center section has an open void instead. Toe kicks drop in Z when
// exploded so they peel away from the carcasses above.
module toe_kicks(annotate = false) {
    color(color_teal) {
        translate([x_left,  depth - 40, -explode])
            cube([left_w,  wall_th, toe_kick_h]);
        translate([x_right, depth - 40, -explode])
            cube([right_w, wall_th, toe_kick_h]);
    }
}

// =====================================================================
// Top-level assembly. Flip `annotate` true to show all dimensions.
// =====================================================================
annotate = true;

// Section splay in X: left, center, right at ranks -1, 0, +1.
ex = [-1, 0, 1] * explode;

toe_kicks(annotate);
top_board(annotate);

translate([x_left   + ex[0], 0, 0]) left_section(annotate);
translate([x_center + ex[1], 0, 0]) center_section(annotate);
translate([x_right  + ex[2], 0, 0]) right_section(annotate);
