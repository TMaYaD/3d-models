$fn = $preview ? 32 : 64;

count=2;

L=215;
W=115;
H=30;
MOUNT_HOLE_INSET=32.5; // Distance from edges for mounting holes

// Customizable parameters
thickness = 3;           // Wall thickness of mount
mount_height = 10;       // Total height of mounting bracket
screw_hole_d = 5;        // Diameter of mounting screw holes
screw_head_d = 9;        // Diameter of screw head for countersink
screw_head_h = 4;        // Height of countersink
spacing = 30;            // Space between multiple mounts

vent_h=10;
vent_inset=10;

module powersupply_mount(width=W, height=H, t=thickness, m_height=mount_height,
                        hole_inset=MOUNT_HOLE_INSET) {
        difference() {
                cube([width+2*t, height+t, m_height+t]);
                translate([t,0,t]) cube([width, height, m_height]);
                translate([t,vent_inset,0]) cube([width, vent_h, t]);
        }
}

module mounting_hole(hole_d=screw_hole_d, head_d=screw_head_d, head_h=screw_head_h, t=thickness) {
    // Screw shaft
    rotate([-90, 0, 0])
        cylinder(d=hole_d, h=t + 2);
    // Countersink
    translate([0, t - head_h + 0.1, 0])
        rotate([-90, 0, 0])
            cylinder(d1=hole_d, d2=head_d, h=head_h);
}

module mounting_ears(l=spacing, h=mount_height+thickness, t=thickness) {
        difference() {
                cube([l, t, h]);
                translate([l/2, 0, h/2]) mounting_hole();
        }
}

// Create array of mounts
for (i = [0:count-1]) {
    translate([(W + 2 * thickness + spacing) * i, 0, 0]) {
        mounting_ears();
        translate([spacing, 0, 0]) powersupply_mount();
    }
    translate([(W + 2 * thickness + spacing) * count, 0, 0]) mounting_ears();
}


