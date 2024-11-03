$fn = $preview ? 32 : 64;

beam_length = 100;
beam_width = 25;
beam_lip = 4;

width = 5;
thickness = 1.2;

hook_length = 10;
hook_lip = 2;

module hook(length, width, height, thickness = 1.2, lip = -1, offset = 50) {
    lip = lip >= 0 ? lip : thickness;

    translate([thickness, thickness, 0])
    linear_extrude(height = height)
    difference() {
        offset(r = thickness)
                square([length, width]);
        square([length, width]);
        translate([offset / 50 * lip, 0]) square([length - 2 * lip, width + thickness]);
    }
}

hook(beam_length, beam_width, width, thickness, beam_lip);

translate([-hook_length-thickness, width, 0])
rotate([90, 0, 0]) hook(hook_length, width - 2 * thickness, width, thickness, hook_lip/2, 100);

translate([-hook_length-thickness, beam_width+2*thickness, 0])
rotate([90, 0, 0]) hook(hook_length, width - 2 * thickness, width, thickness, hook_lip/2, 100);
