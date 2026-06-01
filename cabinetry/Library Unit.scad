use <common.scad>

// Library Unit
// Layout (top to bottom):
//   - 38mm wood top panel (full width)
//   - 3 loft units (wood carcass, lift-up glass doors), flanked by
//     2x 25mm wood end panels                                    [305mm deep]
//   - 25mm wood divider panel (full width)
//   - 2 display units (white carcass, double glass doors), each
//     flanked by 25mm wood panels on both sides (4 panels total) [305mm deep]
//   - 38mm wood desk panel (full width)                          [610mm deep]
//   - 4 columns of 5 drawers + 2 columns of single tall drawer,
//     separated and bookended by 25mm wood panels                [610mm deep]

// --- Top-level dimensions ---
// Display row sets total width: 4 panels + 2 displays + open gap between
// the inner panels (knee space, mirrored in the drawer row below).
display_w     = 1185;
display_gap   = 1755;
base_depth    = 610;
upper_depth   = 305;

// --- Row heights ---
toe_kick_h       = 75;
toe_kick_setback = 50;    // recess depth from the cabinet's visible front
drawer_h       = 102 + 102 + 152 + 152 + 152;   // 660
desk_th        = 38;
display_h      = 1590;
mid_panel_h    = 25;
loft_h         = 530;
top_panel_h    = 37;

total_height = toe_kick_h + drawer_h + desk_th + display_h + mid_panel_h
             + loft_h + top_panel_h;

// --- Common ---
wall_thickness = 14;
frame_t        = 25;     // walnut trim panel thickness
door_transparency = 1.0;

// Overlay door thicknesses. `base_depth` / `upper_depth` are the visible
// outer depth (panels + door front). Carcasses are sunk back by the door
// thickness so panel fronts sit flush with door fronts without growing
// the overall depth.
drawer_overlay  = 14;
glass_overlay   = 13;
base_panel_d    = base_depth;                       // 610
upper_panel_d   = upper_depth;                      // 305
carcass_base_d  = base_depth  - drawer_overlay;     // 591
carcass_upper_d = upper_depth - glass_overlay;      // 292

// --- Row widths ---
// Right-side filler so the drawer row reaches the wall: a tall single
// drawer plus a 25mm wood panel beside it. The upper rows (display, mid
// divider, loft, top) stay at the original `main_width`; only the
// drawer row and desk + toe kick extend to `total_width`.
extension_drawer_w = 210;
extension_w        = extension_drawer_w + frame_t;                // 235

main_width  = 4*frame_t + 2*display_w + display_gap;              // 4225
total_width = main_width + extension_w;                           // 4460

// Drawer row: 4 end/inter panels + 4 drawer columns + 2 single columns,
// sized to the main width (extension is added on the right separately).
single_col_w = display_gap / 2;                                   // 877.5
drawer_col_w = (main_width - 4*frame_t - 2*single_col_w) / 4;     // 592.5

// Loft row: 2 end panels + outer loft (matches display_w) + center loft
// (spans the two displays' inner panels + knee gap) + outer loft.
loft_side_w   = display_w;                                        // 1185
loft_center_w = 2*frame_t + display_gap;                          // 1805

// Full-width horizontal panels (desk, mid divider, top) split into 3
// sections at the display row's inner panels. Seams are derived from the
// main layout so they are unaffected by the right extension.
panel_seam_l = frame_t + display_w;                               // 1210
panel_seam_r = panel_seam_l + 2*frame_t + display_gap;            // 3015

// Center window niche: the four panels surrounding the central knee gap
// (desk center, mid divider center, both inner display panels) extend
// `window_back` past the cabinet back so the window sits flush in the
// niche.
window_back = 80;

$fn = 32;

walnut = [0.45, 0.25, 0.15];
white  = [0.97, 0.97, 0.97];

// Exploded view: rows lift apart in Z, panels/units splay outward in X,
// doors and drawer fronts push forward in Y. explode = 0 → assembled.
explode = 400;

// --- Z positions of each row's bottom (with row-level explode lift) ---
z_toe     = 0;
z_drawer  = toe_kick_h + explode;
z_desk    = z_drawer + drawer_h     + explode;
z_display = z_desk    + desk_th     + explode;
z_mid     = z_display + display_h   + explode;
z_loft    = z_mid     + mid_panel_h + explode;
z_top     = z_loft    + loft_h      + explode;

// =====================================================================
// Components
// =====================================================================

