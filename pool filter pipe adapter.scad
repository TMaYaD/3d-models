$fn = 64;

OD1 = 74.5;
H1 = 3;
OD2 = 55;
H2 = 32;

ID1 = 36.5;
ID2 = 43;

chamfer = 1;


minkowski() {
    difference() {
        union() {
            translate([0,0, chamfer]) cylinder(h = H1 - chamfer, d = OD1 - 2 * chamfer);
            translate([0,0, H1]) cylinder(h = H2 - chamfer, d = OD2 - 2 * chamfer);
        }
    
        translate([0,0, chamfer]) cylinder(h = H1 - chamfer, d = ID1 + 2 * chamfer);
        translate([0,0, H1]) cylinder(h = H2 - chamfer, d1 = ID2 + 2 * chamfer, d2 = ID2 + 4 * chamfer);
    }
    sphere(chamfer);
}
