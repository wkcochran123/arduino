
bearing_outer_bore = 17;

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
            cylinder(thickness,bearing_outer_bore,bearing_outer_bore, $fn = 40);
        }
    }
    deg = 360/teeth;
    for (i = [deg:deg:360]) {
        tooth(i,outer_bore-1);
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
        translate( [40,20,1] ) {
            cylinder(h=2,r=bearing_outer_bore);
        }
    }

}

base(50,60);

translate([-50,0,0]) {
    gear_with_bearing(35,2,1.6,20);
}

translate ([0,-50,0]) {
    drive_gear(50,2,2,25);
}