use <common.scad>

// Projector Unit
// Layout (left to right):
//   - Left section:  2-col × 2-row drawer bank, full carcass height
//   - Center section: single tall drawer, shorter carcass (TV/projector sits on top)
//   - Right section: 2-col × 1-row drawer bank, full carcass height
//   All three sections share 4 walnut legs each and sit at the same Y.

// --- Top-level dimensions ---
total_width   = 3340;
depth         = 600;
side_height   = 310;
center_height = 210 - 37;
legs_h        = 100;
legs_w        = 25;

wall_thickness    = 18;
door_transparency = 0.6;

$fn = 32;

walnut       = [0.45, 0.25, 0.15];
drawer_color = [0.1, 0.1, 0.3];

// --- Section widths ---
w_left   = total_width * 2 / 5;
w_center = total_width / 5;
w_right  = total_width * 2 / 5;

// --- Section X origins ---
x_left   = 0;
x_center = w_left;
x_right  = w_left + w_center;

// Exploded view: sections splay outward in X, drawer fronts push out in Y,
// legs drop in Z. explode = 0 → assembled.
explode = 250;

// =====================================================================
// Components
// =====================================================================

module leg() {
    color(walnut) cube([legs_w, legs_w, legs_h]);
}

module base(w, d, h) {
    translate([0, 0, legs_h])
    color(walnut) carcass(w, d, h, wall_th=wall_thickness, flush_front=true);

    translate([0,          0,          0]) leg();
    translate([w - legs_w, 0,          0]) leg();
    translate([0,          d - legs_w, 0]) leg();
    translate([w - legs_w, d - legs_w, 0]) leg();
}

// Projector-scaled dimension wrapper
module dim_p(pos1, pos2, label, offset=[0,-100,0]) {
    dimension(pos1, pos2, label, offset, text_size=60, ext=5, sp1=4, sp2=5);
}

// ---- Generic drawer section (carcass + grid of drawer fronts) ----
module section(w, h, nx=1, nz=1, annotate=false, label="") {
    base(w, depth, h);

    dw = w / nx;
    dh = (h - 2 * wall_thickness) / nz;

    // Vertical dividers between drawer columns. Without these the drawer
    // slides have nothing to ride on between the outer carcass walls.
    // Set back from the front face by `wall_thickness` to match the
    // carcass side panels (which use flush_front and end at d - wall_th).
    for (i = [1:nx-1]) {
        color(walnut)
        translate([i * dw - wall_thickness/2, wall_thickness,
                   legs_h + wall_thickness])
        cube([wall_thickness,
              depth - 2 * wall_thickness,
              h - 2 * wall_thickness]);
    }

    for (i = [0:nx-1]) {
        for (j = [0:nz-1]) {
            translate([i * dw, depth - wall_thickness + explode,
                       legs_h + wall_thickness + j * dh])
            drawer_front(dw, dh, depth=wall_thickness, gap=1,
                         col=drawer_color, trans=door_transparency, handle_w=0);
        }
    }

    if (annotate) {
        // Width label across the section's top-back edge.
        dim_p([0, depth, legs_h + h], [w, depth, legs_h + h],
              str(label, ": ", w), [0, 80, 0]);

        // Drawer cell height (first column, first row) for reference.
        dh_label = dh;
        dim_p([w, depth, legs_h + wall_thickness],
              [w, depth, legs_h + wall_thickness + dh_label],
              str("Drawer H: ", dh_label), [0, 200, 0]);
    }
}

// =====================================================================
// Top-level assembly. Flip `annotate` true to show all dimensions.
// =====================================================================
annotate = true;

module left_section(annotate = false) {
    section(w_left, side_height, nx=2, nz=2, annotate=annotate, label="Left");

    if (annotate) {
        // Height stack and total depth annotated once, off the left edge.
        dim_p([0, 0, 0], [0, 0, legs_h],
              str("Legs: ", legs_h), [-180, 0, 0]);
        dim_p([0, 0, legs_h], [0, 0, legs_h + side_height],
              str("Carcass: ", side_height), [-180, 0, 0]);
        dim_p([0, 0, 0], [0, 0, legs_h + side_height],
              str("Total H: ", legs_h + side_height), [-500, 0, 0]);
        dim_p([0, depth, 0], [0, 0, 0],
              str("Depth: ", depth), [-100, 0, 0]);
    }
}

module center_section(annotate = false) {
    section(w_center, center_height, annotate=annotate, label="Center");
}

module right_section(annotate = false) {
    section(w_right, side_height, nx=2, annotate=annotate, label="Right");
}

// Section explode splay: left, center, right at ranks -1, 0, +1.
ex = [-1, 0, 1] * explode;

translate([x_left   + ex[0], 0, 0]) left_section(annotate);
translate([x_center + ex[1], 0, 0]) center_section(annotate);
translate([x_right  + ex[2], 0, 0]) right_section(annotate);

if (annotate) {
    // Overall width sits above the back top edge so it doesn't collide
    // with the per-section width labels.
    dim_p([0, depth, 0], [total_width, depth, 0],
          str("Total Width: ", total_width), [0, 150, 0]);
}
