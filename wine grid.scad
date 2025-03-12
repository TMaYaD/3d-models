$fn = $preview ? 10 : 100;

include <lib/honeycomb.scad>

D = 10;
W = 810;
H = 542;

count_x = 7;
count_y = 5;

T = 12;

ohr = W/count_x/cos(30)/2;
delta_r = T/cos(30)/2;
ihr = ohr - delta_r;

jig_t = 4;
jig_r = jig_t/cos(30);

module grid() {
    difference() {
        union() {
            difference() {
                translate([-W/2,-H/2,0]) cube([W,H,D]);
                hexagongrid(height = D, boundry = max(count_x,count_y), outerhexradius = ohr, innerhexradius = ihr, orientation = 90, inneronly = true);
            }

            // frame
            translate([0,0,D/2])
            difference() {
                cube([W,H,D], center = true);
                cube([W-2*T,H-2*T,D], center = true);
            }
        }
        // hexagongrid(height = D-t/2, boundry = 1, outerhexradius = ohr/3+t/3, innerhexradius = t/2, orientation = 90, inneronly = true);
    }
}

module jig() {
    difference() {
        hexagongrid(height = D + jig_t, boundry = 0, outerhexradius = ohr+jig_r, innerhexradius = ihr-jig_r, orientation = 90, inneronly = false);
        hexagongrid(height = D, boundry = 0, outerhexradius = ohr, innerhexradius = ihr, orientation = 90, inneronly = false);
    }
}

// module part(n) {
//     i = n%3;
//     j = floor(n/3);
//     intersection() {
//         translate([-W/3 + i*W/3,-H/4 + j*H/2,0])
//                 grid();

//         translate([0,0,D/2])
//         cube([W/3,H/2,D], center = true);
//     }
// }

// grid();
// for (i = [0:5]) {
//     translate([0,0,i*2*D])
//     part(i);
// }

color("red") jig();

// 13 => 56.6429
// 12 => 57.0089
