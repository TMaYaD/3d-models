$fn = 64;

// Samsung Galaxy Tab A7 SM-T500
TABLET_WIDTH = 247.6;
TABLET_HEIGHT = 157.4;
TABLET_DEPTH = 7;

CAMERA_OFFSET_X = 9.2;
CAMERA_CUTOUT_HEIGHT = 27;
CAMERA_CUTOUT_WIDTH = 27;

CHARGER_CUTOUT_DEPTH = 6.7;
CHARGER_CUTOUT_HEIGHT = 15.7;

WALL_THICKNESS = 1;
LIP_THICKNESS = 1;
BACK_THICKNESS = 3.5;
LIP = 5;

BRACKET_WIDTH = 16;
BOTTOM_BRACKET_HEIGHT = 0;
TOP_BRACKET_HEIGHT = 0;

TOLERANCE = 0.25;

tablet_cutout_width = TABLET_WIDTH + 2 * TOLERANCE;
tablet_cutout_height = TABLET_HEIGHT + 2 * TOLERANCE;
tablet_cutout_depth = TABLET_DEPTH + 2 * TOLERANCE;

total_width = tablet_cutout_width + 2 * WALL_THICKNESS;
total_depth = tablet_cutout_depth + LIP_THICKNESS + BACK_THICKNESS;
total_height = tablet_cutout_height + 2 * WALL_THICKNESS;

bottom_lip_height = min(LIP, BOTTOM_BRACKET_HEIGHT-WALL_THICKNESS);
top_lip_height = min(LIP, TOP_BRACKET_HEIGHT-WALL_THICKNESS);


difference() {
    cube([total_width, total_depth, total_height]);

    // Tablet cutout
    translate([WALL_THICKNESS, LIP_THICKNESS, WALL_THICKNESS])
        cube([tablet_cutout_width, tablet_cutout_depth, tablet_cutout_height]);

    // Display cutout
    translate([WALL_THICKNESS+LIP, 0, WALL_THICKNESS+bottom_lip_height])
        cube([tablet_cutout_width - 2 * LIP, LIP_THICKNESS, tablet_cutout_height - bottom_lip_height - top_lip_height]);

    // Open the top
    translate([WALL_THICKNESS, LIP_THICKNESS, tablet_cutout_height + WALL_THICKNESS])
        cube([tablet_cutout_width, tablet_cutout_depth, WALL_THICKNESS]);

    // Punchout the back
    translate([BRACKET_WIDTH, 0, BOTTOM_BRACKET_HEIGHT])
        cube([tablet_cutout_width + 2 * WALL_THICKNESS - 2 * BRACKET_WIDTH, tablet_cutout_depth + LIP_THICKNESS + BACK_THICKNESS, tablet_cutout_height  + 2 * WALL_THICKNESS - BOTTOM_BRACKET_HEIGHT - TOP_BRACKET_HEIGHT]);

    // Camera cutout
    translate([WALL_THICKNESS + CAMERA_OFFSET_X, total_depth - BACK_THICKNESS, total_height - CAMERA_CUTOUT_HEIGHT])
        cube([CAMERA_CUTOUT_WIDTH, BACK_THICKNESS, CAMERA_CUTOUT_HEIGHT]);

    // Charger cutout
    translate([total_width - WALL_THICKNESS, LIP_THICKNESS + tablet_cutout_depth - CHARGER_CUTOUT_DEPTH, (total_height - CHARGER_CUTOUT_HEIGHT) / 2])
        cube([WALL_THICKNESS, CHARGER_CUTOUT_DEPTH, CHARGER_CUTOUT_HEIGHT]);

    // Screw holes
    translate([0, total_depth - BACK_THICKNESS, 0])
        corner_offsets(total_width, total_height, width_offset = BRACKET_WIDTH - (BRACKET_WIDTH - WALL_THICKNESS - LIP) / 2 )
            render()
            rotate([-90, 0, 0])
                metric_screw_hole(3, 6, 3);
}


module metric_screw_hole(dia, head_dia, head_length, length=1000) {
        cylinder(d2=dia, d1=head_dia, h=head_length);
        translate([0, 0, head_length])
            cylinder(d=dia, h=length-head_length);
}

module corner_offsets(total_width, total_height, width_offset=0, height_offset=0) {
    height_offset = height_offset > 0 ? height_offset : total_height/4;
    width_offset = width_offset > 0 ? width_offset : total_width/4;

    translate([width_offset, 0, height_offset])
        children();

    translate([total_width - width_offset, 0, height_offset])
        children();

    translate([width_offset, 0, total_height - height_offset])
        children();

    translate([total_width - width_offset, 0, total_height - height_offset])
        children();
}
