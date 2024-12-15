// Higher definition curves
$fn = $preview ? 32 : 64;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate =
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}

charger_l = 153;
charger_w = 75;
charger_h = 15;

module charger() {
    color("gray")
    roundedcube([charger_l, charger_w, charger_h], center = true, radius = 4);
}

usb_c_adapter_l1 = 21.6;
usb_c_adapter_w1 = 13;
usb_c_adapter_h1 = 9;

usb_c_adapter_l2 = 9;
usb_c_adapter_w2 = 10+50;
usb_c_adapter_h2 = 5;

usb_c_adapter_offset1 = 1.2;



module usb_c_adapter() {
    // Female connector end
    roundedcube([usb_c_adapter_w1, usb_c_adapter_h1, usb_c_adapter_l1], true, usb_c_adapter_h1/2, "z");

    // Extension for hole in base
    color("red")
    translate([0, 0, - usb_c_adapter_l1])
      roundedcube([usb_c_adapter_w1, usb_c_adapter_h1, usb_c_adapter_l1], true, usb_c_adapter_h1/2, "z");

    // usb c male connector
    translate([(usb_c_adapter_l2+usb_c_adapter_w1/2)/2, 0, usb_c_adapter_l1/2 - usb_c_adapter_w2/2 - usb_c_adapter_offset1])
      roundedcube([usb_c_adapter_l2+usb_c_adapter_w1/2, usb_c_adapter_h2, usb_c_adapter_w2], true, usb_c_adapter_h2/2, "xmax");
}

usb_a_connector_x = 24;
usb_a_connector_y = 16.1;
usb_a_connector_z = 30.2;
usb_a_connector_bridge_x = 0; //7.5;
usb_a_connector_bridge_z = 2.6;


module usb_a_adapter() {
        color("blue")
    difference() {
        cube([usb_a_connector_x, usb_a_connector_y, usb_a_connector_z], true);
        translate([0,0,usb_a_connector_bridge_z])
          cube([usb_a_connector_bridge_x, usb_a_connector_y + .1, usb_a_connector_z - 2 * usb_a_connector_bridge_z + .1], true);
    }
}


charger_usb_c_connector_offset1 = 15;
charger_usb_c_connector_offset2 = 4.8;

charger_usb_a_connector_offset_x = 8.4;
charger_usb_a_connector_offset_y = 14.6;
charger_usb_a_connector_offset_z = 5;

module charger_with_adapter() {
    charger();
    translate([-charger_l/2-charger_usb_c_connector_offset1+6, -charger_w/2+usb_c_adapter_l1/2+charger_usb_c_connector_offset2, 0])
      rotate([-90, 0, 0])
      usb_c_adapter();

    translate([-charger_l/2-charger_usb_a_connector_offset_x+usb_a_connector_z/2, charger_w/2-charger_usb_a_connector_offset_y-usb_a_connector_y/2,charger_h/2-charger_usb_a_connector_offset_z-usb_a_connector_x/2])
      rotate([0, 90, 0])
      usb_a_adapter();
}

base_l1 = 45;
base_l2 = 80;
base_w = 87.5;
base_h1 = 11;
base_h2 = 21;
base_r = 4;

module base() {
    color("black")
    roundedcube([base_l1, base_w, base_h1], center = true, radius=base_r, apply_to="all");
    rotate([0,7,0])
        translate([0,0,9.5])
        difference() {
            roundedcube([base_l1, base_w, base_h2], center = true, radius=base_r, apply_to="zmax");
            polyhedron(//pt 0        1        2        3        4        5
              points=[[-base_l1/2, base_w/2,-base_h2/2], [-base_l1/2, -base_w/2,-base_h2/2], [base_l1/2,-base_w/2,-base_h2/2], [base_l1/2,base_w/2, -base_h2/2], [base_l1/2,base_w/2, -base_h2/2+base_r], [base_l1/2,-base_w/2,-base_h2/2+base_r]],
              faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
              );
        }

    translate([base_l1/2+base_l2/2-base_r*2,base_w/2-base_h1/2,0])
        roundedcube([base_l2, base_h1, base_h1], center = true,radius=base_r, apply_to="all");
    translate([base_l1/2+base_l2/2-base_r*2,-(base_w/2-base_h1/2),0])
        roundedcube([base_l2, base_h1, base_h1], center = true, radius=base_r, apply_to="all");
    translate([base_l1/2+base_l2-base_h1,0,0])
        roundedcube([base_h1, base_w, base_h1], center = true, radius=base_r, apply_to="all");


}

phone_offset = 3;

module phone() {
    color("white")
    roundedcube([charger_l + phone_offset * 2, base_w, charger_h], center=true, radius=2, apply_to="y");
}

difference() {
  union() {
    color("black")
    base();
    translate([23,0,30])
      rotate([0, -60, 0])
          roundedcube([40, charger_w-base_r*2, 8], true, 4);
  }
  translate([45,0,78])
    rotate([0,-60,0])
    union() {
        charger_with_adapter();
        translate([0,0,charger_h-.1])
            phone();
    }
}
