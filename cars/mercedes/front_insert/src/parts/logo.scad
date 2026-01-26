use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>
use <conn.scad>

module logo(radius, width, wall, conn) {
    conn_l = radius/8;
    
    scale_coef = 100;
    
    scaled_radius = scale_coef * radius;
    scaled_width  = scale_coef * width ;
    scaled_wall   = scale_coef * wall  ;
    scaled_cyl_l  = scale_coef * conn_l;
    
    scale([1/scale_coef, 1/scale_coef, 1/scale_coef]) {
        cylinder(scaled_cyl_l*1.1, scaled_width/2, scaled_width/2);
        translate([0, scaled_width/2, scaled_radius+scaled_cyl_l])
            rotate([90, 0, 0]) {
                tube(h=scaled_width, or=scaled_radius, wall=scaled_wall);
                
                difference() {
                    box_extrude(scaled_width, 0.1, scaled_width)
                        polygon(shape_star(scaled_radius*2, 0.2*scaled_radius, 3));
                
                    tube(
                        h=scaled_width, 
                        or=scaled_radius * 3, 
                        wall=scaled_radius * 2
                    );
                }
            }
    }
    translate([0, 0, -conn.y/2])
        cuboid([conn.x, width, conn.y]);
}

logo(35, 10, 15, [20, 100]);