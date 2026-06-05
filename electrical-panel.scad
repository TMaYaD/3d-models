// Electrical panel - custom distribution enclosure (single-column variant)
// Units: millimetres. Front view (looking AT the wall).
// Origin: bottom-left corner of the wall, floor level.
//   X: along wall horizontal (positive = right)
//   Y: vertical (positive = up)
//   Z: out of the wall (positive = towards the room)
//
// Single 920mm-wide column right of the window. Stabilizer (off-the-shelf,
// on wheels) sits in a notched cutout in the lower-left of the enclosure
// footprint, with its right edge aligned to the mains supply conduit.
// Compact supply zone (mains entry + provisional MCCB + 4-bolt bus on
// insulator) lives in the narrow strip right of the mains conduit.
//
// Layout (front view):
//
//   y=2350  +-----------------------------------+
//           |  Monitoring (2x M30, full width)  |
//           +---------------------+-------------+
//           |                     |             |
//           |  Distribution VTPN  | Solar chain |
//           |  (Output MCCB,      | (AC DB intls|
//           |   central busbar,   |  +Inverter  |
//           |   2x10 MCBs)        |  +Solar IN  |
//           |                     |   intls)    |
//   y=970   +-----------------------+-----------+
//           |                       | 4-bolt    |
//           |   STAB CUTOUT         | bus (top) |
//           |   (open at front      | MCCB prov |
//           |    and bottom)        | Mains ↑   |
//           |                       |           |
//           |   stab rolls in       | slack     |
//           |                       | nests in  |
//           |                       | back-Z    |
//   y=0     +-----------------------+-----------+
//          x=1780                x=2400      x=2700
//
// Cable slack (4x10sqmm stab feed + return) is held in the BACK-Z layer of
// the Supply zone, behind the MCCB and 4-bolt bus.
//
// Off-the-shelf: Stabilizer, Solar Inverter, Solar IN/AC DB internals
//                (DIN-rail components only, no enclosure box),
//                Kincony M30 monitoring boards, MCCBs, 3-phase MCBs.
// Custom build:  Enclosure shell with stab cutout, partitions, doors,
//                compact 4-bolt supply bus on insulator, Distribution VTPN
//                central busbar, cable nest, internal wireways.

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
dbox_int   = [280, 200, 100];   // Solar DB internals (DIN-rail only, no box)
m30        = [160,  90,  65];
mccb       = [150, 250, 150];

// ====== 3-phase MCBs ======
mcb_unit     = [51, 87, 80];
mcb_per_side = 10;

// ====== Enclosure shell ======
enc_w = 950;
enc_x = wall_w - enc_w;    // right edge flush with the wall
enc_y = 0;                 // enclosure sits on floor (cutout opens at bottom)
enc_h = 2400;
enc_d = 350;
enc_t = 8;

// ====== Lower section X split ======
// Lower section is split at supply_x (mains conduit anchor):
//   stab cutout on the left, supply zone (SMB) on the right.
//   Supply zone is exactly stabilizer-tall (= cutout_h).
// Same clearance above the stabilizer as on its side (cutout_w - stab width).
stab_clearance = (supply_x - enc_x) - stabilizer[0];
cutout_x  = enc_x;
cutout_w  = supply_x - enc_x;                       // = 650
cutout_h  = stabilizer[1] + stab_clearance;         // = 1000, supply matches

supply_zone_x = supply_x;
supply_zone_w = enc_x + enc_w - supply_x;   // = 300

// Back-Z slack zone (behind the front-layer Supply equipment)
slack_z_back  = enc_t + 5;       // just in front of the backplate
slack_z_front = 150;             // boundary: front layer starts here (MCCB back face)

// ====== Horizontal bands above the cutout/supply zone ======
// Monitoring is a horizontal band sandwiched between the lower (stab +
// supply) section and the upper (Distribution + Solar) section, full-width.
mon_h   = 160;
mon_y   = cutout_h;                 // monitoring sits directly above stab/supply
upper_y = mon_y + mon_h;            // Distribution + Solar start above monitoring

m30_y       = mon_y + (mon_h - m30[1]) / 2;
m30_pitch   = m30[0] + 30;
m30_block_w = 2 * m30[0] + 30;
m30_x0      = enc_x + (enc_w - m30_block_w) / 2;

// ====== Internal vertical partition (upper section only) ======
// Solar column is wider than the supply column below it; the upper partition
// sits left of supply_x so Solar can fit the inverter / DB internals
// comfortably. The lower stab|supply split stays at supply_x independently.
partition_t = 10;
partition_x = 2322;          // upper-section Distribution|Solar split

// 4-pole MCCB: 127 x 194 x 80, terminal holes 8.5 dia at 35mm pitch,
// 11mm from bottom end (input) and 11mm from top end (output).
mccb2_w         = 127;
mccb2_h         = 194;
mccb2_d         = 80;
mccb2_hole_d    = 8.5;
mccb2_pitch     = 35;
mccb2_holes_n   = 4;
mccb2_first_x   = (mccb2_w - (mccb2_holes_n - 1) * mccb2_pitch) / 2;   // 11
mccb2_y_in      = 11;
mccb2_y_out     = mccb2_h - 11;                                       // 183

// ====== Distribution module (upper-left) ======
dist_x = enc_x;
dist_w = partition_x - dist_x;       // 620
dist_y = upper_y;

// Output MCCB at bottom of central busbar -- same part as the supply MCCB
// so both render via supply_mccb_v2().
dist_mccb       = [mccb2_w, mccb2_h, mccb2_d];
dist_bb_w       = 60;
dist_bb_x       = dist_x + (dist_w - dist_bb_w) / 2;
dist_mccb_x     = dist_bb_x + dist_bb_w / 2 - dist_mccb[0] / 2;
dist_mccb_y     = dist_y + 30;
dist_bb_y       = dist_mccb_y + dist_mccb[1] + 20;
dist_bb_z       = 15;

mcb_left_x      = dist_bb_x - mcb_unit[0] - 30;
mcb_right_x     = dist_bb_x + dist_bb_w + 30;