module wood_panel(x, z, w, h, d) {
    color(walnut) translate([x, 0, z]) cube([w, d, h]);
}

// Splits a full-width horizontal panel into 3 sections along the display
// row's inner-panel seams, with per-section X explode splay. Optional
// insets shrink the side sections (used by the mid divider so it doesn't
// overlap the merged upper end panels).
module split_horizontal_panel(z, h, d, left_inset = 0, right_inset = 0,
                              center_back_extend = 0,
                              annotate_center_depth = false,
                              annotate_widths = false,
                              right_edge = total_width) {
    ex      = [-1, 0, 1] * explode;
    left_w  = panel_seam_l - left_inset;
    cent_w  = panel_seam_r - panel_seam_l;
    right_w = right_edge   - panel_seam_r - right_inset;

    translate([left_inset + ex[0], 0, z]) {
        color(walnut) cube([left_w, d, h]);
        if (annotate_widths)
            dimension([0, 0, h], [left_w, 0, h], str(left_w), [0, 0, 254]);
    }

    // Center section extends back into the window niche.
    translate([panel_seam_l + ex[1], -center_back_extend, z]) {
        color(walnut) cube([cent_w, d + center_back_extend, h]);
        if (annotate_center_depth) {
            d_total = d + center_back_extend;
            dimension([0, 0, h], [0, d_total, h],
                      str("D: ", d_total), [0, 0, 254]);
        }
        if (annotate_widths)
            dimension([0, 0, h], [cent_w, 0, h], str(cent_w), [0, 0, 254]);
    }

    translate([panel_seam_r + ex[2], 0, z]) {
        color(walnut) cube([right_w, d, h]);
        if (annotate_widths)
            dimension([0, 0, h], [right_w, 0, h], str(right_w), [0, 0, 254]);
    }
}

module glass_door(dw, dh) {
    // Anodized white aluminium frame
    color([0.92, 0.92, 0.92, door_transparency])
    difference() {
        cube([dw, 13, dh]);
        translate([38, -3, 38])
        cube([dw - 76, 18, dh - 76]);
    }
    // Transparent glass
    color([0.5, 0.8, 1.0, door_transparency * 0.2])
    translate([38, 5, 38])
    cube([dw - 76, 3, dh - 76]);
}

// ---- Drawer column (per-column carcass; fronts overlaid in front) ----
// `seam` tells which side meets a neighboring column: that side's drawer
// front runs flush (no margin) so adjacent fronts butt up and hide the
// shared carcass walls behind them.
module drawer_column_5(w, seam = "none", annotate = false) {
    h1 = 102; h2 = 102; h3 = 152; h4 = 152; h5 = 152;
    margin = 3;
    x_left  = (seam == "left")  ? 0 : margin;
    x_right = (seam == "right") ? 0 : margin;
    front_w = w - x_left - x_right;

    color(white)
    carcass(w, carcass_base_d, drawer_h, wall_th=wall_thickness);

    // Drawer fronts overlaid on the carcass front face.
    translate([0, carcass_base_d + explode, 0]) {
        translate([x_left, 0, margin])
            drawer_front(front_w, h5, col=white, depth=drawer_overlay, trans=door_transparency, handle_w=203);
        translate([x_left, 0, h5 + margin])
            drawer_front(front_w, h4, col=white, depth=drawer_overlay, trans=door_transparency, handle_w=203);
        translate([x_left, 0, h5 + h4 + margin])
            drawer_front(front_w, h3, col=white, depth=drawer_overlay, trans=door_transparency, handle_w=203);
        translate([x_left, 0, h5 + h4 + h3 + margin])
            drawer_front(front_w, h2, col=white, depth=drawer_overlay, trans=door_transparency, handle_w=203);
        translate([x_left, 0, h5 + h4 + h3 + h2 + margin])
            drawer_front(front_w, h1, col=white, depth=drawer_overlay, trans=door_transparency, handle_w=203);
    }

    if (annotate)
        dimension([0, base_depth, drawer_h], [w, base_depth, drawer_h],
                  str(w), [0, 127, 127]);
}

// ---- Single drawer column ----
// One short drawer at the top of the column (height matches h1 of the
// 5-stack so all drawer tops align). Below the drawer is open knee space.
module drawer_column_single(w, seam = "none", annotate = false) {
    margin = 3;
    drawer_face_h = 102;                // matches h1 in drawer_column_5
    bottom_t = 3;
    top_t = wall_thickness;
    carcass_h = drawer_face_h + bottom_t + top_t;
    carcass_z = drawer_h - carcass_h;

