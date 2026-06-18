use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>
use <conn.scad>

module gear(radius, height) {
    box_extrude(height, 0.1, radius)
        polygon(shape_star(radius, radius * 0.85, 16));
}

module body_cyl_up(radius, height) {
    sc = 100;
    
    sc_radius = sc * radius;
    sc_height = sc * height;
    
    fl = min(sc_height, sc_radius)/2;
    translate([0, 0, height/2])
        scale(1/sc)
            cyl(l=sc_height, d=sc_radius * 2, fillet2=fl);
}

module body_cyl_down(radius, height) {
    sc = 100;
    
    sc_radius = sc * radius;
    sc_height = sc * height;
    
//    fl = min(sc_height, sc_radius)/2;
    translate([0, 0, height/2])
        scale(1/sc)
            cyl(l=sc_height, d=sc_radius * 2); //, fillet1=fl);
}

module body_up(radius, gear_radius, uppper_height, gear_height, logo_width, conn2logo, tolerance=0.2) {    
    full_height = uppper_height + gear_height;
    
    difference() {
        union()
        {
            gear(gear_radius, gear_height);
            body_cyl_up(radius, full_height);
        }
        
        translate([-conn2logo.x/2, -logo_width/2, full_height - conn2logo.y])
            conn_fem([conn2logo.x, logo_width, conn2logo.y], tolerance);
    }
}

module body_down(
    radius, 
    bottom_height, 
    logo_width, 
    conn2logo, 
    conn2tail,
    conn_bump,
    tolerance=0.2
) { 
    sc = 100;
    full_height = bottom_height;
    
    union() {
        difference() {
            union() {
                body_cyl_down(radius, full_height);
            }
            
            translate([-conn2logo.x/2, -logo_width/2, full_height - conn2logo.y])
                conn_fem([conn2logo.x, logo_width, conn2logo.y], tolerance);
        }
        //echo(conn2tail);
        translate([0, 0, -conn2tail.z/2])    
            translate(-conn2tail/2)
                conn_mal(conn2tail, tolerance);
        
        translate([0, 0, -conn_bump - conn2tail.y*1.5/2])
            scale(1/sc)
                rotate([00, 90, 0])
                    cyl(l=conn2tail.x * sc, d=sc * conn2tail.y * 1.5);
    }
}


//body_up(
//    radius=30, 
//    gear_radius=45, 
//    uppper_height=15, 
//    gear_height=10, 
//    logo_width=10, 
//    conn2logo=[30, 50]
//);

//translate([10, 0, 0])

logo_conn_len = 100;

c_logo2body = [
    2, 
    logo_conn_len
];
c_body2down = [
    c_logo2body.x, 
    20 / 1.8
];
c_body2tail=[4.8, 2.0, 8];


body_down(
    radius=5.2/2, 
    bottom_height=5,  
    logo_width=2, 
    conn2logo=[1, 30],
    conn2tail=c_body2tail,
    conn_bump=3
);