// Neutral & Ground bars, on either side of the MCB banks. The 3-phase MCBs
// only carry the three phases off the bus; N and G come from these bars.
// Order outside-in: Ground - Neutral - MCB - BUS - MCB - Neutral - Ground.
dist_n_w        = 20;
dist_g_w        = 20;
dist_bar_gap    = 45;       // gap to adjacent MCB / neutral
dist_bar_t      = 15;       // Z thickness
dist_bar_z      = enc_t + 25;

dist_n_l_x      = mcb_left_x - dist_bar_gap - dist_n_w;
dist_g_l_x      = dist_n_l_x - dist_bar_gap - dist_g_w;
dist_n_r_x      = mcb_right_x + mcb_unit[0] + dist_bar_gap;
dist_g_r_x      = dist_n_r_x + dist_n_w + dist_bar_gap;
mcb_block_h     = mcb_per_side * mcb_unit[1];
mcbs_y          = dist_bb_y + 40;
dist_bb_h       = mcb_block_h + 80;          // busbar slightly taller than MCB block
dist_h          = (dist_bb_y - dist_y) + dist_bb_h + 30;

// ====== Solar chain (upper-right) ======
sol_x  = partition_x + partition_t + 10;
sol_w  = enc_x + enc_w - sol_x - enc_t;
acdb_x = sol_x + (sol_w - dbox_int[0]) / 2;
acdb_y = upper_y;
inv_x  = sol_x + (sol_w - inverter[0]) / 2;
inv_y  = acdb_y + dbox_int[1] + 40;
sdb_x  = sol_x + (sol_w - dbox_int[0]) / 2;
sdb_y  = inv_y + inverter[1] + 40;

// =========================================================================
// SUPPLY BUS v2 + MCCB v2 (35mm pole pitch, full part dimensions)
// =========================================================================
// 4 flat copper bars, 22 wide x 194 tall x 5 thick.
// 13mm gap between bars -> pole pitch = 35mm.
// 3 holes per bar (8.5mm dia): one at middle, two at 11mm from each end.
// Two horizontal insulator bars (21mm tall x 21mm deep, full bus width),
// placed BEHIND the copper bars, centered between the hole positions.
bus2_bar_w        = 22;
bus2_bar_h        = 194;
bus2_bar_t        = 5;
bus2_gap          = 13;
bus2_pole_pitch   = bus2_bar_w + bus2_gap;            // 35
bus2_total_w      = 4 * bus2_bar_w + 3 * bus2_gap;    // 127
bus2_hole_d       = 8.5;
bus2_hole_y_lo    = 11;
bus2_hole_y_mid   = bus2_bar_h / 2;                   // 97
bus2_hole_y_hi    = bus2_bar_h - 11;                  // 183
bus2_ins_w        = bus2_total_w;
bus2_ins_h        = 21;
bus2_ins_t        = 21;
bus2_ins_y_lo     = (bus2_hole_y_lo + bus2_hole_y_mid)/2 - bus2_ins_h/2;  // 43.5
bus2_ins_y_hi     = (bus2_hole_y_mid + bus2_hole_y_hi)/2 - bus2_ins_h/2;  // 129.5
bus2_colors       = ["red", "blue", "yellow", "black"];

module supply_bus_v2() {
    // Insulator bars behind the copper bars
    color("ivory") translate([0, bus2_ins_y_lo, 0])
        cube([bus2_ins_w, bus2_ins_h, bus2_ins_t]);
    color("ivory") translate([0, bus2_ins_y_hi, 0])
        cube([bus2_ins_w, bus2_ins_h, bus2_ins_t]);

    // 4 copper bars flush against the front of the insulators
    for (i = [0 : 3]) {
        bar_x = i * bus2_pole_pitch;
        color(bus2_colors[i])
            translate([bar_x, 0, bus2_ins_t])
                difference() {
                    cube([bus2_bar_w, bus2_bar_h, bus2_bar_t]);
                    for (hy = [bus2_hole_y_lo, bus2_hole_y_mid, bus2_hole_y_hi])
                        translate([bus2_bar_w/2, hy, -1])
                            cylinder(h = bus2_bar_t + 2,
                                     d = bus2_hole_d, $fn = 32);
                }
        // RBYN phase label above each bar
        color("white")
            translate([bar_x + bus2_bar_w/2 - 3,
                       bus2_bar_h + 3,
                       bus2_ins_t + bus2_bar_t + 0.1])
                linear_extrude(0.5)
                    text(["R","B","Y","N"][i], size = 10, valign = "bottom");
    }
}

module supply_mccb_v2() {
    color("darkorange", 0.85)
        difference() {
            cube([mccb2_w, mccb2_h, mccb2_d]);
            // input row holes (bottom)
            for (i = [0 : mccb2_holes_n - 1])
                translate([mccb2_first_x + i * mccb2_pitch, mccb2_y_in, -1])
                    cylinder(h = mccb2_d + 2, d = mccb2_hole_d, $fn = 32);
            // output row holes (top)
            for (i = [0 : mccb2_holes_n - 1])
                translate([mccb2_first_x + i * mccb2_pitch, mccb2_y_out, -1])
                    cylinder(h = mccb2_d + 2, d = mccb2_hole_d, $fn = 32);
        }
    color("white")
        translate([5, mccb2_h - 12, mccb2_d + 0.1])
            linear_extrude(0.5) text("MCCB 4P", size = 12, valign = "top");
}

// Combined Supply MCCB Bus: bus at local origin, MCCB stacked above with
// the MCCB input row aligned to the bus top hole row. Treat as a single
// unit when placing into the enclosure.
module supply_mccb_bus() {
    supply_bus_v2();
    translate([0, bus2_hole_y_hi - mccb2_y_in, 0]) supply_mccb_v2();
}

// Locked-unit dimensions of supply_mccb_bus (for placement math)
smb_w = bus2_total_w;                                  // 127
smb_h = (bus2_hole_y_hi - mccb2_y_in) + mccb2_h;       // 172 + 194 = 366
smb_d = max(bus2_ins_t + bus2_bar_t, mccb2_d);         // 80

// Placement of the Supply MCCB Bus unit (origin = lower-left of bus)
smb_pos = [wall_w - 150 - smb_w/2, 400, stabilizer[2] - 110];

