length = 50;
width = 45;
depth = 15;
lip = 4;
thickness = 1.2;

module keyhole(SCREW_DIAMETER, SCREW_HEAD_DIAMETER, thickness) {
    union() {
        translate( [0,0,-0.01] )
            linear_extrude( thickness + 0.01) {
                hull(){
                    circle(SCREW_DIAMETER/2);
                    translate([SCREW_HEAD_DIAMETER,0]) circle(SCREW_DIAMETER/2);
                }
                
                translate([SCREW_HEAD_DIAMETER,0])
                    circle(SCREW_HEAD_DIAMETER/2);
            }
        
        translate( [0,0,thickness/2] )
            linear_extrude( thickness/2 +0.02)
                hull(){
                    circle( SCREW_HEAD_DIAMETER/2 + thickness/2 );
                    translate([SCREW_HEAD_DIAMETER,0]) circle( SCREW_HEAD_DIAMETER/2 + thickness/2);
                }
    }
}

difference() {
    cube([width+2*thickness, depth+2*thickness, length+thickness], center = true);
    translate([0, 0, thickness/2])
        cube([width, depth, length+thickness], center = true);
    translate([0,-depth/2+thickness,lip])
        cube([width-2*lip, depth, length-lip], center=true);
    translate([0, depth/2+thickness, length/4])
        rotate([90, 90, 0])
        keyhole(3, 6, thickness*1.5);
}
