//use <dotSCAD/shape_star.scad>
//use <dotSCAD/box_extrude.scad>
include <BOSL2/std.scad>
use <BOSL2/shapes3d.scad>

//use <BOSL/shapes.scad>

fn = 90;

body_len = 13.0;

alpha=1.5;

//module stencil() {
//    core_height = 12.8;
//    v_offset    = 12.1;
//    
//    key_h = 5;
//    key_w = 2.5;
//    difference()
//    {
//        translate([0, 0, v_offset + core_height / 2])
//        {
//            difference() {
//                cyl(l=core_height, d=10, $fn=fn);
//                cyl(l=core_height, d=4.5, $fn=fn);
//            }
//        }
//        translate([-3, -key_w/2, v_offset])
//            cube([3, key_w, key_h]);
//    }
//}

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
    
//        cube([20, 10, 10], anchor=BOTTOM);
//        cube([10, 10, 20], anchor=LEFT  );
//    }
}

module part() {
    translate([0.01, 0, -0.28])
        import("./og.stl");
}

module angle_stopper() {
    // Original values:
    // r = 7.855;
    // main_cutoff_dist = 5.5;
    
    r = 11;
    main_cutoff_dist = 5.5;
    side_cutoff_dist = 8.7;
    
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
    color("blue", alpha=alpha) {
        cyl_r = 7.98/2;
        
        hor_axis_dv = -0.327;
        hor_axis_len = 23.6;
        
        y_mov = -2.4995;
        
        translate([0, y_mov, 0])
        difference()
        {
            union()
            {
    //            Too complicated bruh
    //            cyl(r=cyl_r, h=13, orient=LEFT, anchor=LEFT, $fn=fn)
    //            {
    ////                position(BOTTOM) 
    ////                    translate([hor_axis_dv, 0, 0])
    ////                        cyl(l=3.5, d=3.7, anchor=TOP);
    //                
    //                align(BOTTOM, CENTER, inside=true) 
    //                    translate([hor_axis_dv, 0, 0])
    //                        cyl(l=3.5, d=2.7);
    //                
    //                position(TOP) 
    //                    translate([hor_axis_dv, 0, 0])
    //                        cyl(l=7, d=3.7, anchor=BOTTOM);
    //            };
                translate([body_len/2, 0, cyl_r])
                {
                    cyl(r=cyl_r, h=13.0, orient=LEFT, anchor=BOTTOM, $fn=fn);
                    
                    translate([3.55, 0, hor_axis_dv]) {
                        cyl(d=3.7, h=hor_axis_len, anchor=BOTTOM, orient=LEFT, $fn=fn);
                    }
                }
                
                translate([0, 0, cyl_r])
                    cube([13, 8, 11.82-4], anchor=BOTTOM);
            }
            
            // wire hole
            translate([body_len/2 + 3.55, 0, cyl_r + hor_axis_dv])
            {
//                color_this("white")
                cyl(d=2, h=4, anchor=BOTTOM, orient=LEFT, $fn=fn);
                
                translate([-4, 0, 0])
                    rotate([-15, 0, 0])
                    torus_quarter(6.08);
            }
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
        translate([0, 0, 13]) 
        rotate([-15, 0, 0])
        cyl(d=2, h=4.0, $fn=fn, anchor=TOP);
    }
    angle_stopper();
}

remake();