// 1mm sheet just behind the Supply MCCB Bus. The gap between this sheet
// and the wall is the cable nest.
smb_back_sheet_t = 1;
smb_zone_w     = enc_w - stabilizer[0];           // supply-zone width
smb_zone_x     = enc_x + stabilizer[0];
smb_back_sheet_margin = (smb_zone_w - smb_w) / 2; // side margin -> also top/bottom
module smb_back_sheet() {
    color("gainsboro")
        translate([smb_zone_x,
                   smb_pos[1] - smb_back_sheet_margin,
                   smb_pos[2] - smb_back_sheet_t])
            cube([smb_zone_w,
                  smb_h + 2 * smb_back_sheet_margin,
                  smb_back_sheet_t]);
}

// ====== Stabilizer (off-the-shelf, sits in cutout) ======
// Ports face RIGHT (towards the supply zone & MCCB). Output @ low Z, Input @ high Z.
stab_x       = enc_x;
stab_y       = 0;
stab_in_z    = stabilizer[2] - 80;
stab_out_z   = 80;
stab_ports_y = 200;

// ====== Window-top conduit row ======
conduit_dia    = 25;
conduit_row_y  = window_top + 200;
conduit_count  = 8;
conduit_pitch  = 60;
conduit_x0     = window_x + (window_w - (conduit_count - 1) * conduit_pitch) / 2;

// ====== Z anchors for cable layers ======
z_front = enc_d - 60;        // front-layer routing (stab FEED, MCCB feed)
z_mid   = 110;               // CT / stab RETURN
z_back  = 20;                // heavy busbar backplate layer

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
        linear_extrude(0.5) text(name, size = 26, valign = "top");
}

// ====== Parametric wire router ======
// Routes a wire from p1 (heading out in dir1) to p2 (arriving heading in dir2).
// dir1, dir2 must be axis-aligned unit vectors (e.g. [0,1,0], [0,0,-1]).
// Path = straight + arc + straight + arc + straight, all 90 deg, bend radius
// defaults to 10*r. Perpendicular dir1/dir2 handles any 3D offset. Parallel
// (same or opposite) cases only handle offsets in the plane of dir1 and one
// perpendicular axis; out-of-plane offset is warned and ignored.
function _vadd(a, b)   = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function _vsub(a, b)   = [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
function _vmul(s, v)   = [s*v[0], s*v[1], s*v[2]];
function _vcross(a, b) = [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]];

module _straight(p, dir, L, r) {
    if (L > 0.001) {
        translate(p)
        // align cylinder (+Z) with dir
        rotate(dir == [0,0, 1] ? [0,0,0]   :
               dir == [0,0,-1] ? [180,0,0] :
               dir == [1,0,0]  ? [0,90,0]  :
               dir == [-1,0,0] ? [0,-90,0] :
               dir == [0,1,0]  ? [-90,0,0] :
                                 [90,0,0])
        cylinder(h=L, r=r, $fn=20);
        // soft cap at start to hide cylinder-arc seam
        translate(p) sphere(r=r, $fn=20);
    } else {
        translate(p) sphere(r=r, $fn=20);
    }
}

// 90-deg arc starting at local origin, entering in dir_in, exiting in dir_out.
// Arc center sits at br*dir_out. End point lands at br*(dir_in+dir_out).
module _arc(dir_in, dir_out, br, r) {
    cax = _vcross(dir_in, dir_out);
    T   = _vmul(br, dir_out);
    multmatrix([
        [-dir_out[0], dir_in[0], cax[0], T[0]],
        [-dir_out[1], dir_in[1], cax[1], T[1]],
        [-dir_out[2], dir_in[2], cax[2], T[2]],
        [0, 0, 0, 1]
    ])
    rotate_extrude(angle=90, $fn=48) translate([br, 0]) circle(r=r, $fn=20);
}

// ====== Generic minimum-arc axis-aligned router ======
// Strategy: enumerate axis-aligned direction sequences of increasing length
// from dir1 to dir2t, with consecutive directions perpendicular. For each
// sequence, solve for non-negative segment lengths satisfying the per-axis
// displacement equation at the user's full bend_r. The first feasible
// sequence wins (minimum arcs). Handles forward, S, U, Z, and overshoot
// topologies uniformly. Capped at MAX_ARCS to keep enumeration finite.

_WIRE_MAX_ARCS = 6;

function _all_dirs() = [[1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]];
function _is_perp_d(a, b) = (a[0]*b[0] + a[1]*b[1] + a[2]*b[2]) == 0;
function _perp_dirs(d)    = [for (e = _all_dirs()) if (_is_perp_d(d, e)) e];

// Sum of (d_i + d_{i+1}) for i = 0..N-1 (arc-displacement coefficients).
function _arc_sum(seq, i = 0) =
    (i >= len(seq) - 1) ? [0,0,0] :
    _vadd(_vadd(seq[i], seq[i+1]), _arc_sum(seq, i+1));

function _first_idx(seq, axis_idx, sign, i = 0) =
    (i >= len(seq)) ? -1 :
    (seq[i][axis_idx] == sign) ? i :
    _first_idx(seq, axis_idx, sign, i+1);

// Per-axis length assignment along the sequence. Each segment is along ONE
// axis so the three axis equations decouple. We put all residual on the
// first segment in the required direction; any feasible non-negative
// assignment is correct. Returns undef if the needed direction is absent.
function _solve_axis(seq, axis_idx, R) =
    let(n = len(seq))
    (abs(R) < 1e-6) ? [for (i = [0:n-1]) 0]
    : (R > 0) ?
        let(idx = _first_idx(seq, axis_idx, 1))
        (idx < 0) ? undef
                  : [for (i = [0:n-1]) (i == idx) ? R : 0]
    :
        let(idx = _first_idx(seq, axis_idx, -1))
        (idx < 0) ? undef
                  : [for (i = [0:n-1]) (i == idx) ? -R : 0];

function _solve_seq(seq, delta, br) =
    let(at = _vmul(br, _arc_sum(seq)))
    let(R  = _vsub(delta, at))
    let(Lx = _solve_axis(seq, 0, R[0]))
    let(Ly = _solve_axis(seq, 1, R[1]))
    let(Lz = _solve_axis(seq, 2, R[2]))
    (is_undef(Lx) || is_undef(Ly) || is_undef(Lz)) ? undef
    : [for (i = [0:len(seq)-1]) Lx[i] + Ly[i] + Lz[i]];

