$fn = 100;

include <vendor/kennetek/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>

gx = 3;
gy = 2;
gh = 6;

wall_t = 1;

wagon_w = 9;
wagon_l = 27;
wagon_h = 10.5;
wagon_t = 2.5;

station_w = 17;
station_h = 30;

grid_x = 9;
grid_y = 5;

offset_x = -station_w/2;
offset_y = 0;
offset_z = 8;

module wagon(w, l, h, T) { // Only a rough outline
    difference() {
        cube([w, l, h]);
        translate([T, T, 0]) {
            cube([w - 2*T, l - 2*T, h-2 * T]);
        }
    }
}

gridfinityInit(gx, gy, height(gh)) {
    for (i = [0:grid_y-1]) {
        for (j = [0:grid_x-1]) {
            translate([(wagon_w + wall_t)*(j-grid_x/2) + offset_x, (wagon_h + wall_t)*(i - grid_y/2) + offset_y, offset_z]) {
                cube([wagon_w, wagon_h, wagon_l]);
            }
        }
    }

    translate([(wagon_w + wall_t) * grid_x/2 + offset_x, -(wagon_h + wall_t) * grid_y/2 + offset_y, - (station_h - wagon_l) + offset_z]) {
        for (i = [0:2]) {
            translate([0, ((wagon_h + wall_t) * grid_y - station_w - wall_t) * i/2, 0]) {
                cube([station_w, station_w, station_h]);
            }
        }
    }

    // translate([-(grid_x + 2) * (wagon_w + wall_t)/2, -(grid_y + 2) * (wagon_h + wall_t)/2, wagon_l/2 + offset_z]) {
    //     cube([(grid_x + 2) * (wagon_w + wall_t), (grid_y + 2) * (wagon_h + wall_t), wagon_l/2 - offset_z]);
    // }

    translate([0, 0, height(gh/2)])
    cut(w = gx, h = gy, t = 5);

}
gridfinityBase([gx, gy], final_cut = false);
