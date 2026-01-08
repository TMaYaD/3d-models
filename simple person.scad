$fn = 100;

w = 20;
h = 58;
nw = 3;
nh = -2;

bh = h - nh - 3 * w / 2;
cylinder(h = bh, d = w);

translate([0, 0, bh])
    sphere(d = w);

translate([0, 0, bh])
    cylinder(h = w + nh, d = nw);

translate([0, 0, h-w/2])
    sphere(d = w);