function _gen_seqs(prefix, n, target) =
    let(L = len(prefix))
    (L == n) ? (prefix[L-1] == target ? [prefix] : [])
            : [for (nxt = _perp_dirs(prefix[L-1]))
                 each _gen_seqs(concat(prefix, [nxt]), n, target)];

function _enum_seqs(N, d1, d2t) =
    (N == 0) ? (d1 == d2t ? [[d1]] : [])
            : _gen_seqs([d1], N+1, d2t);

function _sum_list(L, i = 0) = (i >= len(L)) ? 0 : L[i] + _sum_list(L, i+1);

// Among all feasible sequences, pick the one with the smallest total straight
// length. Ties broken by enumeration order. This prefers paths whose arcs
// already cover most of the displacement (so segment legs stay short) over
// paths that overshoot and come back — e.g. the difference between
// [+Y, +X, -Y, -X, +Y] and [+Y, -X, -Y, -X, +Y] for the same endpoints.
function _best_feasible(seqs, delta, br, i = 0, best_total = undef, best = undef) =
    (i >= len(seqs)) ? best :
    let(L = _solve_seq(seqs[i], delta, br))
    is_undef(L) ? _best_feasible(seqs, delta, br, i+1, best_total, best)
    : let(total = _sum_list(L))
      (is_undef(best_total) || total < best_total)
        ? _best_feasible(seqs, delta, br, i+1, total, [seqs[i], L])
        : _best_feasible(seqs, delta, br, i+1, best_total, best);

function _find_path_n(d1, d2t, delta, br, N, max_N) =
    (N > max_N) ? undef :
    let(found = _best_feasible(_enum_seqs(N, d1, d2t), delta, br))
    !is_undef(found) ? found
                     : _find_path_n(d1, d2t, delta, br, N+1, max_N);

module _render_walk(p, seq, lengths, i, br, r) {
    if (i < len(seq)) {
        d = seq[i];
        L = lengths[i];
        _straight(p, d, L, r);
        p_end = _vadd(p, _vmul(L, d));
        if (i < len(seq) - 1) {
            d_next = seq[i + 1];
            translate(p_end) _arc(d, d_next, br, r);
            p_next = _vadd(p_end, _vmul(br, _vadd(d, d_next)));
            _render_walk(p_next, seq, lengths, i + 1, br, r);
        } else {
            translate(p_end) sphere(r=r, $fn=20);
        }
    }
}

module _render_path(p_start, seq, lengths, br, r, col) {
    color(col) union() {
        translate(p_start) sphere(r=r, $fn=20);
        _render_walk(p_start, seq, lengths, 0, br, r);
    }
}

module wire(p1, dir1, p2, dir2, r=2, col="black", bend_r=undef) {
    // dir1, dir2 are TRAVEL directions: both point along the cable's forward
    // tangent. dir1 is the direction the cable leaves p1; dir2 is the
    // direction it arrives at p2 (and would continue, if extended).
    br    = is_undef(bend_r) ? 10*r : bend_r;
    delta = _vsub(p2, p1);
    path  = _find_path_n(dir1, dir2, delta, br, 0, _WIRE_MAX_ARCS);
    if (is_undef(path)) {
        echo(str("WARN wire: no path within ", _WIRE_MAX_ARCS,
                 " arcs at bend_r=", br,
                 " from p1=", p1, " dir1=", dir1,
                 " to p2=", p2, " dir2=", dir2));
    } else {
        _render_path(p1, path[0], path[1], br, r, col);
    }
}


// ====== Multi-core cable on top of wire() ======
// Routes a `cores`-conductor bundle (single fat wire of diameter
// (1 + sqrt(cores)) * d in sheath_col). Per-core wires inside the sheath
// are NOT drawn.
//
// dir1, dir2: travel directions at each endpoint (forward cable tangent).
// Same convention as wire().
//
// Splay (optional) via spread1 / spread2 vectors:
//   spread = [0,0,0]   -> no splay at that end (default)
//   spread = [35,0,0]  -> cores fan along X at 35mm pitch
// Magnitude = pitch, direction = spread axis. Splay length at each end
// defaults to 2 * cores * |spread|, overridable via splay_length1/2.
// At a splayed end the sheath terminates `splay_length` from p_i along
// dir_i (into bundle interior); cores then run straight from their
// per-core start (around coll_i) to per-core end (around p_i).
function _cable_colors(n) =
    n == 5 ? ["red","blue","yellow","black","green"] :
    n == 4 ? ["red","blue","yellow","black"]         :
    n == 3 ? ["red","blue","yellow"]                 :
    n == 2 ? ["red","black"]                         :
            [for (i=[0:n-1]) "black"];

module cable(p1, dir1, p2, dir2, cores=4, d=2,
             colors=undef, sheath_col="black", bend_r=undef,
             spread1=[0,0,0], spread2=[0,0,0],
             splay_length1=undef, splay_length2=undef) {
    cols     = is_undef(colors) ? _cable_colors(cores) : colors;
    R_bundle = (1 + sqrt(cores)) * d / 2;
    s1_mag   = norm(spread1);
    s2_mag   = norm(spread2);
    splen1   = is_undef(splay_length1) ? cores * s1_mag : splay_length1;
    splen2   = is_undef(splay_length2) ? cores * s2_mag : splay_length2;

    // Collection points offset from p1/p2 INTO the cable interior. dir1 is
    // the travel direction leaving p1 (already into the interior); dir2 is
    // the travel direction arriving at p2 (so subtract to step back inside).
    coll1 = (s1_mag == 0) ? p1 : _vadd(p1, _vmul( splen1, dir1));
    coll2 = (s2_mag == 0) ? p2 : _vadd(p2, _vmul(-splen2, dir2));

    // Bundle (sheath only)
    wire(coll1, dir1, coll2, dir2, r=R_bundle, col=sheath_col, bend_r=bend_r);

    // Splay at end 1: cores fan FROM the collection point (coll1) OUT to
    // per-core endpoints (p1 + k*spread1).
    if (s1_mag > 0) {
        for (i = [0 : cores-1]) {
            k = i - (cores - 1) / 2;
            e = _vadd(p1, _vmul(k, spread1));
            color(cols[i]) hull() {
                translate(coll1) sphere(r=d/2, $fn=20);
                translate(e)     sphere(r=d/2, $fn=20);
            }
        }
    }
    // Splay at end 2: cores fan FROM coll2 OUT to per-core endpoints.
    if (s2_mag > 0) {
        for (i = [0 : cores-1]) {
            k = i - (cores - 1) / 2;
            e = _vadd(p2, _vmul(k, spread2));
            color(cols[i]) hull() {
                translate(coll2) sphere(r=d/2, $fn=20);
                translate(e)     sphere(r=d/2, $fn=20);
            }
        }
    }
}

