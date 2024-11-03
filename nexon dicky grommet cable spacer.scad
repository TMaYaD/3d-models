$fn = $preview ? 32 : 64;

od = 27; //36;
id = 25;
cable_dia = 4;

insert_length = 3;
wall_size = 1;

module spacer(id, od, cable_dia){
        difference() {
                cylinder(d=od, h=cable_dia);
                cylinder(d=id-2*wall_size, h=cable_dia);
                translate([0, -cable_dia/2, 0]) cube([od, cable_dia, cable_dia]);
        }
}

module female_connector(d, h, wall_size, od = 0) {
        od = od == 0 ? d + wall_size * 2 : od;
        difference() {
                cylinder(d=od, h);
                cylinder(d=d, h);

                translate([0,0,h/2]) rotate_extrude() {
                        polygon(points=[[d/2,-wall_size/2],[d/2+wall_size/2,0],[d/2,wall_size/2]], paths=[[0,1,2]]);
                }
        }
}

module male_connector(d, h, wall_size, divisions=4, division_gap=0) {
        division_gap = division_gap > 0 ? division_gap : h;

        difference() {
                cylinder(d=d+wall_size*2, h);
                cylinder(d=d-wall_size*2, h);
                minkowski() {
                        female_connector(d, h, wall_size);
                        sphere(d=0.1);
                }

                for ( i = [0 : divisions] ){
                        rotate( i * 360/divisions) translate([0, -division_gap/2, 0]) cube([d, division_gap, h]);
                }
        }
}
translate([0, 0, insert_length + cable_dia]) female_connector(id, insert_length, wall_size, od=od);
translate([0, 0, insert_length]) spacer(id, od, cable_dia);
male_connector(id, insert_length, wall_size, division_gap=cable_dia);


