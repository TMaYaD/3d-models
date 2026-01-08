$fn = 100;

module cable_cross_section(w, h){
        hull(){
                circle(d = w);
                translate([0, h - w, 0]) circle(d = w);
        }
}

module cable_cutout_cross_section(w, h, T = 1, bite = 1){
        difference(){
                offset(T) cable_cross_section(w, h);
                cable_cross_section(w, h);
                translate([-(w-bite)/2, h - w]) square([w-bite, T + w/2]);
        }
}

// cable_cutout_cross_section(3.5, 5, 1, 1);

module cable_cutout_array(w, h, n, offsets = [0, 0], T = 1){
        assert(is_list(offsets) && len(offsets) == 2);
        assert(is_list(n) && len(n) == 2 && n.x > 0 && n.y > 0);
        step_x = w + T;
        step_y = h + T;

        for(i = [0 : n.x - 1]){
                for(j = [0 : n.y - 1]){
                        translate([i * step_x + offsets.x + T + w/2, j * step_y + offsets.y +T + w/2]) cable_cutout_cross_section(w, h, T);
                }
        }
}

// cable_cutout_array(3.5, 5, [10, 10], T=1);

module corner_cutouts(r, w, h, n = [1, 1], T = 1){
        rotate_extrude(90)
                cable_cutout_array(w, h, n, T = T, offsets = [r, 0]);
}

corner_cutouts(25, 3.5, 5);

module edge_cutouts(l, w, h, n = [1, 1], T = 1){
        rotate([90, 0, 0])
        linear_extrude(l)
                cable_cutout_array(w, h, n, T = T);
}

edge_cutouts(25*2, 3.5, 5);

module spiral_cutouts(w, h, l, offsets = [0, 0, 0], d = 1){
        assert(is_list(offsets) && len(offsets) == 3);
        // SUM[i:0, n](2 * PI * (offset + step*i+w/2)) - l = 0
        // 2 * PI * (offset + w/2) * n + 2 * PI * step * n * (n-1) / 2 - l = 0
        // 2 * PI * (offset + w/2) * n + PI * step * n * (n-1) - l = 0
        // PI * step * n^2 + (2 * PI * offset - PI * d) * n - l = 0

        n = let(a = PI * (w + d), b = PI * (2 * offsets[0] - d), c = -l)
                ceil((-b + sqrt(b^2 - 4 * a * c)) / (2 * a));

        corner_cutouts(offsets[0], w, h, [n, 1], d);
        edge_cutouts(offsets[1], w, h, [n, 1], d);
}

module helical_cutouts(w, h, l, offset = 0, d = 1){
        // n * 2 * PI * (offset + w/2) = l
        n = ceil(l / (2 * PI * (offset + w/2)));

        cable_cutouts(offset, w, h, [1, n], d);
}

spiral_cutouts(3.5, 5, 350, [25, 0, 0], 1);
// helical_cutouts(3.5, 5, 350, 25, 1);