// cable_run: chain cable() calls along a list of waypoints. Each waypoint
// is [p, dir] where dir is the travel direction (forward tangent) of the
// cable at that point. Travel is continuous across waypoints, so each
// waypoint's dir is used as-is by both the prev and next section. Splay
// (spread1/spread2, splay_length1/2) only applies at the run endpoints.
module cable_run(waypoints, cores=4, d=2,
                 colors=undef, sheath_col="black", bend_r=undef,
                 spread1=[0,0,0], spread2=[0,0,0],
                 splay_length1=undef, splay_length2=undef) {
    n = len(waypoints);
    for (i = [0 : n - 2]) {
        a = waypoints[i];
        b = waypoints[i + 1];
        sp1 = (i == 0)     ? spread1 : [0, 0, 0];
        sp2 = (i == n - 2) ? spread2 : [0, 0, 0];
        sl1 = (i == 0)     ? splay_length1 : undef;
        sl2 = (i == n - 2) ? splay_length2 : undef;
        cable(a[0], a[1], b[0], b[1],
              cores=cores, d=d,
              colors=colors, sheath_col=sheath_col, bend_r=bend_r,
              spread1=sp1, spread2=sp2,
              splay_length1=sl1, splay_length2=sl2);
    }
}

// ====== Enclosure shell (with stab cutout) ======
module enclosure_shell() {
    // backplate (full rectangle)
    color("lightgray", 0.85) translate([enc_x, enc_y, 0])
        cube([enc_w, enc_h, enc_t]);
    // outer walls
    color("lightgray", 0.4) {
        // right wall
        translate([enc_x + enc_w - enc_t, enc_y, 0])
            cube([enc_t, enc_h, enc_d]);
        // top wall
        translate([enc_x, enc_y + enc_h - enc_t, 0])
            cube([enc_w, enc_t, enc_d]);
        // left wall (only above the stab cutout)
        translate([enc_x, cutout_h, 0])
            cube([enc_t, enc_h - cutout_h - enc_t, enc_d]);
        // bottom wall (only right of cutout - supply zone has a floor)
        translate([supply_zone_x, enc_y, 0])
            cube([supply_zone_w, enc_t, enc_d]);
        // cutout-supply-zone wall (right wall of cutout / left wall of supply)
        translate([supply_zone_x, enc_y, 0])
            cube([enc_t, cutout_h, enc_d]);
    }
    // partition between Distribution and Solar (upper section only)
    color("lightgray", 0.4)
        translate([partition_x, upper_y, 0])
            cube([partition_t, enc_h - upper_y - enc_t, enc_d - 30]);
    // horizontal shelves
    color("lightgray", 0.4) {
        // bottom of monitoring band (= top of cutout/supply zone).
        // Front layer only; back-Z stays open so slack can pass through.
        translate([enc_x + enc_t, cutout_h, slack_z_front])
            cube([enc_w - 2 * enc_t, 5, enc_d - 30 - slack_z_front]);
        // top of monitoring band = bottom of Distribution + Solar
        translate([enc_x + enc_t, upper_y, 0])
            cube([enc_w - 2 * enc_t, 5, enc_d - 30]);
    }
}

// ====== Doors ======
module enclosure_doors() {
    door_z = enc_d - 4;
    door_t = 3;
    // Stab cutout - open front, no door (label only)
    color("white")
        translate([enc_x + 15, cutout_h - 20, door_z + 0.5])
            linear_extrude(0.5) text("STAB CUTOUT (open)", size = 26, valign = "top");
    // Compact Supply zone door (slack lives in back-Z behind these components)
    color("steelblue", 0.22)
        translate([supply_zone_x + 5, 10, door_z])
            cube([supply_zone_w - 15, cutout_h - 20, door_t]);
    upper_door_h = enc_h - upper_y - enc_t - 10;
    // Distribution Module door (upper left)
    color("orange", 0.22)
        translate([enc_x + 10, upper_y + 5, door_z])
            cube([partition_x - enc_x - 15, upper_door_h, door_t]);
    // Solar chain door (upper right)
    color("plum", 0.22)
        translate([partition_x + partition_t + 5, upper_y + 5, door_z])
            cube([enc_x + enc_w - partition_x - partition_t - 15,
                  upper_door_h, door_t]);
    // Monitoring door (mid band, full width)
    color("seagreen", 0.22)
        translate([enc_x + 10, mon_y + 5, door_z])
            cube([enc_w - 20, mon_h - 10, door_t]);
}

// ====== Solar chain ======
module solar_chain() {
    translate([acdb_x, acdb_y, z_front - dbox_int[2]])
        labeled_box(dbox_int, "AC DB intls", "indianred");
    translate([inv_x, inv_y, z_front - inverter[2]])
        labeled_box(inverter, "INVERTER", "steelblue");
    translate([sdb_x, sdb_y, z_front - dbox_int[2]])
        labeled_box(dbox_int, "Solar IN intls", "indianred");
}

