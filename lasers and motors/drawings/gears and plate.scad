
bearing_outer_bore = 19/2;
buffer = 1/2;

module tooth(degree,radius,h) {
    points = [ [0,-2] , [0,2] , [3.8,0.1], [3.8,-0.1] ];
    x = radius * cos(degree);
    y = radius * sin(degree);
    translate([x,y,0]) {
        rotate([0,0,degree]) {
            linear_extrude(height = h) {
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
        translate([0,0,thickness-3.2]) {
            cylinder(thickness,bearing_outer_bore,bearing_outer_bore, $fn = 70);
        }
    }
    deg = 360/teeth;
    for (i = [deg:deg:360]) {
        tooth(i,outer_bore-.5,thickness - 2);
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
        tooth(i,outer_bore-1,2);
    }
}

module base(width, length) {
    base_points = [ [0,0],[length,0],[length,width],[0,width] ];
    cutout_width = 23;
    cutout_len = 12.8;
    axel_x = 5 + cutout_width/2 + 31; // two gears added 10.6 + 24.94 + buffer
    axel_y = 21.2;
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
        translate([axel_x,axel_y,-5]) {
            cylinder(20,1.7,$fn=20);
        }
        translate([5+cutout_len/2,2.5,-1]) {
            cylinder(5,1,1,$fn=20);
        }
        translate([5+cutout_len/2,width-2.5,-1]) {
            cylinder(5,1,1,$fn=20);
        }
    }
    translate([axel_x,axel_y,0]) {
        difference() {
            cylinder(h=15,r=bearing_outer_bore + buffer+.2, $fn=1000);
            translate([0,0,13.7]) {
                cylinder(h=2, r=bearing_outer_bore + 0.2,$fn=200);
            }
            translate([0,0,-5]) {
                cylinder(20,1.7,$fn=200);
            }
        }
    }
}

translate([50,0,-6]) {
    base(33,64);
}


module gear_platform(length,width) {
    base_points = [ [0,0],[length,0],[length,width],[0,width] ];
    hole_width=2;
    base_hole = [ [-1,width-8],[length/2,width-8],[length/2,width-(8+hole_width)], [-1,width-(8+hole_width)]];
    base_support = [ [0,width-8],[length/2,width-8],[length/2,width-(8+hole_width)], [0,width-(8+hole_width)],[0,width-(10+hole_width)],[length/2 + 2,width-(10+hole_width)],[length/2+2,width-6],[0,width-6]];

    difference() {
        union() {
            linear_extrude(height=2) {
                polygon(base_points);
            }
            linear_extrude(height=6) {
                polygon(base_support);
            }
        }
        translate([0,0,-1]) {
            linear_extrude(height=4) {
                polygon(base_hole);
            }
        }
        translate([10,45,4]) {
            rotate([90,0,0]) {
                cylinder(10,1,1);
            }
        }
    }
    
    
    translate([length/2,15,2]) {
      gear_with_bearing(20,7,1.4,bearing_outer_bore + buffer);
    }
}
translate([0,50,-5]) {
    gear_platform (25,50);
}

translate ([0,0,-6]) {
    drive_gear(50,2,1.4,bearing_outer_bore + (27*buffer));
}

/**
 *  Parametric servo arm generator for OpenScad
 *  Générateur de palonnier de servo pour OpenScad
 *
 *  Copyright (c) 2012 Charles Rincheval.  All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *  Last update :
 *  https://github.com/hugokernel/OpenSCAD_ServoArms
 *
 *  http://www.digitalspirit.org/
 */

$fn = 40;

/**
 *  Clear between arm head and servo head
 *  With PLA material, use clear : 0.3, for ABS, use 0.2
 */
SERVO_HEAD_CLEAR = 0.2;

/**
 *  Head / Tooth parameters
 *  Futaba 3F Standard Spline
 *  http://www.servocity.com/html/futaba_servo_splines.html
 *
 *  First array (head related) :
 *  0. Head external diameter
 *  1. Head heigth
 *  2. Head thickness
 *  3. Head screw diameter
 *
 *  Second array (tooth related) :
 *  0. Tooth count
 *  1. Tooth height
 *  2. Tooth length
 *  3. Tooth width
 */
FUTABA_3F_SPLINE = [
    [4.87, 4, 1.1, 2.5],
    [25, 0.3, 0.7, 0.2]
];

module servo_futaba_3f(length, count) {
    servo_arm(FUTABA_3F_SPLINE, [length, count]);
}

/**
 *  If you want to support a new servo, juste add a new spline definition array
 *  and a module named like servo_XXX_YYY where XXX is servo brand and YYY is the
 *  connection type (3f) or the servo type (s3003)
 */

module servo_standard(length, count) {
    servo_futaba_3f(length, count);
}

/**
 *  Tooth
 *
 *    |<-w->|
 *    |_____|___
 *    /     \  ^h
 *  _/       \_v
 *   |<--l-->|
 *
 *  - tooth length (l)
 *  - tooth width (w)
 *  - tooth height (h)
 *  - height
 *
 */
module servo_head_tooth(length, width, height, head_height) {
    linear_extrude(height = head_height) {
        polygon([[-length / 2, 0], [-width / 2, height], [width / 2, height], [length / 2,0]]);
    }
}

/**
 *  Servo head
 */
module servo_head(params, clear = SERVO_HEAD_CLEAR) {

