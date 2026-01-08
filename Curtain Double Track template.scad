$fn = 64;


linear_extrude(0.5){
    difference() {
        union() {
            translate([-22/2, 0]) square([22, 185]);
            translate([-185/2, 0]) square([185, 22]);
        }

        translate([0, 50]) circle(3.5);
        translate([0, 150]) circle(3.5);
        
        // 27.5 difference between holes
        translate([0, 50 + 27.5]) circle(3);
        translate([0, 50 - 27.5]) circle(3);
        
        translate([0, 150 + 27.5]) circle(3);
        translate([0, 150 - 27.5]) circle(3);
        
    }
}