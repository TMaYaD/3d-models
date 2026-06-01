// Common OpenSCAD Cabinetry Library

module handle(w, trans=1.0) {
    // A simple black metallic pull handle
    color([0.1, 0.1, 0.1, trans])
    translate([-w/2, 0, 0])
    union() {
        cube([w, 13, 13]); // main grip bar
        // standoffs attaching to drawer front
        translate([25, -13, 0]) cube([13, 13, 13]);
        translate([w-38, -13, 0]) cube([13, 13, 13]);
    }
}

module drawer_front(w, h, depth=19, gap=3, col=[1, 1, 0.98], trans=1.0, handle_w=200) {
    color([col[0], col[1], col[2], trans])
    translate([gap, 0, gap])
    cube([w - 2 * gap, depth, h - 2 * gap]);
    
    if (handle_w > 0) {
        translate([w / 2, depth, h - 38])
        handle(handle_w, trans);
    }
}

module carcass(w, d, h, wall_th=19, flush_front=false) {
    difference() {
        cube([w, d, h]);
        // Hollow out leaving just the frame and open front
        translate([wall_th, wall_th, wall_th])
        cube([w - 2 * wall_th, d, h - 2 * wall_th]);
        
        if (flush_front) {
            translate([-3, d - wall_th, wall_th])
            cube([w + 5, wall_th + 3, h - 2 * wall_th]);
        }
    }
}

module dimension(pos1, pos2, label, offset=[0,-127,0], text_size=76, ext=13, sp1=5, sp2=6) {
    color("orange", 0.5) {
        // Main dimension line
        hull() {
            translate(pos1 + offset) sphere(sp1, $fn=16);
            translate(pos2 + offset) sphere(sp1, $fn=16);
        }
        // Connecting ticks
        hull() { translate(pos1) sphere(sp2, $fn=16); translate(pos1 + offset) sphere(sp2, $fn=16); }
        hull() { translate(pos2) sphere(sp2, $fn=16); translate(pos2 + offset) sphere(sp2, $fn=16); }
    }
    // Text label (always front facing horizontal)
    color("red")
    translate((pos1 + pos2)/2 + offset)
    rotate([90, 0, 180]) // Always facing front
    linear_extrude(ext)
    text(label, size=text_size, halign="center", valign="center");
}
