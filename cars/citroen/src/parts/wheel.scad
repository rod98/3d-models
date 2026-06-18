use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>


module wheel() {
    sc = 100;

    middle_width = 5.8;
    middle_rad   = 21 / 2;

    total_width  = 8.5;
    outer_rad    = 19.8 / 2;
    
    central_cutout_rad   = 17.7 / 2;
//    central_cutout_width = 2.5;
    
    central_cutout_width = total_width - middle_width;

    cutout_df  = total_width/2;
    hole_count = 10;
    
    hole_out_radius = outer_rad - 2;
    hole_inn_radius = 12.5 / 2;
    
    cap_width = 6;
    
    scale(1/sc) {        
        difference() {
            union() {
                cyl(l=middle_width * sc, r=middle_rad * sc, fillet=0.3 * sc);
                cyl(l=total_width  * sc, r=outer_rad  * sc);
            }
            
            union() {
                translate([0, 0, cutout_df * sc])
                    cyl(l=central_cutout_width*2 * sc, r=central_cutout_rad * sc, fillet=2 * sc);
                
    //            translate([0, 0, -cutout_df])
    //                cyl(l=central_cutout_width*2, r=central_cutout_rad, fillet=1);
                
                angle = 360/hole_count * 5/9;
                translate([0, 0, -total_width * sc/2]) {
                    for (i = [1:hole_count]) {
                        difference() {
                            rotate([0, 0, i * 360/hole_count])
                                pie_slice(ang=angle, l=total_width * sc, r=hole_out_radius * sc);
                            translate([0, 0, total_width * sc/2])
                                cyl(r=hole_inn_radius * sc, h=total_width * sc);
                        }
                    }
                }
            }
        }    
        
        insert_rad_top1      = 9.5/2;
        insert_rad_top1_bord = 10/2;
        
        insert_rad_top2_bord_bott  = 8.5/2;
        insert_rad_top2_bord_up    = 8  /2;
        insert_width_top2_bord     = 0.8;
        
        insert_width_top2 = 11 - total_width - 0.8 - insert_width_top2_bord;
    //    insert_width_top2 = 11 - total_width - insert_width_top2_bord;
        
        translate([0, 0, (total_width - central_cutout_width) * sc/2]) {
            cyl(l=central_cutout_width * sc, r1=hole_inn_radius * sc, r2=insert_rad_top1 * sc);
            
            translate([0, 0, (central_cutout_width/2 - 0.5) * sc])
                cyl(l=1 * sc, r=insert_rad_top1_bord * sc);
            
            translate([0, 0, (central_cutout_width+insert_width_top2_bord) * sc/2])
                cyl(l=insert_width_top2_bord * sc, r1=insert_rad_top2_bord_bott * sc, r2=insert_rad_top2_bord_up * sc);
        }
//        translate([0, 0, ((total_width+insert_width_top2)/2+insert_width_top2_bord) * sc])
//            cyl(
//                l=insert_width_top2 * sc, 
//                r1=(insert_rad_top2_bord_up-0.2) * sc,
//                r2=1 * sc,
//                fillet2=0.35 * sc
//            );
        
        sphere_rad = 7;
        translate([0, 0, (total_width/2 + insert_width_top2 + 0.3) * sc])
            sphere(sc);
        
        translate([0, 0, ((total_width+insert_width_top2)/2-sphere_rad * 0.8) * sc]) {            
            difference() {
                sphere(sphere_rad * sc);
                translate([0, 0, (total_width-sphere_rad*4-sphere_rad/2)*sc/2-10])
                    cyl(l=sphere_rad * 5 * sc, r=sc * sphere_rad * 5);
            }
        }
    }
}

wheel();

