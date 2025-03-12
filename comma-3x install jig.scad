use <lib/honeycomb.scad>;

console_width = 230;
console_height = 50;

device_depth = 40; // It's 37. Let's add a little margin to make it easy to slide in and out.

mount_width = 65;
mount_height = 25;

number_of_spacers = 4;

SPACER_SLOT_MARGIN=3;
assert(JIG_THICKNESS<=SPACER_SLOT_MARGIN, "SPACER_SLOT_MARGIN includes JIG_THICKNESS; So it MUST be greater than JIG_THICKNESS.");
JIG_MARGIN = 10;
JIG_THICKNESS = 2;
GUIDERAIL_HEIGHT = 5;


module jig(){
        difference() {
                cube([console_width+2*JIG_MARGIN, console_height+device_depth+mount_height+JIG_MARGIN, JIG_THICKNESS]);

                // mount cutout
                translate([JIG_MARGIN+(console_width-mount_width)/2, JIG_MARGIN]) cube([mount_width, mount_height, JIG_THICKNESS]);

                // console cutout with spacer slots
                translate([JIG_MARGIN, device_depth+mount_height+JIG_MARGIN]) {
                        // console cutout
                        cube([console_width, console_height, JIG_THICKNESS]);

                        // spacer slots
                        translate([0, JIG_MARGIN]) spacer_hook(console_height-2*JIG_MARGIN, SPACER_SLOT_MARGIN);
                        translate([console_width, console_height-JIG_MARGIN]) rotate([0,0,180]) spacer_hook(console_height-2*JIG_MARGIN, SPACER_SLOT_MARGIN);
                }
        }

        //guide rails
        translate([JIG_MARGIN+(console_width-mount_width)/2, JIG_MARGIN+mount_height+device_depth-JIG_THICKNESS, 0]) cube([mount_width, JIG_THICKNESS, GUIDERAIL_HEIGHT]);
        translate([JIG_MARGIN-JIG_THICKNESS, JIG_MARGIN+mount_height+device_depth, 0]) cube([JIG_THICKNESS, JIG_MARGIN, GUIDERAIL_HEIGHT]);
        translate([JIG_MARGIN-JIG_THICKNESS, JIG_MARGIN+mount_height+device_depth+console_height-JIG_MARGIN, 0]) cube([JIG_THICKNESS, JIG_MARGIN, GUIDERAIL_HEIGHT]);
        translate([console_width+JIG_MARGIN, JIG_MARGIN+mount_height+device_depth, 0]) cube([JIG_THICKNESS, JIG_MARGIN, GUIDERAIL_HEIGHT]);
        translate([console_width+JIG_MARGIN, JIG_MARGIN+mount_height+device_depth+console_height-JIG_MARGIN, 0]) cube([JIG_THICKNESS, JIG_MARGIN, GUIDERAIL_HEIGHT]);
}

module spacer_hook(length, width=JIG_THICKNESS*2, thickness=JIG_THICKNESS){ // TODO: Make it 1 * JIG_THICKNESS
        translate([-width, 0, 0]) cube([thickness, length, thickness]); // TODO: :s/JIG_THICKNESS/thickness
        translate([-width, 0, thickness/2]) cube([width, length, thickness/2]);
}


module spacer(width=spacer_width){
        difference() {
                cube([width, console_height, JIG_THICKNESS]); // TODO: Make it 1 * JIG_THICKNESS
                if (width>SPACER_SLOT_MARGIN) {
                        translate([width,JIG_MARGIN, 0]) spacer_hook(console_height-2*JIG_MARGIN, SPACER_SLOT_MARGIN);
                }
        }

        translate([0,JIG_MARGIN, 0]) spacer_hook(console_height-2*JIG_MARGIN, SPACER_SLOT_MARGIN);

        // guide rails
        translate([width-JIG_THICKNESS, 0, 0]) cube([JIG_THICKNESS, JIG_MARGIN, GUIDERAIL_HEIGHT]);
        translate([width-JIG_THICKNESS, console_height-JIG_MARGIN, 0]) cube([JIG_THICKNESS, JIG_MARGIN, GUIDERAIL_HEIGHT]);
}

difference(){
        jig();
        translate([JIG_MARGIN+console_width/2, (JIG_MARGIN+mount_height+device_depth)/2])
                intersection() {
                        translate([0,0,JIG_THICKNESS/2])
                        difference() {
                                cube([console_width, mount_height+device_depth-JIG_MARGIN,JIG_THICKNESS], center=true);
                                translate([0,-device_depth/2+JIG_MARGIN, 0]) cube([mount_width+2*JIG_MARGIN, mount_height+JIG_MARGIN, JIG_THICKNESS], center=true);
                        }
                hexagongrid(height=JIG_THICKNESS, boundry = console_width/JIG_MARGIN/4+1, outerhexradius=JIG_MARGIN, innerhexradius=JIG_MARGIN-SPACER_SLOT_MARGIN);
                }
}
color("red") {
for(i=[0:number_of_spacers-1]) {
        translate([JIG_MARGIN + 2 * SPACER_SLOT_MARGIN + i * 2^number_of_spacers, device_depth+mount_height+JIG_MARGIN + SPACER_SLOT_MARGIN, 0]) spacer(2^i);
        translate([JIG_MARGIN+console_width - 2 * SPACER_SLOT_MARGIN - i * 2^number_of_spacers, JIG_MARGIN+mount_height+device_depth+console_height + SPACER_SLOT_MARGIN, 0]) rotate([0,0,180]) spacer(2^i);
}
}

