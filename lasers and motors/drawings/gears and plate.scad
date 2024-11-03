
bearing_outer_bore = 19/2;
buffer = 1/2;

module tooth(degree,radius) {
    points = [ [0,-2] , [0,2] , [3.8,0.1], [3.8,-0.1] ];
    x = radius * cos(degree);
    y = radius * sin(degree);
    translate([x,y,0]) {
        rotate([0,0,degree]) {
            linear_extrude(height = 2) {
                polygon(points);
            }
        }
    }
}

module gear_with_bearing(teeth, thickness, inner_bore, outer_bore) {
    difference() {

        cylinder(thickness,outer_bore,outer_bore,$fn = 100);
        translate([0,0,-1]) {
            cylinder(thickness+2,inner_bore,inner_bore,$fn = 20);
    
        }
        translate([0,0,1]) {
            cylinder(thickness,bearing_outer_bore,bearing_outer_bore, $fn = 70);
        }
    }
    deg = 360/teeth;
    for (i = [deg:deg:360]) {
        tooth(i,outer_bore-.5);
    }
}

module drive_gear(teeth, thickness, inner_bore, outer_bore) {
    difference() {

        cylinder(thickness,outer_bore,outer_bore,$fn = 100);
        translate([0,0,-1]) {
            cylinder(thickness+2,inner_bore,inner_bore,$fn = 20);
            
        }
    }
    deg = 360/teeth;
    for (i = [deg:deg:360]) {
        tooth(i,outer_bore-1);
    }
}

module base(width, length) {
    base_points = [ [0,0],[length,0],[length,width],[0,width] ];
    cutout_width = 22.6;
    cutout_len = 12.3;
    axel_x = 5 + cutout_len/2 + 21.8;
    axel_y = 21;
    cutout_points = [ [0,0],[cutout_len,0],[cutout_len,cutout_width],[0,cutout_width]];
    difference() {
        linear_extrude(height=2) {
            polygon(base_points);
        }
        translate ([5,5,-1]) {
            linear_extrude(height=4) {
                polygon(cutout_points);
            }
        }
    }
    translate([axel_x,axel_y,0]) {
        difference() {
            cylinder(h=11.3,r=bearing_outer_bore + buffer, $fn=100);
            translate([0,0,10.3]) {
                cylinder(h=2, r=bearing_outer_bore + 0.1);
            }
            translate([0,0,-1]) {
                cylinder(20,1.4,$fn=20);
            }
        }
    }
}

base(33,43);

//translate([-50,0,0]) {
//    gear_with_bearing(20,3.6,1.4,bearing_outer_bore + buffer);
//}

//translate ([0,-50,0]) {
//    drive_gear(24,2,1.4,bearing_outer_bore + (8*buffer));
//}