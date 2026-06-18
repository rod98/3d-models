use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>

use <parts/body.scad>
use <parts/logo.scad>
use <parts/conn.scad>

tolerance  = 0.2;

logo_iwall =  1;
logo_width =  1;
logo_rad   =  5;

body_up_height = 2.6;
body_dn_height = 3.6;
body_up_radius = 4.8/2;
body_dn_radius = 5.2/2;
gear_radius    = 6.9/2;
gear_height    = 1.3;

logo_start_height = body_up_height + gear_height;

logo_conn_len = body_up_height + gear_height + body_dn_height / 2;

c_logo2body = [
    2, 
    logo_conn_len
];
c_body2down = [
    c_logo2body.x, 
    body_dn_height / 1.8
];
c_body2tail=[4.8, 2.0, 8];

module print() {
    body_up(
        radius=body_up_radius, 
        gear_radius=gear_radius, 
        uppper_height=body_up_height, 
        gear_height=gear_height, 
        logo_width=logo_width, 
        conn2logo=c_logo2body,
        tolerance=0.1
    );
    
    translate([20, 0, logo_width/2])
        rotate([90, 0, 0])
            logo(logo_rad, logo_width, logo_iwall, c_logo2body);
    
    translate([20, 20, body_dn_height])
        rotate([0, 180, 0])
            body_down(
                radius=body_dn_radius,
                bottom_height=body_dn_height, 
                logo_width=logo_width, 
                conn2logo=c_body2down,
                conn2tail=c_body2tail,
                conn_bump=3.1,
                tolerance=0.1
            );
}

module ass() {
    body_up(
        radius=body_up_radius, 
        gear_radius=gear_radius, 
        uppper_height=body_up_height, 
        gear_height=gear_height, 
        logo_width=logo_width, 
        conn2logo=c_logo2body,
        tolerance=0.1
    );

    translate([0, 0, logo_start_height])
        logo(logo_rad, logo_width, logo_iwall, c_logo2body);
    
    translate([0, 0, -body_dn_height])
        body_down(
            radius=body_dn_radius,
            bottom_height=body_dn_height, 
            logo_width=logo_width, 
            conn2logo=c_body2down,
            conn2tail=c_body2tail,
            tolerance=0.1
        );
    
}

print();

//translate([0, 20, 0])
//ass();
