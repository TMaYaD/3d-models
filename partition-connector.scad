$fn = $preview ? 16 : 64;

module partition_connector(sides, thickness = 3, height = 0, length = 0) {
        assert(sides == 1 || sides == 2 || sides == 3 || sides == 4, "Invalid number of sides");

        height = height ? height : 5*thickness;
        length = length ? length : 10*thickness;

        difference() {
                union() {
                        for (i = [0:sides-1]) {
                                rotate([0, 0, 90*i])
                                        translate([0, -3*thickness/2, 0])
                                        cube([length, 3*thickness, height]);
                        }
                }
                for (i = [0:sides-1]) {
                        rotate([0, 0, 90*i])
                                translate([0, -thickness/2, thickness])
                                cube([length, thickness, height]);
                }
        }
}

partition_connector(3, thickness = 3.2);
