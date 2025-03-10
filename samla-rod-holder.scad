$fn = $preview ? 16 : 64;

dia = 14;
T = 1;
D = T+dia/3;
w = dia + 10;
h = dia + 10;

bevel = 5;

difference() {
        translate([-h*tan(bevel), 0, 0]) cube([D+h*tan(bevel)/2, w, h]);
        rotate([0,-bevel, 0]) translate([-h * sin(bevel), 0, 0]) cube([h*sin(bevel), w, h/cos(bevel)]);
        translate([T, w/2, h/2]) rotate([0, 90, 0]) cylinder(d=dia, h=D - T);
        translate([T, (w-dia)/2,(h/2)]) cube([D-T, dia, h/2]);
        let(factor = (1 - dia/sqrt(h*h + w*w))/4) {
                translate([-h*tan(bevel)/2, w*factor, h * factor]) rotate([0, 90 - bevel, 0]) cylinder(d = 3, h = D+h*tan(bevel)/2);
                translate([-h*tan(bevel)/2, w*(1-factor), h * factor]) rotate([0, 90 - bevel, 0]) cylinder(d = 3, h = D+h*tan(bevel)/2);
        }
}

