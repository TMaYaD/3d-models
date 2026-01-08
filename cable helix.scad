$fn = $preview ? 16 : 32;

use <Multiconnect - connector cutout - negative.scad>;

cable_width = 6.5;
cable_height = 6.5;
cable_l = 140;
wall_thickness = 1.2;
connectors = 3;

loop_r = (cell_size()+cable_width)/2;

loop_count = let(
                 length_per_loop = 2 * PI * loop_r + (connectors-1) * cell_size() * 2
             ) cable_l / length_per_loop;

cylinder(
        h = base
)
