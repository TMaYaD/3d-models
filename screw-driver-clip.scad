T = 2;

d1 = 4.4;
d2 = 13.5;

l = 10.5 + d1;

difference() {
        union() {
                cylinder(h = T, d = d2);
                translate([l, 0, 0]) cylinder(h = T, d = d2);
                translate([0, -d2/2, 0]) cube([l, d2, T]);
                cylinder(h = 3*T, d = d1);
                translate([l, 0, 0]) cylinder(h = 3*T, d = d1);

                translate([0, 0, 2*T]) cylinder(h = T, d1 = 3*d1/2, d2 = d1);
                translate([l, 0, 2*T]) cylinder(h = T, d1 = 3*d1/2, d2 = d1);
        }

        translate([-d1/4, -3*d1/4, 0]) cube([d1/2, 3*d1/2, 3*T]);
        translate([l-d1/4, -3*d1/4, 0]) cube([d1/2, 3*d1/2, 3*T]);
}