// ====== Distribution Module (VTPN) ======
module distribution_module() {
    // Output MCCB at the bottom of the central busbar -- same module as
    // the supply MCCB for consistency.
    translate([dist_mccb_x, dist_mccb_y, z_front - dist_mccb[2]])
        supply_mccb_v2();
    // Central 4P vertical busbar
    for (i = [0 : 3])
        color("saddlebrown")
            translate([dist_bb_x + i * (dist_bb_w / 4),
                       dist_bb_y, dist_bb_z])
                cube([dist_bb_w / 4 - 2, dist_bb_h, 14]);
    // Left bank of 10 MCBs
    for (i = [0 : mcb_per_side - 1])
        color("white")
            translate([mcb_left_x, mcbs_y + i * mcb_unit[1], enc_t + 20])
                cube([mcb_unit[0] - 2, mcb_unit[1] - 2, mcb_unit[2]]);
    // Right bank of 10 MCBs
    for (i = [0 : mcb_per_side - 1])
        color("white")
            translate([mcb_right_x, mcbs_y + i * mcb_unit[1], enc_t + 20])
                cube([mcb_unit[0] - 2, mcb_unit[1] - 2, mcb_unit[2]]);
    // Neutral bars (one each side, outside the MCB banks)
    for (x = [dist_n_l_x, dist_n_r_x])
        color("black")
            translate([x, mcbs_y, dist_bar_z])
                cube([dist_n_w, mcb_block_h, dist_bar_t]);
    // Ground bars (outermost on each side)
    for (x = [dist_g_l_x, dist_g_r_x])
        color("green")
            translate([x, mcbs_y, dist_bar_z])
                cube([dist_g_w, mcb_block_h, dist_bar_t]);
    color("white")
        translate([dist_x + 10, dist_y + dist_h - 15,
                   enc_t + mcb_unit[2] + 25])
            linear_extrude(0.5) text("DISTRIBUTION (VTPN)", size = 22);
}

// ====== Monitoring compartment ======
module monitoring_module() {
    color("silver")
        translate([enc_x + 30, m30_y + m30[1] - 25, enc_t + 8])
            cube([enc_w - 60, 35, 7]);
    for (i = [0, 1])
        translate([m30_x0 + i * m30_pitch, m30_y, enc_t + 15])
            labeled_box(m30, str("M30 #", i + 1), "navy");
    color("white")
        translate([enc_x + 10, mon_y + mon_h - 12, enc_t + m30[2] + 25])
            linear_extrude(0.5) text("MONITORING", size = 22);
}

// ====== Stabilizer (in cutout) ======
module stabilizer_unit() {
    translate([stab_x, stab_y, 0])
        labeled_box(stabilizer, "STABILIZER", "darkolivegreen");
    color("yellow")
        translate([stab_x + stabilizer[0], stab_ports_y, stab_in_z])
            rotate([0, 90, 0]) cylinder(h = 30, d = 22, $fn = 16);
    color("cyan")
        translate([stab_x + stabilizer[0], stab_ports_y, stab_out_z])
            rotate([0, 90, 0]) cylinder(h = 30, d = 22, $fn = 16);
}

// ====== Mains conduit (descends INTO the ground; emerges at floor level) ======
supply_conduit_depth = 200;   // how far the conduit runs below the floor
module supply_conduit() {
    color("orange")
        translate([supply_x + 30, 0, supply_dia / 2])
            rotate([90, 0, 0])
                cylinder(h = supply_conduit_depth, d = supply_dia, $fn = 32);
    color("black") translate([supply_x + 30, 0, 0])
        cylinder(h = 1, d = supply_dia + 10, $fn = 32);
}

// Top of supply conduit (cable emerges here)
supply_conduit_top = [supply_x + 30, 0, supply_dia / 2];

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

// Conduit top -> Supply MCCB Bus lower row of holes (4-core 4mm cable,
// splay only at the bus end). p2 = mean of lower-row hole positions.
module run_conduit_to_smb_lower() {
    p2 = [smb_pos[0] + (bus2_total_w - bus2_bar_w)/2 + bus2_bar_w/2,
          smb_pos[1] + bus2_hole_y_lo,
          smb_pos[2] + bus2_ins_t + bus2_bar_t];
    cable(supply_conduit_top, [0, 1, 0],
          p2,                 [0, 1, 0],
          cores=4, d=4,
          spread2=[bus2_pole_pitch, 0, 0]);
}

// Supply MCCB output -> Stabilizer input, in three sections:
//   1) From the four MCCB output bolts, rise and tuck back into the
//      cable nest (behind the SMB back sheet).
//   2) Run sideways inside the nest, all the way to the right wall, to
//      build in slack.
//   3) Come back out of the nest, drop down, and into the stabilizer
//      input port on the right face of the stabilizer.
module run_smb_to_stab() {
    // MCCB output bolt row, global center, on the front (+Z) face.
    mccb_out_y = (bus2_hole_y_hi - mccb2_y_in) + mccb2_y_out;
    // Z is nudged to match stab_in_z so section 3 stays in the XY plane;
    // the MCCB output lug accepts this ~4mm offset.
    run_z      = stab_in_z;
    mccb_out_p = [smb_pos[0] + mccb2_w/2,
                  smb_pos[1] + mccb_out_y,
                  run_z];

    // Nest depth (z) -- between back sheet and wall.
    nest_z         = (smb_pos[2] - smb_back_sheet_t) / 2;
    // Bottom edge of the back sheet (in Y).
    backplate_y0   = smb_pos[1] - smb_back_sheet_margin;
    // Left-side exit X inside the backplate area.
    left_exit_x    = smb_zone_x;
    // Right edge of the enclosure, and midway-Y between the backplate
    // bottom and the floor (y = 0).
    right_edge_x   = enc_x + enc_w;
    midway_y       = backplate_y0 / 2;

    // Section 1: MCCB output (splayed) -> left and all the way down to the
    // backplate bottom edge, exiting straight down.
    s1_end    = [left_exit_x,  backplate_y0, mccb_out_p[2]];
    s2_end    = [right_edge_x, midway_y,     mccb_out_p[2]];
    stab_in_p = [stab_x + stabilizer[0], stab_ports_y, stab_in_z];

    cable_run([
        [mccb_out_p, [0,  1, 0]],   // out of MCCB lugs, going up
        [s1_end,     [0, -1, 0]],   // exit backplate bottom, going down
        [s2_end,     [0, -1, 0]],   // bottom-right, going down
        [stab_in_p,  [-1, 0, 0]],   // into stabilizer, going -X
    ], cores=4, d=4,
       spread1=[mccb2_pitch, 0, 0]);
}

// Stabilizer output -> Distribution OUT MCCB input.
// Path: from stab_out into the cable nest, loop around the nest perimeter
// behind the SMB, dive deeper to the backplane layer, run up the left edge
// of the SMB enclosure, across to the OUT MCCB column, drop down, come
// forward to the MCCB front face, and splay into the input row.
module run_stab_to_dist() {
    stab_out_p   = [stab_x + stabilizer[0], stab_ports_y, stab_out_z];

