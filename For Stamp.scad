$fn = 0.1;

text = ["For",
        "",
        "Prudhvi Enterprises"];

font_size = 4;
line_space = 2;
letter_height = 2;
length = 70;
height = 4;

function line_offset(n) = - n * (font_size + line_space) - line_space;

width = -line_offset(len(text));

module line(n) {
    translate([line_space, line_offset(n), height])
    linear_extrude(letter_height) {
    text(text[n], font_size, valign = "top");
    }
}

module stamp() {
    translate([0,-width,0])
        cube([length, width, height]);
    
    for ( i = [0 : 5] ) {
        line(i);
    }
}

// stamp();


tolarance = 0.01;

module cover() {
//    difference() {
        // cube([length + 2 * height, width + 2 * height, 2 * height + 2 * letter_height]);
        translate([0, 0, height * 2]) {
            offset(tolarance) {
                stamp();
            }
        }
            
  //  }
}

cover();
