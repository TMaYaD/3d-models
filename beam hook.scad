$fn = $preview ? 32 : 64;

beam_length = 101;
beam_width = 51;

hook_height = 10;
hook_length = 5;
hook_width = 20;
hook_lip = 2;

thickness = 1.2;

module c_section(internal_length, internal_width, extrusion_width, thickness = 1.2, lip = -1, offset = 50) {
    lip = lip >= 0 ? lip : thickness;

    translate([thickness, thickness, 0])
    linear_extrude(height = extrusion_width)
    difference() {
        offset(r = thickness)
                square([internal_length, internal_width]);
        square([internal_length, internal_width]);
        translate([offset / 50 * lip, 0]) square([internal_length - 2 * lip, internal_width + thickness]);
    }
}

module beam_hook() {
    render() {
        c_section(beam_width, beam_length, hook_length+2*thickness, thickness, hook_width);

        translate([thickness, beam_length+thickness, 0])
            rotate([90, 0, 90])
            c_section(hook_height, hook_length, hook_width, thickness, hook_lip/2, 0);

        translate([beam_width+thickness, beam_length+thickness, hook_length+2*thickness])
            rotate([-90, 0, 90])
            c_section(hook_height, hook_length, hook_width, thickness, hook_lip/2, 0);
    }
}

module support_grid(t=0.4, d=1, x=100, y=100, z=0.18, center=false) {
    x_offset = center ? -x/2 : 0;
    y_offset = center ? -y/2 : 0;
    linear_extrude(z) {
        for(i=[0:x/d]) {
            for(j=[0:y/d]) {
                translate([x_offset + i*d, y_offset + j*d]) circle(d=t);
            }
        }
    }
}

module support_layer() {
    render() {
        intersection() {
            beam_hook();
            translate([0,0,-(hook_length+2*thickness-0.18)]) beam_hook();
            support_grid(x=beam_width+2*thickness, y=beam_length+hook_height+3*thickness);
        }
    }
}

for(i=[0:5]) {
    translate([0,0,i * (hook_length+2*thickness+0.18)]) {
        beam_hook();
    }
}

for(i=[1:5]) {
    translate([0,0,i * (hook_length+2*thickness+0.18) - 0.18]) {
        support_layer();
    }
}