    // Cable nest depth (mid-Z between back sheet and wall).
    nest_z       = (smb_pos[2] - smb_back_sheet_t) / 2;
    // Behind the entire enclosure backplane layer.
    back_z       = enc_t + 8;
    backplate_y0   = smb_pos[1] - smb_back_sheet_margin;


    // Nest perimeter (loop) bounds.
    nest_right_x = enc_x + enc_w - 30;
    nest_left_x  = smb_zone_x + smb_back_sheet_margin;
    nest_top_y   = smb_pos[1] + smb_h + smb_back_sheet_margin / 2;
    nest_bot_y   = smb_pos[1] - smb_back_sheet_margin / 2;

    // OUT MCCB column, with splay bundle anchored 160mm below the input row
    // (>= splay length of cores*pitch = 140).
    mccb_cx       = dist_mccb_x + mccb2_w / 2;
    mccb_anchor_y = dist_mccb_y - 160;
    dist_mccb_in_p = [mccb_cx, dist_mccb_y + mccb2_y_in, z_front];

    // Each waypoint dir = travel direction (forward tangent) at that point.
    cable_run([
        [stab_out_p,                                       [ 1, 0, 0]],
        // Loop perimeter, behind SMB at nest_z:
        [[nest_right_x, stab_out_p[1], stab_out_p[2]],     [ 0, 1, 0]],    // bot-right, turning to +Y
        [[smb_zone_x,  backplate_y0, stab_out_p[2]],       [ 0, 1, 0]],    // up the right side
        // Up into the splay, fanning across the 4 input bolts:
        [dist_mccb_in_p,                                   [ 0, 1, 0]],
    ], cores=4, d=4,
       spread2=[mccb2_pitch, 0, 0]);
}

// Solar feed: enters from left-wall duct, runs along top of wall, drops
// into the Solar IN DB internals from above.
module run_solar_in() {
    p_duct = [0, wall_h - 50, 60];
    p_sdb  = [sdb_x + dbox_int[0] / 2, sdb_y + dbox_int[1] + 2,
              z_front - dbox_int[2] / 2];
    cable_run([
        [p_duct, [ 1,  0, 0]],
        [p_sdb,  [ 0, -1, 0]],
    ], cores=1, d=7, sheath_col="red");
}

// Solar IN DB -> Inverter (DC) via right-column trunk
module run_sdb_to_inv() {
    z = z_front - dbox_int[2] / 2;
    p_out = [sdb_x + dbox_int[0] * 0.5, sdb_y - 2, z];
    p_in  = [inv_x + 50, inv_y - 2, z_front - inverter[2] / 2];
    cable_run([
        [p_out, [0, -1, 0]],
        [p_in,  [0, -1, 0]],
    ], cores=1, d=6, sheath_col="crimson");
}

// Inverter AC out -> AC DB internals
module run_inv_to_acdb() {
    p_inv  = [inv_x + inverter[0] - 50, inv_y - 2, z_front - inverter[2] / 2];
    p_acdb = [acdb_x + dbox_int[0] * 0.5, acdb_y + dbox_int[1] + 2,
              z_front - dbox_int[2] / 2];
    cable_run([
        [p_inv,  [0, -1, 0]],
        [p_acdb, [0, -1, 0]],
    ], cores=1, d=6, sheath_col="purple");
}

// Distribution LEFT bank MCB outputs -> conduits above window.
// Bundled as a single trunk that fans into the MCB row at one end and into
// the conduit row at the other, so it doesn't crisscross the cabinet.
module run_dist_left_to_conduits() {
    mcb_z      = enc_t + 20 + mcb_unit[2] / 2;
    mcbs_cy    = mcbs_y + (mcb_per_side - 1) * mcb_unit[1] / 2
                        + mcb_unit[1] / 2;
    p_mcbs     = [mcb_left_x, mcbs_cy, mcb_z];
    p_conduits = [conduit_x0, conduit_row_y, mcb_z];
    cable_run([
        [p_mcbs,     [-1, 0, 0]],
        [[dist_x-70, conduit_row_y, mcb_z], [-1, 0, 0]],
        [p_conduits, [ -1, 0, 0]],
    ], cores=mcb_per_side, d=3, sheath_col="brown",
       spread1=[0, mcb_unit[1], 0],
       splay_length1=120);
}

// Distribution RIGHT bank MCB outputs -> exit top of enclosure -> left
// wall duct. Single bundle, splayed only at the MCB end.
module run_dist_right_to_duct() {
    mcb_z       = enc_t + 20 + mcb_unit[2] / 2;
    mcbs_cy     = mcbs_y + (mcb_per_side - 1) * mcb_unit[1] / 2
                         + mcb_unit[1] / 2;
    duct_lane_y = wall_h - 80;
    p_mcbs      = [mcb_right_x + mcb_unit[0], mcbs_cy, mcb_z];
    p_duct      = [0, duct_lane_y, 210];
    cable_run([
        [p_mcbs, [ 1, 0, 0]],
        [p_duct, [-1, 0, 0]],
    ], cores=mcb_per_side, d=3, sheath_col="saddlebrown",
       spread1=[0, mcb_unit[1], 0],
       splay_length1=120);
}

// =========================================================================
// DIMENSION ANNOTATIONS (pattern adapted from cabinetry/common.scad)
// =========================================================================
show_dimensions = true;
dim_z           = enc_d + 25;
dim_text_h      = 50;
dim_text_thk    = 2;

module dim_h(x1, x2, y_anchor, label, off=-100, text_size=undef) {
    ts = text_size == undef ? dim_text_h : text_size;
    yd = y_anchor + off;
    color("orange", 0.7) {
        hull() {
            translate([x1, yd, dim_z]) sphere(d=3, $fn=12);
            translate([x2, yd, dim_z]) sphere(d=3, $fn=12);
        }
        hull() {
            translate([x1, y_anchor, dim_z]) sphere(d=4, $fn=12);
            translate([x1, yd,       dim_z]) sphere(d=4, $fn=12);
        }
        hull() {
            translate([x2, y_anchor, dim_z]) sphere(d=4, $fn=12);
            translate([x2, yd,       dim_z]) sphere(d=4, $fn=12);
        }
    }
    color("red")
        translate([(x1 + x2) / 2,
                   yd + (off >= 0 ? ts*0.7 : -ts*0.7), dim_z])
            linear_extrude(dim_text_thk)
                text(label, size=ts, halign="center", valign="center");
}