    head = params[0];
    tooth = params[1];

    head_diameter = head[0];
    head_height = head[1];
    //head_heigth

    tooth_count = tooth[0];
    tooth_height = tooth[1];
    tooth_length = tooth[2];
    tooth_width = tooth[3];

    % cylinder(r = head_diameter / 2, h = head_height + 1);

    cylinder(r = head_diameter / 2 - tooth_height + 0.03 + clear, h = head_height);

    for (i = [0 : tooth_count]) {
        rotate([0, 0, i * (360 / tooth_count)]) {
            translate([0, head_diameter / 2 - tooth_height + clear, 0]) {
                servo_head_tooth(tooth_length, tooth_width, tooth_height, head_height);
            }
        }
    }
}

/**
 *  Servo hold
 *  - Head / Tooth parameters
 *  - Arms params (length and count)
 */
module servo_arm(params, arms) {

    head = params[0];
    tooth = params[1];

    head_diameter = head[0];
    head_height = head[1];
    head_thickness = head[2];
    head_screw_diameter = head[3];

    tooth_length = tooth[2];
    tooth_width = tooth[3];

    arm_length = arms[0];
    arm_count = arms[1];

    /**
     *  Servo arm
     *  - length is from center to last hole
     */
    module arm(tooth_length, tooth_width, reinforcement_height, head_height, hole_count = 1) {
        arm_screw_diameter = 2;

        difference() {
            union() {
                cylinder(r = tooth_width / 2, h = head_height);

                linear_extrude(height = head_height) {
                    polygon([
                        [-tooth_width / 2, 0], [-tooth_width / 3, tooth_length],
                        [tooth_width / 3, tooth_length], [tooth_width / 2, 0]
                    ]);
                }

                translate([0, tooth_length, 0]) {
                    cylinder(r = tooth_width / 3, h = head_height);
                }

                if (tooth_length >= 12) {
                    translate([-head_height / 2 + 2, head_diameter / 2 + head_thickness - 0.5, -4]) {
                        rotate([90, 0, 0]) {
                            rotate([0, -90, 0]) {
                                linear_extrude(height = head_height) {
                                    polygon([
                                        [-tooth_length / 1.7, 4], [0, 4], [0, - reinforcement_height + 5],
                                        [-2, - reinforcement_height + 5]
                                    ]);
                                }
                            }
                        }
                    }
                }
            }

            // Hole
            for (i = [0 : hole_count - 1]) {
                //translate([0, length - (length / hole_count * i), -1]) {
                translate([0, tooth_length - (4 * i), -1]) {
                    cylinder(r = arm_screw_diameter / 2, h = 10);
                }
            }

            cylinder(r = head_screw_diameter / 2, h = 10);
        }
    }

    difference() {
        translate([0, 0, 0.1]) {
            cylinder(r = head_diameter / 2 + head_thickness, h = head_height + 1);
        }

        cylinder(r = head_screw_diameter / 2, h = 10);

        servo_head(params);
    }

    arm_thickness = head_thickness;

    // Arm
    translate([0, 0, head_height]) {
        for (i = [0 : arm_count - 1]) {
            rotate([0, 0, i * (360 / arm_count)]) {
                arm(arm_length, head_diameter + arm_thickness * 2, head_height, 2);
            }
        }
    }
}

module demo() {
    rotate([0, 180, 0])
        servo_standard(20, 4);
}
 demo();