    x_left  = (seam == "left")  ? 0 : margin;
    x_right = (seam == "right") ? 0 : margin;
    front_w = w - x_left - x_right;

    // Short carcass hugging just the drawer; open knee space below.
    color(white)
    translate([0, 0, carcass_z]) {
        cube([w, carcass_base_d, bottom_t]);
        translate([0, 0, carcass_h - top_t]) cube([w, carcass_base_d, top_t]);
        cube([wall_thickness, carcass_base_d, carcass_h]);
        translate([w - wall_thickness, 0, 0])
            cube([wall_thickness, carcass_base_d, carcass_h]);
        translate([wall_thickness, 0, bottom_t])
            cube([w - 2*wall_thickness, wall_thickness, carcass_h - bottom_t - top_t]);
    }

    // Drawer front overlaid, top-aligned with the 5-stack's h1 drawer.
    translate([x_left, carcass_base_d + explode, drawer_h - drawer_face_h + margin])
        drawer_front(front_w, drawer_face_h, col=white,
                     depth=drawer_overlay, trans=door_transparency, handle_w=152);

    if (annotate)
        dimension([0, base_depth, drawer_h], [w, base_depth, drawer_h],
                  str(w), [0, 127, 127]);
}

// ---- Tall single drawer column ----
// One floor-to-desk drawer face (no internal seam) for the right filler
// section. Full-height carcass, unlike drawer_column_single which sits
// only at the top with knee space below.
module drawer_column_tall(w, annotate = false) {
    margin = 3;
    color(white)
    carcass(w, carcass_base_d, drawer_h, wall_th=wall_thickness);

    translate([margin, carcass_base_d + explode, margin])
        drawer_front(w - 2*margin, drawer_h - 2*margin,
                     col=white, depth=drawer_overlay,
                     trans=door_transparency, handle_w=152);

    if (annotate)
        dimension([0, base_depth, drawer_h], [w, base_depth, drawer_h],
                  str(w), [0, 127, 127]);
}

// ---- Display unit (white carcass + double glass doors) ----
module display_unit(w, annotate = false) {
    d = carcass_upper_d;
    h = display_h;

    // White carcass
    color(white)
    carcass(w, d, h, wall_th=wall_thickness);

    // 3 adjustable shelves
    shelf_t = 19;
    n_shelves = 3;
    spacing = (h - 2*wall_thickness - n_shelves*shelf_t) / (n_shelves + 1);
    color(white)
    for (i = [1:n_shelves]) {
        z = wall_thickness + i*spacing + (i-1)*shelf_t;
        translate([wall_thickness, wall_thickness, z])
        cube([w - 2*wall_thickness, d - 25 - wall_thickness, shelf_t]);
    }

    // Two glass doors overlaid on the carcass front face (full unit width).
    door_h = h;
    door_w = w / 2;
    translate([0,     d + explode, 0]) glass_door(door_w, door_h);
    translate([w/2,   d + explode, 0]) glass_door(door_w, door_h);

    if (annotate)
        dimension([0, upper_depth, h], [w, upper_depth, h], str(w), [0, 127, 127]);
}

// ---- Loft unit (walnut carcass + lift-up glass door) ----
module loft_unit(w, annotate = false) {
    d = carcass_upper_d;
    h = loft_h;

    color(walnut)
    carcass(w, d, h, wall_th=wall_thickness);

    // Single lift-up glass door overlaid on the carcass front face.
    translate([0, d + explode, 0]) glass_door(w, h);

    if (annotate)
        dimension([0, upper_depth, h], [w, upper_depth, h], str(w), [0, 127, 127]);
}

// =====================================================================
// Physical items — each row is its own module that places geometry and
// (when annotate=true) emits its own dimension annotations.
// =====================================================================

