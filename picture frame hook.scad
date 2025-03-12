$fn= $preview ? 32 : 64;

l=40;
w=20;
t=8;

dl=3;
dw=2;
n = 2*3;

tooth_l = n*dl;
margin = (l-tooth_l)/2;

difference() {
        union() {
                linear_extrude(dl)
                polygon([
                        for(i=[0:2*n])[i*dl/2, i%2 * dw],
                        [n*dl, margin], [n*dl+margin, margin], [n*dl+margin, -margin],
                        [-margin, -margin], [-margin, margin], [0, margin]
                ]);

                translate([-margin, -margin, 0]) cube([margin, 2 * margin, t]);
                translate([-2*margin+l, -margin, 0]) cube([margin, 2 * margin, t]);
        }

        translate([-margin/2, 0, 0]) {
                cylinder(d=dl, h=t);
                cylinder(d1=2*dl, d2=dl, h=dl);
        }
        translate([l-3*margin/2, 0, 0]) {
                cylinder(d=dl, h=t);
                cylinder(d1=2*dl, d2=dl, h=dl);
        }
}
