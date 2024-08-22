$fs = 0.01;
$fa = $preview ? 6 : 3;
use <Multiconnect - connector cutout - negative.scad>;
use <honeycomb-lib.scad>;

cable_dia = 4;
cable_l = 1500;
wall_thickness = 1;
core_loops = 3;

base_thickness = wall_thickness;
step_r = cable_dia + wall_thickness;
core_r = step_r * core_loops;
loops = let(
            a = step_r,
            b = 2 * core_loops * step_r + wall_thickness,
            c = -cable_l / PI
        ) ceil((-b + sqrt(b^2 - 4 * a * c)) / (2 * a));

wall_height = cable_dia;
base_r = (core_loops + loops) * step_r + wall_thickness;
base_height = base_thickness + wall_height;

cutout_clear = 0.1; // Add to all cutouts on face.

module base(){
    cylinder(
        h = (base_height),
        r = base_r,
        center = true
    );
}

module core_cutout(){
//    translate([0, 0, base_thickness/2])
//        cylinder(h=wall_height + cutout_clear, r = core_r, center = true);
    translate([0, (base_r+core_r)/2, base_thickness/2])
        cube([core_r, base_r-core_r, wall_height+cutout_clear], center = true);
    rotate([0, 0,  90]) translate([0, (base_r+core_r)/2, base_thickness/2])
        cube([core_r, base_r-core_r, wall_height+cutout_clear], center = true);    rotate([0, 0, 180]) translate([0, (base_r+core_r)/2, base_thickness/2])
        cube([core_r, base_r-core_r, wall_height+cutout_clear], center = true);    rotate([0, 0, 270]) translate([0, (base_r+core_r)/2, base_thickness/2])
        cube([core_r, base_r-core_r, wall_height+cutout_clear], center = true);
}

module cable_cutout() {
    hull() {
                                       circle(d = cable_dia);
        translate([0, cable_dia/3, 0]) circle(d = cable_dia);
    }
}

module spiral(){
    translate([0, 0, base_thickness/2])
        rotate_extrude() {
            for(i=[1 : loops]){
                translate([(core_loops+i) * step_r - cable_dia/2, 0, 0])
                    cable_cutout();
            }
        }
}


module clip() {
    // top
    translate([0, 0, base_height/2])
        cube([core_r, base_r*2, base_thickness], center = true);
    // left wall
    translate([0, base_r-wall_thickness/2, 0])
        cube([core_r, wall_thickness, base_thickness * 3 + wall_height], center = true);
    // right wall
    translate([0, -(base_r-wall_thickness/2), 0])
        cube([core_r, wall_thickness, base_thickness * 3 + wall_height], center = true);
    // left catch
    translate([0, base_r-step_r/2, -(base_height/2)])
        cube([core_r, step_r, base_thickness], center = true);
    // right catch
    translate([0, -(base_r-step_r/2), -(base_height/2)])
        cube([core_r, step_r, base_thickness], center = true);
}

module clip_cutout() {
    render() minkowski(){
        clip();
        cube([cutout_clear,cutout_clear,cutout_clear], center = true);
    }
}

module top_connector() {
        translate([0, 0, (base_height)/2])
            rotate([0, 180, 0])
            connector_cutout();
}

module bottom_connector() {
        translate([0, 0, -(base_height)/2])
            connector_cutout();
}

module honeycomb() {
    bounds = core_loops+loops + 1;
    size = cable_dia;
    inner_size = (size/sin(60))/2;
    outer_size = ((size+wall_thickness)/sin(60))/2;
//    outer_hex_radius = outerhexradius(outer_size, bounds);

    render() translate([0,0,-(base_height)/2])
        intersection() {
            difference() {
                cylinder(h = base_height, r = base_r-step_r);
                cylinder(h = base_height, r = core_r);
            }
            hexagongrid(height=(base_thickness+cable_dia/2), boundry=bounds, outerhexradius=outer_size, innerhexradius=inner_size, orientation=0, inneronly=true );
        }
}

difference() {
    color("yellow", 0.6) base();
                         core_cutout();
                         spiral();
                         clip_cutout();
        rotate([0,0,90]) clip_cutout();
        top_connector();
        // bottom_connector();
        honeycomb();

}
//
//color("red", 0.5) {
//    rotate([0,0,90]) clip();
//}

//color("blue") {
//        translate([0, 0, (base_height)/2])
//            rotate([0, 180, 0])
//            connector_cutout();
//}

// color("orange", 0.5) {
//     honeycomb();
// }