// Helper: a full-height drawer-row end/divider panel + its annotations.
// `side` = "left" / "right" adds height + depth labels far enough outside
// the row-level annotations to remain visible.
module drawer_row_panel(annotate, side = "none") {
    panel_z = z_drawer - toe_kick_h;
    panel_h = drawer_h + toe_kick_h;
    color(walnut) translate([0, 0, panel_z]) cube([frame_t, base_panel_d, panel_h]);
    if (annotate) {
        // Width label sits above the row's top edge, clear of geometry.
        dimension([0, base_depth, panel_z + panel_h],
                  [frame_t, base_depth, panel_z + panel_h],
                  str(frame_t), [0, 127, 127]);
        if (side == "left") {
            dimension([0, 0, panel_z], [0, 0, panel_z + panel_h],
                      str("H: ", panel_h), [-1270, 0, 0]);
            dimension([0, base_panel_d, panel_z], [0, 0, panel_z],
                      str("D: ", base_panel_d), [-1270, 0, 0]);
        } else if (side == "right") {
            dimension([frame_t, 0, panel_z], [frame_t, 0, panel_z + panel_h],
                      str("H: ", panel_h), [1270, 0, 0]);
            dimension([frame_t, base_panel_d, panel_z], [frame_t, 0, panel_z],
                      str("D: ", base_panel_d), [1270, 0, 0]);
        }
    }
}

module drawer_row(annotate = false) {
    // Layout: P | D D | P | S S | P | D D | P | T | P  (12 pieces).
    // Trailing T = tall single drawer, plus a final 25mm panel cover the
    // right-side filler gap to the wall.
    x0  = 0;
    x1  = x0 + frame_t;
    x2  = x1 + 2*drawer_col_w;
    x3  = x2 + frame_t;
    x4  = x3 + 2*single_col_w;
    x5  = x4 + frame_t;
    x6  = x5 + 2*drawer_col_w;
    x7  = x6 + frame_t;                          // tall drawer starts (= main_width)
    x8  = x7 + extension_drawer_w;               // final filler panel starts

    ex = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7] * explode;

    translate([x0                + ex[0], 0, 0])        drawer_row_panel(annotate, side="left");
    translate([x1                + ex[1], 0, z_drawer]) drawer_column_5(drawer_col_w, seam="right", annotate=annotate);
    translate([x1 + drawer_col_w + ex[2], 0, z_drawer]) drawer_column_5(drawer_col_w, seam="left",  annotate=annotate);
    translate([x2                + ex[3], 0, 0])        drawer_row_panel(annotate);
    translate([x3                + ex[4], 0, z_drawer]) drawer_column_single(single_col_w, seam="right", annotate=annotate);
    translate([x3 + single_col_w + ex[5], 0, z_drawer]) drawer_column_single(single_col_w, seam="left",  annotate=annotate);
    translate([x4                + ex[6], 0, 0])        drawer_row_panel(annotate);
    translate([x5                + ex[7], 0, z_drawer]) drawer_column_5(drawer_col_w, seam="right", annotate=annotate);
    translate([x5 + drawer_col_w + ex[8], 0, z_drawer]) drawer_column_5(drawer_col_w, seam="left",  annotate=annotate);
    translate([x6                + ex[9], 0, 0])        drawer_row_panel(annotate);
    translate([x7                + ex[10], 0, z_drawer]) drawer_column_tall(extension_drawer_w, annotate=annotate);
    translate([x8                + ex[11], 0, 0])        drawer_row_panel(annotate, side="right");

    if (annotate) {
        dimension([0, 0, z_drawer], [0, 0, z_drawer + drawer_h], str("Drawers: ", drawer_h), [-508, 0, 0]);
        dimension([total_width, base_depth, z_drawer], [total_width, 0, z_drawer],
                  str("Base Depth: ", base_depth), [508, 0, 0]);
    }
}

module desk_panel(annotate = false) {
    split_horizontal_panel(z_desk, desk_th, base_panel_d,
                           center_back_extend=window_back,
                           annotate_center_depth=annotate,
                           annotate_widths=annotate);

    if (annotate) {
        dimension([0, 0, z_desk], [0, 0, z_desk + desk_th], str("Desk: ", desk_th), [-762, 0, 0]);
        dimension([0, base_depth, z_desk], [total_width, base_depth, z_desk],
                  str("Total Width: ", total_width), [0, 254, 0]);
    }
}

