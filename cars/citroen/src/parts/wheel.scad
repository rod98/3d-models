use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>


module wheel() {
    middle_width = 5.8;
    middle_rad   = 21 / 2;

    total_width = 8.5;
    outer_rad   = 19.8 / 2;
    
    central_cutout_rad   = 17.6 / 2;
//    central_cutout_width = 2.5;
    
    central_cutout_width = total_width - middle_width;

    cutout_df = total_width/2;
    
    hole_count = 10;
    
    hole_out_radius = outer_rad - 2;
    hole_inn_radius = 12.5 / 2;
    
    cap_width = 6;
    
    difference() {
        union() {
            cyl(l=middle_width, r=middle_rad, fillet=0.3);
            cyl(l=total_width , r=outer_rad);
        }
        
        union() {
            translate([0, 0, cutout_df])
                cyl(l=central_cutout_width*2, r=central_cutout_rad, fillet=2);
            
//            translate([0, 0, -cutout_df])
//                cyl(l=central_cutout_width*2, r=central_cutout_rad, fillet=1);
            
            angle = 360/hole_count * 5/9;
            translate([0, 0, -total_width/2]) {
                for (i = [1:hole_count]) {
                    difference() {
                        rotate([0, 0, i * 360/hole_count])
                            pie_slice(ang=angle, l=total_width, r=hole_out_radius);
                        translate([0, 0, total_width/2])
                            cyl(r=hole_inn_radius, h=total_width);
                    }
                }
            }
        }
    }    
    
    insert_rad_top1 = 9.5/2;
    insert_rad_top1_bord = 10/2;
    
    insert_rad_top2_bord = 8/2;
    insert_width_top2 = 11 - total_width;
    
//    translate([0, 0, middle_width/2]) {
    translate([0, 0, total_width/2 - central_cutout_width/2]) {
        cyl(l=central_cutout_width, r1=hole_inn_radius, r2=insert_rad_top1);
        
        translate([0, 0, central_cutout_width/2 - 0.5])
            cyl(l=1, r=insert_rad_top1_bord);
    }
    
}

wheel();

