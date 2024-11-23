$fs = 0.01;
$fa = $preview ? 6 : 3;

// use <curved_horn.scad>;
use <talons.scad>;

wire_r = .2;

base_r = 3.5;
base_l = 25;
base_h = 5;

module horn(l, r) {
        render()
        hullSweep(45, [-1.2, 0, 0], [0, 0, 1], [1, 0])
                union()
                {
                        translate([0, 2*r, 2*r]) sphere(r*2);
                        translate([0, l-r, r]) sphere(r);
                }
}

module base(){
        module eighth() {
                intersection() {
                        cube([base_r, base_l/2, base_h/2]);

                        union() {
                                translate([0, base_l/2 - base_r, base_h/2 - wire_r])
                                        rotate_extrude(angle = 90) translate([base_r - wire_r, 0, 0]) circle(r = wire_r);
                                translate([ base_r-wire_r, base_l/2 - base_r, base_h/2 - wire_r]) rotate([90, 0, 0]) cylinder(h = base_l/2 - base_r, r = wire_r);

                                translate([0, base_l/2 - wire_r, 0]) cylinder(h = base_h/2 - wire_r, r = wire_r);
                                translate([base_r-wire_r, base_l/2 - base_r , 0]) cylinder(h = base_h/2 - wire_r, r = wire_r);
                        }
                }
        }


        module quarter() {
                eighth();
                mirror([1, 0, 0]) eighth();
        }

        module half() {
                quarter();
                mirror([0, 0, 1]) quarter();
                difference() {
                        minkowski() {
                                horn(base_l/2, base_r/2);
                                sphere(wire_r);
                        }
                        horn(base_l/2, base_r/2);
                }
                // horn(base_l/2, base_r/2);
        }

        half();
        mirror([0, 1, 0]) half();

}

color("gold", 0.5) base();
