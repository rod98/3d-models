include <BOSL2/std.scad>
use <BOSL2/shapes3d.scad>

module torus_part(r_maj, r_min=1, angle=90, fn=90) {
//    difference() {
    translate([0, 0, -1])
    diff()
    torus(
        r_min=r_min, r_maj=r_maj, 
        orient=FRONT, anchor=FRONT, $fn=fn
    ) {
        align(CENTER, CENTER, inside=true)
        pie_slice(
            h=r_min * 2, 
            r=r_maj + r_min + 1, 
            ang=360-angle, 
            spin=-90, 
            orient=TOP
        );
    }
}

module torus_with_column(r_maj, r_min=1, angle=90, col_len=10, fn=90) {
    torus_part(
        r_maj=r_maj, 
        r_min=r_min, 
        angle=angle, 
        fn=fn
    );
    
    echo(angle % 90 == 0);
    
    outer_hyp = angle % 90 != 0 ? (1/sin(90-angle) - 1) * r_maj : r_maj;
    total_hyp = outer_hyp + r_maj;
    total_cat = total_hyp * cos(90 - angle);
    outer_cat = outer_hyp * cos(90 - angle);
    inner_cat = total_cat - outer_cat;
    
    bottom_height = r_maj * (1 - sin(90 - angle));

//    translate([0, 0, r_maj])
//    rotate([0, -45, 0])
    translate([-inner_cat, 0, bottom_height])
    rotate([0, angle, 0])
        cyl(h=col_len, r=r_min, anchor=TOP, orient=RIGHT, $fn=fn);
}

torus_with_column(r_maj=5, angle=90, fn=90);

translate([0, 10, 0])
torus_with_column(r_maj=5, angle=270, fn=90);