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
        r = base_r
    );
}

module core_cutout(){
//    translate([0, 0, base_thickness/2])
//        cylinder(h=wall_height + cutout_clear, r = core_r, center = true);
        module trench(){
            w = core_r;
            l = base_r - core_r;
            h = wall_height;
            translate([0, (base_r+core_r)/2, base_height-h/2])
                cube([w, l, h + cutout_clear], center = true);
        }

    rotate([0, 0,   0]) trench();
    rotate([0, 0,  90]) trench();
    rotate([0, 0, 180]) trench();
    rotate([0, 0, 270]) trench();
}

module cable_cutout() {
    translate([0, cable_dia/2, base_thickness/2])
    hull() {
                                       circle(d = cable_dia);
        translate([0, cable_dia/3, 0]) circle(d = cable_dia);
    }
}

module spiral(){
    translate([0, 0, base_thickness])
        rotate_extrude() {
            for(i=[1 : loops]){
                translate([(core_loops+i) * step_r - cable_dia/2, 0, 0])
                    cable_cutout();
            }
        }
}


module clip() {
    w = core_r;
    l = 2 * base_r;
    t = wall_thickness;
    h = base_height+2*t;

    difference() {
        translate([0, 0, h/2 - t]) intersection() {
            cube([w, l, h], center = true);
            cylinder(h = h, d = l, center = true);
        }

        cylinder(h = base_height, d = l - 2*t);
        translate([0, 0, -t]) cylinder(h = t, d = l - 2 * step_r);
    }
}

module clip_cutout() {
    render() minkowski(){
        clip();
        cube([cutout_clear,cutout_clear,cutout_clear], center = true);
    }
}

module top_connector() {
    translate([0, 0, base_height])
        rotate([0, 180, 0])
        connector_cutout();
}

module bottom_connector() {
    connector_cutout();
}

module honeycomb() {
    bounds = core_loops+loops + 1;
    size = cable_dia;
    inner_size = (size/sin(60))/2;
    outer_size = ((size+wall_thickness)/sin(60))/2;
//    outer_hex_radius = outerhexradius(outer_size, bounds);

    render() // translate([0,0,-(base_height)/2])
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

color("red") {
//    rotate([0,0,90]) clip();
}
