$fn = $preview ? 16 : 64;

w = 20+0.5;
h1 = 14 + 0.5;
h2 = 22;

module profile(l = 100, fill = false) {
        T = 1.4;

        difference() {
                cube([l, h2, w]);
                translate([0, T, 0]) cube([l, h2-h1-T, h2-h1-T]);
                if (!fill) {
                        translate([0, h2-h1+T, T]) cube([l, h1-2*T, w-2*T]);
                        translate([0, T, h2-h1]) cube([l, h2-h1, w-h2+h1-T]);
                }
                prism(w, h2, w);
        }
}

module prism(l, w, h){
      polyhedron(//pt 0        1        2        3        4        5
              points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,0,h], [0,w,h]],
              faces=[[0,1,2,3],[0,4,5,3],[1,2,5,4],[0,1,4],[5,2,3]]
              );
}

T = 3;

offset = 50; //143 for side clips

l = w + offset + 44 + 10;

delta = 0.4;

difference() {
        translate([-h2+h1, h2-h1-T, -T]) cube([l-w+h2-h1, h1 + 2 * T, w + 2 * T]);
        translate([-w, 0, 0]) profile(l = l, fill = true);
        translate([offset, h2-11.4-delta, -T]) cube([44, 11.4+delta, T]);
        translate([offset, h2-delta, -T]) cube([44, T+delta, 1.4 + T + delta]);
        translate([offset+11, h2, -T]) cube([22, T, 17 + T+delta]);
        translate([offset+6.5, h2+T, 1.4+6+delta]) rotate([90, 0, 0]) cylinder(h = T, d = 7);
        translate([offset+6.5+31, h2+T, 1.4+6+delta]) rotate([90, 0, 0]) cylinder(h = T, d = 7);
}

        // color("black", 0.7) translate([-w, 0, 0]) profile(l = l);

