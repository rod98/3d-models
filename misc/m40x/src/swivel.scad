//use <dotSCAD/shape_star.scad>
//use <dotSCAD/box_extrude.scad>
include <BOSL2/std.scad>
use <BOSL2/shapes3d.scad>

//use <BOSL/shapes.scad>

fn = 90;

body_len = 13.4;
hor_grabber_len = 16.4;

alpha=1;

hor_grabber_rad = 11;

module torus_quarter(r_maj) {
//    difference() {
    translate([0, 0, -1])
    diff()
    torus(
        r_min=1, r_maj=r_maj, 
        orient=FRONT, anchor=FRONT, $fn=fn
    ) {
        align(CENTER, CENTER, inside=true)
        pie_slice(10, 10, 270, spin=-90, orient=TOP);
    }
}

module part() {
    translate([0.01, 0, -0.28])
        import("./og.stl");
}

module angle_stopper() {
    // Original values:
    // r = 7.855;
    // main_cutoff_dist = 5.5;
    
    r = hor_grabber_rad;
    main_cutoff_dist = 5.5;
    side_cutoff_dist = hor_grabber_len / 2;
    
    h = 2.7;
    
    r_vlim = 7.78;
    
    color("lightblue", alpha=alpha)
    translate([0, 5.5, 10.4638]) 
    {
        // the upper wider part
        difference()
        {
            cyl(h, r=r, anchor=BACK, $fn=fn);
            
            // wire hole - cannot make it small, 
            // because it starts bending at this point
            translate([0, -main_cutoff_dist, 0])
                cyl(h+1, d=2.8, $fn=fn);
            
            // limiting the sizes
            translate([0, -main_cutoff_dist, 0])
                cube([r * 4, 50, h+1], anchor=BACK);
            
            translate([side_cutoff_dist, 0, 0])
                cube([20, 20, h+1], anchor=LEFT);
            
            translate([-side_cutoff_dist, 0, 0])
                cube([20, 20, h+1], anchor=RIGHT);
        }
        
        // the lower part that is almost part of the body
        difference() 
        {
            cyl(4.2, r=r_vlim, anchor=BACK+TOP, $fn=fn);
            translate([-body_len/2, 0, 1])
                cube([80, 80, 10], anchor=RIGHT+TOP);
            translate([body_len/2, 0, 1])
                cube([80, 80, 10], anchor=LEFT+TOP);
            translate([0, -main_cutoff_dist, 1])
                cube([r * 4, 50, 10], anchor=BACK+TOP);
            
            translate([0, 3.48, -5])
                rotate([-55, 0, 0])
                    cube([15, 10, 15], center=true);
            
            // wire hole - cannot make it small, 
            // because it starts bending at this point
            translate([0, -main_cutoff_dist, 0])
                cyl(h+10, d=3, $fn=fn);
        }
    }
}

module body() {
    color("blue", alpha=alpha) 
    {
        cyl_r = 7.98/2;
        
        hor_axis_dv = -0.327;
        hor_axis_len = 23.6;
        
        y_mov = -2.4995;
        
        translate([0, y_mov, 0])
        difference()
        {
            union()
            {
                translate([body_len/2, 0, cyl_r])
                {
                    cyl(r=cyl_r, h=body_len, orient=LEFT, anchor=BOTTOM, $fn=fn);
                    
                    translate([(13 - body_len) / 2 + 3.55, 0, hor_axis_dv]) {
                        cyl(d=3.7, h=hor_axis_len, anchor=BOTTOM, orient=LEFT, $fn=fn);
                    }
                }
                
                translate([0, 0, cyl_r])
                    cube([body_len, 8, 11.82-cyl_r], anchor=BOTTOM);
            }
            
            // wire hole
            translate([body_len/2 + 3.55, 0, cyl_r + hor_axis_dv])
            {
                color_this("white")
                cyl(d=2, h=4, anchor=BOTTOM, orient=LEFT, $fn=fn);
                
                color_this("aliceblue")
                translate([-4, 0, 0])
                    rotate([-17, 0, 0])
                    torus_quarter(6.08);
            }
            
            translate([0, -3.5, cyl_r * 2 - 0.7])
                cyl(d=5, h=200, $fn=fn, orient=BACK, anchor=TOP);
        }
    }
}

module vaxis() {
    base_d = 9.07;
    mid_d  = 7.42;
    
    inner_d = 5.0;
    inner_h = 7.75;
    
    color_this("green") 
    difference()
    {
        translate([0, 0, 11.8]) {
            cyl(d=base_d, h=3.5, $fn=fn, anchor=BOTTOM) {
                align(TOP, CENTER) {
                    color("pink", alpha=alpha) 
                    cyl(d=mid_d, h=2.0, $fn=fn, anchor=BOTTOM) {
                        align(TOP, CENTER)
                        pie_slice(
                            d=mid_d, h=4.0, 
                            anchor=BOTTOM,
                            spin=-210,
                            ang=130
                        );
                    }
                    
                    color("yellow", alpha=alpha)
                    cyl(d=inner_d, h=inner_h, $fn=fn, anchor=BOTTOM) {
                        align(TOP, CENTER)
                        cyl(
                            d1=inner_d, d2=7.4, h=0.35, 
                            $fn=fn, anchor=BOTTOM
                        ) {
                            align(TOP, CENTER)
                                cyl(
                                    d=7.4, h=1.2, 
                                    $fn=fn, anchor=BOTTOM
                                );
                        }
                    }
                }
            }
        }
        cyl(l=200, d=2, $fn=fn);
    }
}

translate([0, 16, 0]) {
    angle_stopper();
    part();
}

module remake() {
    vaxis();
    difference() 
    {
        body();
        translate([0, 0.1, 12.2]) {
            rotate([-16.7, 0, 0])
            cyl(d=2, h=3.3, $fn=fn, anchor=TOP);
        }
    }
    angle_stopper();
}

//half_of(BOTTOM, cp=[0, 0, 11.5])
//difference() 
{
//    cuboid(100);
    remake();
}





