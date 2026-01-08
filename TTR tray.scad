$fn = 100;

include <vendor/kennetek/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>

gx = 3;
gy = 4;
gh = 2;

base_h = 8;
base_t = 1;

wagon_w = 9;
wagon_l = 27;
wagon_h = 10.5;
wagon_t = 2.5;

offset_x = 10;
offset_y = 10;

module wagon(w, l, h, T) { // Only a rough outline
    difference() {
        cube([w, l, h]);
        translate([T, T, 0]) {
            cube([w - 2*T, l - 2*T, h-2 * T]);
        }
    }
}

difference() {
    union() {
        gridfinityInit(gx, gy, height(gh));
        gridfinityBase([gx, gy]);
    }
    for (i = [0:4]) {
        for (j = [0:8]) {
            translate([(wagon_w + base_t)*(j-4.5) + offset_x, (wagon_l + base_t)*(i - 2.5) + offset_y, base_h]) {
                wagon(wagon_w, wagon_l, wagon_h, wagon_t);
            }
        }
    }
}
