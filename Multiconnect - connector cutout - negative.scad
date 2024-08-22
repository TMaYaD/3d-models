$fs=0.01;

r1 = 7.6;
r2 = 10.15;
t1 = 0.44;
t2 = 2.5;
t3 = 1.2;

l = 112.5;

hr = 1;
hh = 1;

cutout_clear = 0.1; // Add to all cutouts on face.

module connector() {
    translate([0, 0, t1/2])             cylinder(h=t1 + 2*cutout_clear, r = r1, center = true);
    translate([0, 0, t1 + t2/2])        cylinder(h=t2, r1 = r1, r2 = r2, center = true);
    translate([0, 0, t1 + t2 + t3/2])   cylinder(h=t3, r = r2, center = true);
}


module connector_cutout() {
    difference() {
        union() {
            connector();
            rotate([-90, 0, 0]) linear_extrude(l) projection() rotate([90, 0, 0]) connector();
        }
        
        translate([0, 0, t1+t2+t3-hh/2+.01]) cylinder(h = hh+.01, r1 = 0, r2 = hr+.01, center = true);
    }
}

connector_cutout();