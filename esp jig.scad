$fn=24;

module chip()
{
    translate([0,0,2])
        cube([24,16,4], center=true);
}

module pin(posn) {
    pin_dia = 1.6;
    pin_height = 15;
    
    if (posn <= 0)
    {}
    
    else if (posn <= 8)
    {
        x = -12 + 8.45 + 2*(posn - 1);
        y = -8 + 0.5;
                        
        translate([x, y, 0])
            cylinder(h=pin_height, r=pin_dia/2);
    }
    else if (posn <= 16)
    {
        x = -12 + 8.45 + 2*(16 - posn);
        y = 8 - 0.5;
        
        translate([x, y, 0])
            cylinder(h=pin_height, r=pin_dia/2);
    }
    else if (posn <= 22)
    {
        x = 12 - 0.5;
        y = -8 + 2.98 + 2*(posn - 17);
        
        translate([x, y, 0])
            cylinder(h=pin_height, r=pin_dia/2);
    }

}

module shell(){
    difference() {
        translate([0,0,3.01])
            cube([28, 20, 6], center=true);
        cube([20,12,20], center=true);
        cube([40,12,4], center=true);
        cube([20,40,4], center=true);
    }
}

difference() {
    shell();
    union() {
        chip();
        pin(3);
        pin(8);
        pin(9);
        pin(12);
        pin(15);
        pin(16);
        
    }
}