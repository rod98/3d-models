use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>

ring_width =  10;
logo_width =   6;
logo_rad   =  35;
scale_coef = 1.2;

b2r_cyl_len = 5;

cyl_conn_length = 10;

module con_b2r() {
    cuboid([cyl_conn_length, 20, logo_width]);
}

module logo(radius, width, wall) {
    translate([radius + b2r_cyl_len, 0, 0])
        rotate([0, -90, 0])
            cylinder(b2r_cyl_len, 3, logo_width / 2);
    
    translate([radius + cyl_conn_length/2 + b2r_cyl_len, 0, 0])
        con_b2r();
    
    translate([0, 0, -width/2])
        tube(h=width, or=radius, wall=wall);
    
    rotate([0, 0, -30]) {
        difference() {
            translate([0, 0, -width/2])
                box_extrude(width, 0.1, width)
                    polygon(shape_star(radius + 1, 5, 3));
            
            translate([0, 0, -(width * 1.1)/2])
                tube(
                    h=width * 1.1, 
                    or=radius * 1.11, 
                    wall=wall + radius * 0.1
                );
        }
    }        
}

module star(width) {
    box_extrude(width, 0.1, width)
        polygon(shape_star(30, 27, 16));
}

module whole_part() {
    difference() {
        union() {
            star(ring_width);

            translate([0, 0, -10])
                cyl(l=80, d=40, fillet=10);

            //translate([0, 0, 30])
              //  cylinder(5, 3, logo_width / 2);

            translate([0, 0, -70]) {
                difference() {
                    cuboid([10, 38, 70]);
                    cuboid([11, 28, 60]);
                }
            };

            translate([0, 0, -90])
                rotate([0, 15, 0])
                    translate([5, 0, 0])
                        cuboid([5, 10, 25]);
        }
        scale([1.1, 1.1, 1.1])
            translate([0, 0, logo_rad ]) {
                rotate([0, 90, 0])
                    con_b2r();
        }
    }
}

module connector1() {
    height=15;
    translate([0, 0, height/2])
        cuboid([5, 25, height]);
}

scale([0.1, 0.1, 0.1]) {
    translate([200, 0, logo_width/2])
        logo(logo_rad, logo_width, 6);
    
    translate([0, 0, 105])
        union() {
            difference() {
                whole_part();
                translate([0, 0, 60])
                    cuboid([100, 100, 120]);
            }
           connector1();
        }
    
    translate([100, 0, 0])
        difference() {
            intersection() {
                whole_part();
                translate([0, 0, 60])
                    cuboid([100, 100, 120]);
            }
            scale([scale_coef, scale_coef, scale_coef])
                connector1();
        }
}