// Depth dim drawn along the Z axis. Anchored at (x_anchor, y_anchor) on
// the front face, the dim line floats `off` further in -Y (below the
// anchor) and runs from z1 to z2. Text lies flat in the XZ plane so it
// reads along the depth direction.
module dim_d(z1, z2, x_anchor, y_anchor, label, off=-100, text_size=undef) {
    ts = text_size == undef ? dim_text_h : text_size;
    yd = y_anchor + off;
    color("orange", 0.7) {
        hull() {
            translate([x_anchor, yd, z1]) sphere(d=3, $fn=12);
            translate([x_anchor, yd, z2]) sphere(d=3, $fn=12);
        }
        hull() {
            translate([x_anchor, y_anchor, z1]) sphere(d=4, $fn=12);
            translate([x_anchor, yd,       z1]) sphere(d=4, $fn=12);
        }
        hull() {
            translate([x_anchor, y_anchor, z2]) sphere(d=4, $fn=12);
            translate([x_anchor, yd,       z2]) sphere(d=4, $fn=12);
        }
    }
    color("red")
        translate([x_anchor, yd + (off >= 0 ? ts*0.7 : -ts*0.7), (z1+z2)/2])
            rotate([90, 0, 90])
                linear_extrude(dim_text_thk)
                    text(label, size=ts, halign="center", valign="center");
}

module dim_v(y1, y2, x_anchor, label, off=-100, text_size=undef) {
    ts = text_size == undef ? dim_text_h : text_size;
    xd = x_anchor + off;
    color("orange", 0.7) {
        hull() {
            translate([xd, y1, dim_z]) sphere(d=3, $fn=12);
            translate([xd, y2, dim_z]) sphere(d=3, $fn=12);
        }
        hull() {
            translate([x_anchor, y1, dim_z]) sphere(d=4, $fn=12);
            translate([xd,       y1, dim_z]) sphere(d=4, $fn=12);
        }
        hull() {
            translate([x_anchor, y2, dim_z]) sphere(d=4, $fn=12);
            translate([xd,       y2, dim_z]) sphere(d=4, $fn=12);
        }
    }
    color("red")
        translate([xd + (off >= 0 ? ts*0.7 : -ts*0.7),
                   (y1 + y2) / 2, dim_z])
            rotate([0, 0, 90])
                linear_extrude(dim_text_thk)
                    text(label, size=ts, halign="center", valign="center");
}

module dimensions() {
    // Overall enclosure W & H
    dim_h(enc_x, enc_x + enc_w, enc_y + enc_h, str("ENC ", enc_w),
          off=90, text_size=60);
    dim_v(enc_y, enc_y + enc_h, enc_x + enc_w, str(enc_h),
          off=90, text_size=60);

    // Lower-section X split (stab cutout vs supply zone widths)
    dim_h(enc_x, supply_x, enc_y, str("Cutout ", cutout_w),
          off=-110, text_size=38);
    dim_h(supply_x, enc_x + enc_w, enc_y, str("Sup ", supply_zone_w),
          off=-110, text_size=38);

    // Upper-section X split (Distribution vs Solar widths)
    dim_h(enc_x, partition_x, upper_y, str("Dist ", dist_w),
          off=-40, text_size=38);
    dim_h(partition_x + partition_t, enc_x + enc_w, upper_y,
          str("Sol ", enc_x + enc_w - partition_x - partition_t),
          off=-40, text_size=38);

    // Band heights (right side, stepped offsets so they don't overlap)
    bands_x = enc_x + enc_w;
    upper_h = enc_h - upper_y - enc_t;
    dim_v(enc_y, cutout_h, bands_x, str("Cutout ", cutout_h),
          off=210, text_size=38);
    dim_v(mon_y, mon_y + mon_h, bands_x, str("Mon ", mon_h),
          off=210, text_size=38);
    dim_v(upper_y, upper_y + upper_h, bands_x, str("Upper ", upper_h),
          off=210, text_size=38);

    // Enclosure depth (bottom-right corner, extending in -Y below the floor).
    dim_d(0, enc_d, enc_x + enc_w, enc_y, str("D ", enc_d),
          off=-110, text_size=38);
}

// =========================================================================
// RENDER
// =========================================================================
    // Supply MCCB Bus (placement = smb_pos)
    translate(smb_pos) supply_mccb_bus();
    smb_back_sheet();
    wall_panel();
    grid();
    window_cutout();

    enclosure_shell();
    solar_chain();
    distribution_module();
    monitoring_module();

    stabilizer_unit();
    supply_conduit();
    conduit_row();
    
    run_conduit_to_smb_lower();
    run_smb_to_stab();
    run_stab_to_dist();
    run_solar_in();
    run_sdb_to_inv();
    run_inv_to_acdb();
    run_dist_left_to_conduits();
    run_dist_right_to_duct();

    enclosure_doors();

    if (show_dimensions) dimensions();

// =========================================================================
// ECHO SUMMARY
// =========================================================================
echo(str("Enclosure   : ", [enc_x, enc_y], " size ", [enc_w, enc_h, enc_d]));
echo(str("  Stab cutout  x=", enc_x,         "..", supply_x,
         " y=0..", cutout_h));
echo(str("  Supply zone  x=", supply_x,      "..", enc_x + enc_w,
         " y=0..", cutout_h));
echo(str("  Cable nest   (back-Z slack in Supply zone, z=",
         slack_z_back, "..", slack_z_front, ")"));
echo(str("  Distribution x=", dist_x,        "..", partition_x,
         " y=", dist_y, "..", dist_y + dist_h));
echo(str("  Solar chain  x=", sol_x,         "..", enc_x + enc_w,
         " y=", upper_y, "..", sdb_y + dbox_int[1]));
echo(str("  Monitoring   y=", mon_y,         "..", mon_y + mon_h,
         " (full width)"));
echo(str("Mains conduit @ x=", supply_x + 30));
echo(str("Stab ports at y=", stab_ports_y));