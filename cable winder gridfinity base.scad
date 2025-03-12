// Gridfinity base for cable winder (https://www.printables.com/model/56609-usb-cable-winder-stackable-knurled-print-in-place)

include <vendor/kennetek/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>

$fn = $preview ? 16 : 64;

gx = 4;
gy = 1;
gh = 3;

module cable_winder_cutout(dia=50, h=33, dia_chamfer = 8, vertical_chamfer = 6) {
        cylinder(d1=dia-2*dia_chamfer, d2=dia, h = vertical_chamfer);
        translate([0,0,vertical_chamfer]) cylinder(d=dia, h=h-2*vertical_chamfer);
        translate([0,0,h-vertical_chamfer]) cylinder(d1=dia, d2=dia-2*dia_chamfer, h=vertical_chamfer);
}

difference() {
    union() {
        gridfinityInit(gx, gy, height(gh));
        gridfinityBase([gx, gy]);
    }

        count_x = floor(gx*l_grid/33);
        count_y = floor((gy*l_grid+15)/50);
        echo(count_y);
        for(i=[-count_x/2:count_x/2-1]) {
            for(j=[-count_y/2:count_y/2-1]) {
                translate([i*30, j*50+25, 25+5]) rotate([0,90,0]) cable_winder_cutout();
            }
        }
}

