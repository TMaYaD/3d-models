$fs = 0.01;
$fa = $preview ? 6 : 3;
use <Multiconnect - connector cutout - negative.scad>;
use <lib/honeycomb.scad>;

cable_width = 3.5;
cable_height = 5;
cable_l = 850;
wall_thickness = 1.2;
connectors = 3;

additional_connectors = connectors - 1;
base_thickness = wall_thickness;

step_r = cable_width + wall_thickness;

core_loops = ceil(cell_size()/2 / step_r);
core_r = step_r * core_loops;

loops = let(
            a = PI * step_r,
            b = PI * (2 * core_loops * step_r + wall_thickness) + (4 * additional_connectors * cell_size()),
            c = -cable_l
        ) ceil((-b + sqrt(b^2 - 4 * a * c)) / (2 * a));

wall_height = cable_height;
base_r = (core_loops + loops) * step_r + wall_thickness;
base_height = base_thickness + wall_height;

clearance = 0.1; // Add to all cutouts on face.

module base(){
    cylinder(
        h = (base_height),
        r = base_r
    );
}

module core_trench(){
    w = core_r;
    l = base_r - core_r;
    h = wall_height;
    translate([0, (base_r+core_r)/2, base_height-h/2])
        cube([w, l, h + clearance], center = true);
}

module core_cutout(){
//    translate([0, 0, base_thickness/2])
//        cylinder(h=wall_height + clearance, r = core_r, center = true);
    rotate([0, 0,   0]) core_trench();
    rotate([0, 0,  90]) core_trench();
    rotate([0, 0, 180]) core_trench();
    rotate([0, 0, 270]) core_trench();
}

module cable_cutout() {
    translate([0, cable_width/2, base_thickness/2])
    hull() {
                                       circle(d = cable_width);
        translate([0, cable_height - 2 * cable_width/3, 0]) circle(d = cable_width);
    }
}

module cable_cutouts(loops) {
            for(i=[1 : loops]){
                translate([(core_loops+i) * step_r - cable_width/2, 0, 0])
                    cable_cutout();
            }
}

module spiral_paths(loops){
    translate([0, 0, base_thickness])
        rotate_extrude() {
            cable_cutouts(loops);
        }
}

module parallel_paths(loops){
    translate([0, 0, base_thickness])
        rotate([90, 0, 90])
            linear_extrude(cell_size()) {
                cable_cutouts(loops);
                mirror([1,0,0]) cable_cutouts(loops);
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
        sphere(clearance);
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
    bounds = core_loops+loops;
    size = cable_width;
    inner_size = (size/sin(60))/2;
    outer_size = ((size+wall_thickness)/sin(60))/2;
//    outer_hex_radius = outerhexradius(outer_size, bounds);

    render() // translate([0,0,-(base_height)/2])
        intersection() {
            difference() {
                cylinder(h = base_height, r = base_r-step_r);
                cylinder(h = base_height, r = core_r);
            }
            hexagongrid(height=(base_thickness+cable_height/2), boundry=bounds, outerhexradius=outer_size, innerhexradius=inner_size, orientation=0, inneronly=true );
        }
}

module cable_spiral_half() {
    render()
        intersection() {
            difference() {
                base();
                                core_cutout();
                                spiral_paths(loops);
                //                 clip_cutout();
                // rotate([0,0,90]) clip_cutout();
                                top_connector();
                                // bottom_connector();
                                honeycomb();
            }
            translate([0, -base_r, 0]) cube([base_r, base_r*2, base_height]);
        }
}

module connector_section_half() {
    difference() {
        translate([0, -base_r, 0]) cube([cell_size(), base_r*2, base_height]);
        translate([cell_size(), 0, 0]) {
            core_cutout();
            spiral_paths(1);
            // clip_cutout();
            // rotate([0,0,90]) clip_cutout();
            top_connector();
            honeycomb();
        }
        parallel_paths(loops);
    }
}

module connector_section() {
    connector_section_half();
    mirror([1,0,0]) connector_section_half();
}

translate([cell_size() * (additional_connectors), 0, 0]) cable_spiral_half();

if (additional_connectors > 0) {
    for(i=[1 : (additional_connectors)]) {
        translate([cell_size()*(connectors-2*i), 0, 0])
            connector_section();
    }
}

translate([-cell_size() * (additional_connectors), 0, 0]) mirror([1,0,0]) cable_spiral_half();
