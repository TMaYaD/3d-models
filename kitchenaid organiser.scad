$fn = $preview ? 10 : 100;

T = 3;
d = 30;
h = 20;

spacing = 80;

difference() {
        union() {
                translate([-spacing, -d/2-T, 0]) cube([spacing*2, d+2*T, h+T]);
                translate([-spacing, 0, 0]) cylinder(d=d+2*T, h=h+T);
                translate([+spacing, 0, 0]) cylinder(d=d+2*T, h=h+T);

                translate([-spacing-d/2-T, -spacing/2, 0]) cube([d+2*T, spacing, T]);
                translate([spacing-d/2-T, -spacing/2, 0]) cube([d+2*T, spacing, T]);

                translate([-spacing, -spacing/2, 0]) cylinder(d=d+2*T, h=T);
                translate([-spacing, +spacing/2, 0]) cylinder(d=d+2*T, h=T);
                translate([+spacing, -spacing/2, 0]) cylinder(d=d+2*T, h=T);
                translate([+spacing, +spacing/2, 0]) cylinder(d=d+2*T, h=T);
        }

        translate([-spacing,0,T]) cylinder(d=d, h=h);
        translate([0,0,T]) cylinder(d=d, h=h);
        translate([+spacing,0,T]) cylinder(d=d, h=h);
}
