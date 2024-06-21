// Measurements in mm

battery_width = 120;
battery_height_ex_switch = 30;
battery_depth = 26; // 25.5

// Rounding to make post bigger than holes
battery_short_post_outside = 27;  // 27.4
battery_short_post_inside = 21; // 21.5

battery_long_post_outside = 98; // 97.33
battery_long_post_inside = 91; // 91.62

battery_post_height = 6.3;

db_width = 84;
db_depth = 28;
db_height = 80;

db_short_post_outside = 49; // 48.3
db_short_post_inside = 43; // 43.75

db_long_post_outside = 68; // 68.0
db_long_post_inside = 63; // 63.7

mic_diameter = 9.57/2;
db_post_height = 8.4;
wall_width = 2;
inner_buffer = 15;

inner_width = battery_width;
inner_depth = battery_depth + inner_buffer + db_depth;
inner_height = db_height;

outer_width = inner_width + 2 * wall_width;
outer_height = inner_height + 2 * wall_width;
outer_depth = inner_depth + 2 * wall_width;

single_led_outside_distance = 7.7;
single_led_inside_distance = 1.7;
single_led_width = 3;
total_led_width = 60;
leds = 12;



module led_hole(x=0,y=0,z=0) {
    translate([x,y,z]) {
        cube([3.2,3,3.5]);
    }
}

module led_holes() {
    for(i = [0:1:12]) {
        led_hole(i*5,0,0);
    }
}

module led_post() {   
    rotate([90,0,0])
    translate([3,3,-db_post_height/2])
    difference() {
        cylinder(db_post_height,1.5,1.5,center=true);
        cylinder(db_post_height+5,1,1,center=true);
    }
}

module led_posts() {
    z_size = db_short_post_inside + (db_short_post_outside - db_short_post_inside)/2;
    x_size = db_long_post_inside + (db_long_post_outside - db_long_post_inside)/2;
    led_post();
    translate([x_size,0,0])
        led_post();
    translate([0,0,z_size])
        led_post();
    translate([x_size,0,z_size])
        led_post();
}

module writer(words) {
    rotate([90,0,0])
    linear_extrude(height=5)
    text(words, size=10, font="Noteworthy");
}

module led_board_side() {
    width = db_width + 2*wall_width;
    height = db_height + 2*wall_width;
    depth = db_depth + 2*wall_width;
    
    bottom_left_x = 3;
    bottom_left_z = 3;
    difference() {
        cube([width,depth,height]);
        translate([wall_width, wall_width, wall_width])
            cube([width-2*wall_width,depth, height-2*wall_width]);
        translate([bottom_left_x+5,-.001,bottom_left_z+10])
            led_holes();
        translate([5+wall_width,2+wall_width,10])
        translate([mic_diameter,mic_diameter+2,1])
            cylinder(500,mic_diameter,mic_diameter);
        translate([5,1,65])
            writer("WORLD");    
        translate([5,1,47.5])
            writer("DOMINATION");    
        translate([5,1,30])
            writer("INDUSTRIES");    
    }

    translate([bottom_left_x,0,bottom_left_z])
    led_posts();
}


rotate([90,0,0])
led_board_side();
