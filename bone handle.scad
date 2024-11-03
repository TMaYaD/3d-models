hw = 40;
hl = 60;
l = 160;
w = 40;
h = 3;
hole_dia = 4;
hole_offset = 10;


module pill(l, w, h) {
    difference() {
        hull() {
            translate([ (l-w)/2, 0, 0]) sphere(d=w);
            translate([-(l-w)/2, 0, 0]) sphere(d=w);
        }
        
        
        translate([0, 0,  (w+h)/2]) cube([l, l, w], center = true);
        translate([0, 0, -(w+h)/2]) cube([l, l, w], center = true);
    }
        
}

module heart() {
    module solid() {
        difference() {
            rotate([0, 0, atan2(hw, hl-hw)]) pill(hl, hw, h);
            translate([0, -hw/2, 0]) cube([hl, hw, h], center=true);
        }
    }

    solid();
    mirror([0, 1, 0]) solid();
}


module bone() {
    translate([(l-w)/2, 0, 0]) heart();
    pill(l, w, h);
    rotate([0, 0, 180]) translate([(l-w)/2, 0, 0]) heart();
}

difference() {
    bone();
    translate([-l/2+hole_offset, 0, 0]) cylinder(h=h, d = hole_dia, center=true);
    translate([0,0,-h/2]) linear_extrude(h) text("L u c y", size = w/2, halign = "center", valign="center");
}