$fn = $preview ? 32 : 64;

dia = 16;
cut_length = 9;
blade_thickness = 0.6;

wall_thickness = 3;
base_height = wall_thickness;
body_length = 18;
screw_hole_dia = 3;

module prism(l, w, h){
      polyhedron(//pt 0        1        2        3        4        5
              points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
              faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
              );
}

module jig() {
        difference() {
                // main body
                union() {
                        translate([0,-dia/2-wall_thickness,0]) cube([body_length+wall_thickness, dia + 2 * wall_thickness, dia/2 + wall_thickness]);
                        translate([0,0,dia/2+wall_thickness]) rotate([0, 90, 0]) cylinder(d=dia+2*wall_thickness, h = body_length + wall_thickness);
                }

                // channel for spacer
                translate([wall_thickness,0,dia/2+wall_thickness]) rotate([0,90,0]) cylinder(d=dia, h = body_length);

                // screw hole
                translate([0,0,dia/2+wall_thickness]) rotate([0,90,0]) cylinder(d=screw_hole_dia, h = wall_thickness);


                // open the top
                translate([wall_thickness, -dia/4, dia/2+wall_thickness]) cube([body_length, dia/2, dia/2+wall_thickness]);

                // cut off the corner
                translate([body_length+wall_thickness,dia/2+wall_thickness,2*wall_thickness]) rotate([90, 0, -90]) prism(dia+2*wall_thickness, dia, (body_length-cut_length)/2);

                // blade slot
                translate([cut_length+wall_thickness,-dia/2-wall_thickness,wall_thickness]) cube([blade_thickness, dia+2*wall_thickness, dia+wall_thickness]);

                // etch dimensions
                translate([wall_thickness + 1, -dia/3, wall_thickness/4])
                        rotate([180, 0, 0])
                        linear_extrude(wall_thickness/4)
                        text(str("Length: ", cut_length, "mm"), size=2, halign="left");
                translate([wall_thickness + 1, dia/3, wall_thickness/4])
                        rotate([180, 0, 0])
                        linear_extrude(wall_thickness/4)
                        text(str("Dia: ", dia, "mm"), size=2, halign="left");
        }
}
jig();