module display_row_panel(annotate, side = "none", back_extend = 0,
                         annotate_depth = false) {
    color(walnut) translate([0, -back_extend, z_display])
        cube([frame_t, upper_panel_d + back_extend, display_h]);

    if (annotate_depth) {
        d_total = upper_panel_d + back_extend;
        dimension([0, -back_extend,  z_display + display_h],
                  [0, upper_panel_d, z_display + display_h],
                  str("D: ", d_total), [-254, 0, 0]);
    }
    if (annotate) {
        dimension([0, upper_depth, z_display + display_h],
                  [frame_t, upper_depth, z_display + display_h],
                  str(frame_t), [0, 127, 127]);
        if (side == "left") {
            dimension([0, 0, z_display], [0, 0, z_display + display_h],
                      str("H: ", display_h), [-1270, 0, 0]);
            dimension([0, upper_panel_d, z_display], [0, 0, z_display],
                      str("D: ", upper_panel_d), [-1270, 0, 0]);
        } else if (side == "right") {
            dimension([frame_t, 0, z_display], [frame_t, 0, z_display + display_h],
                      str("H: ", display_h), [1270, 0, 0]);
            dimension([frame_t, upper_panel_d, z_display], [frame_t, 0, z_display],
                      str("D: ", upper_panel_d), [1270, 0, 0]);
        }
    }
}

module display_row(annotate = false) {
    // Layout: DISP | P | <gap> | P | DISP  (outer end panels merged into
    // upper_end_panel and placed separately).
    px1 = frame_t;
    px2 = frame_t + display_w;
    px3 = px2 + frame_t + display_gap;
    px4 = px3 + frame_t;

    ex = [-2, -1, 1, 2] * explode;

    translate([px1 + ex[0], 0, z_display]) display_unit(display_w, annotate=annotate);
    translate([px2 + ex[1], 0, 0])         display_row_panel(annotate, back_extend=window_back);
    translate([px3 + ex[2], 0, 0])         display_row_panel(annotate, back_extend=window_back, annotate_depth=annotate);
    translate([px4 + ex[3], 0, z_display]) display_unit(display_w, annotate=annotate);

    if (annotate) {
        dimension([0, 0, z_display], [0, 0, z_display + display_h], str("Display: ", display_h), [-508, 0, 0]);
        dimension([total_width, upper_depth, z_display], [total_width, 0, z_display],
                  str("Upper Depth: ", upper_depth), [508, 0, 0]);
    }
}

module mid_divider(annotate = false) {
    split_horizontal_panel(z_mid, mid_panel_h, upper_panel_d,
                           left_inset=frame_t, right_inset=frame_t,
                           center_back_extend=window_back,
                           annotate_widths=annotate,
                           right_edge=main_width);

    if (annotate) {
        dimension([0, 0, z_mid], [0, 0, z_mid + mid_panel_h], str("Mid: ", mid_panel_h), [-762, 0, 0]);
    }
}

module loft_row_panel(annotate, side = "none") {
    color(walnut) translate([0, 0, z_loft]) cube([frame_t, upper_panel_d, loft_h]);
    if (annotate) {
        dimension([0, upper_depth, z_loft + loft_h],
                  [frame_t, upper_depth, z_loft + loft_h],
                  str(frame_t), [0, 127, 127]);
        if (side == "left") {
            dimension([0, 0, z_loft], [0, 0, z_loft + loft_h],
                      str("H: ", loft_h), [-1270, 0, 0]);
            dimension([0, upper_panel_d, z_loft], [0, 0, z_loft],
                      str("D: ", upper_panel_d), [-1270, 0, 0]);
        } else if (side == "right") {
            dimension([frame_t, 0, z_loft], [frame_t, 0, z_loft + loft_h],
                      str("H: ", loft_h), [1270, 0, 0]);
            dimension([frame_t, upper_panel_d, z_loft], [frame_t, 0, z_loft],
                      str("D: ", upper_panel_d), [1270, 0, 0]);
        }
    }
}

module loft_row(annotate = false) {
    // Layout: L_side | L_center | L_side  (outer end panels merged into
    // upper_end_panel and placed separately).
    lx1 = frame_t;
    lx2 = lx1 + loft_side_w;
    lx3 = lx2 + loft_center_w;

    ex = [-1, 0, 1] * explode;

    translate([lx1 + ex[0], 0, z_loft]) loft_unit(loft_side_w,   annotate=annotate);
    translate([lx2 + ex[1], 0, z_loft]) loft_unit(loft_center_w, annotate=annotate);
    translate([lx3 + ex[2], 0, z_loft]) loft_unit(loft_side_w,   annotate=annotate);

    if (annotate)
        dimension([0, 0, z_loft], [0, 0, z_loft + loft_h], str("Loft: ", loft_h), [-508, 0, 0]);
}

