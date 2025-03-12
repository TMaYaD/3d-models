module axel(d, h, cutout_offset=0) {
        cutout_offset = cutout_offset > 0 ? cutout_offset : d/4;

        difference() {
                cylinder(d=d, h=h);
                translate([cutout_offset, -d/2, -1/2])
                        cube([d, d, h+1]);
        }
}


module knob(od, id, oh, ih, od2 = 0) {
        od2 = od2 > 0 ? od2 : od;
        cylinder(d1=od, d2 = od2, h=oh);
        translate([0, 0, -ih])
                cylinder(d=id, h=ih);
}

difference() {
        knob(62, 16, 8, 12, 59);
        translate([0, 0, -13])
                axel(7, 16, 1.75);
        // cut a small dot on the top of the knob to act as an indicator
        rotate([0, 0, 20])
                translate([0, 25, 8-0.36])
                cylinder(d=2, h=0.5);
}