// Top panel is fabricated on-site to fit the ceiling — factory skips it.
// `%` renders it as a transparent ghost so the design intent is still
// readable without the factory shipping the part.
module top_panel(annotate = false) {
    %split_horizontal_panel(z_top, top_panel_h, upper_panel_d,
                            annotate_widths=annotate,
                            right_edge=main_width);
}

// Merged outer side panel spanning display row + mid divider gap + loft
// row, fabricated as one tall piece. Anchored to z_display so it doesn't
// pull apart with the row-by-row Z explode lifts.
module upper_end_panel(annotate = false, side = "left") {
    panel_h = display_h + mid_panel_h + loft_h;
    color(walnut) translate([0, 0, z_display]) cube([frame_t, upper_panel_d, panel_h]);
    if (annotate) {
        dimension([0, upper_depth, z_display + panel_h],
                  [frame_t, upper_depth, z_display + panel_h],
                  str(frame_t), [0, 127, 127]);
        if (side == "left") {
            dimension([0, 0, z_display], [0, 0, z_display + panel_h],
                      str("H: ", panel_h), [-1270, 0, 0]);
            dimension([0, upper_panel_d, z_display], [0, 0, z_display],
                      str("D: ", upper_panel_d), [-1270, 0, 0]);
        } else if (side == "right") {
            dimension([frame_t, 0, z_display], [frame_t, 0, z_display + panel_h],
                      str("H: ", panel_h), [1270, 0, 0]);
            dimension([frame_t, upper_panel_d, z_display], [frame_t, 0, z_display],
                      str("D: ", upper_panel_d), [1270, 0, 0]);
        }
    }
}

module upper_end_panels(annotate = false) {
    // Splay matches the outermost ranks of the old display-row end panels
    // (±3) so the merged panel sits further out than the inner display
    // unit (rank ±2) in exploded view, instead of being engulfed by it.
    // Right panel anchored to main_width so the upper section doesn't
    // stretch into the drawer-row right extension.
    ex = [-3, 3] * explode;
    translate([0                   + ex[0], 0, 0]) upper_end_panel(annotate, side="left");
    translate([main_width - frame_t + ex[1], 0, 0]) upper_end_panel(annotate, side="right");
}

// Toe kick under the two 5-drawer banks (left & right). The middle knee
// space is left open. Each section has:
//   - Vertical toe kick: full toe-kick height, set back from the visible
//     drawer-row front by `toe_kick_setback`.
//   - Faux panel: horizontal 25mm board flush with the drawer carcass
//     underside, covering the otherwise-exposed bottom between the toe
//     kick and the visible front.
module toe_kick(annotate = false) {
    front_y = base_panel_d;                          // 629
    toe_t   = 19;                                    // toe kick thickness
    faux_t  = frame_t;                               // 25mm, like other panels

    toe_y   = front_y - toe_kick_setback - toe_t;    // 554
    faux_y  = front_y - toe_kick_setback;            // 579
    faux_z  = z_toe + toe_kick_h - faux_t;           // top flush w/ carcass

    ex      = [-1, 1] * explode;
    left_w  = panel_seam_l;                          // 0 .. left inner panel
    right_w = total_width - panel_seam_r;            // right inner panel .. end

    // Left base section
    translate([ex[0], 0, 0]) {
        color(walnut) translate([0, toe_y, z_toe])  cube([left_w, toe_t, toe_kick_h]);
        color(walnut) translate([0, faux_y, faux_z]) cube([left_w, toe_kick_setback, faux_t]);
        // Annotation rides inside the same translate; positioned at the
        // toe kick's front face so the dim line sits near the geometry.
        if (annotate)
            dimension([0, front_y, z_toe], [0, front_y, z_toe + toe_kick_h],
                      str("Toe: ", toe_kick_h), [-1270, 0, 0]);
    }

    // Right base section
    translate([panel_seam_r + ex[1], 0, 0]) {
        color(walnut) translate([0, toe_y, z_toe])  cube([right_w, toe_t, toe_kick_h]);
        color(walnut) translate([0, faux_y, faux_z]) cube([right_w, toe_kick_setback, faux_t]);
    }
}

// =====================================================================
// Top-level assembly. Flip `annotate` true to show all dimensions.
// =====================================================================
annotate = true;

toe_kick(annotate);
drawer_row(annotate);
desk_panel(annotate);
upper_end_panels(annotate);
display_row(annotate);
mid_divider(annotate);
loft_row(annotate);
top_panel(annotate);
