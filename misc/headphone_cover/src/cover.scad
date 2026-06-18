use <dotSCAD/shape_star.scad>
use <dotSCAD/box_extrude.scad>
use <BOSL/shapes.scad>

fn = 90;

module tube(
    outer_diam,
    inner_diam,
    length,
    fillet1=0,
    fillet2=0
) {   
    difference() {
        cyl(l=length, d=outer_diam, $fn = fn, fillet1=fillet1, fillet2=fillet2);
        cyl(l=length, d=inner_diam, $fn = fn);
    }
}

outer_diam   = 31.1;
inner_diam   = 28  ;
cover_height = 2.2 + 1.7;
wall_width   = outer_diam - inner_diam;

jack_body_len   = 11.6;
jack_inner_diam =  7.8;
jack_outer_diam =  9.4;

jack_screw_inner_diam = 5.8;
jack_screw_len        = 2.2;

cover_side_thicc      = 1.2;

hole_position = inner_diam / 2 - 8.5;

module jack_case(inner) {
    hor_mov             = cover_side_thicc + 0.75;
//    hor_mov             = cover_side_thicc + 0.35;
    jack_pre_insert_len = 5;
    jack_total_len      = jack_pre_insert_len + jack_body_len;
    translate([
        (inner_diam + jack_total_len - wall_width)/2 + 1, 
        0,
        hor_mov
    ]) {
        rotate([0, 90, 0]) {
            union() {
                difference() 
                {
                    tube(jack_outer_diam, inner, jack_total_len);
                    translate([
                        -10.45, 
                        -5, 
                        -jack_total_len/2 + 2.7
                    ])
                        rotate([0, 45, 0])
                            cube([10, 10, jack_pre_insert_len]);
                }
                translate([
                        0, 
                        0, 
                        (jack_total_len + jack_screw_len)/2
                ])
                    tube(jack_outer_diam, jack_screw_inner_diam, jack_screw_len);
            }
        }
    }
}


cutout_depth = 5;
difference() 
{
    union() {
        tube(outer_diam, inner_diam, cover_height);
        translate([0, 0, -(cover_height/2 + cover_side_thicc/2)])
            cyl(l=cover_side_thicc, d=outer_diam, $fn = fn, fillet1=cover_side_thicc / 2);
    }
    translate([-hole_position, 0, 0])
        tube(1.8, 0, 10);
    jack_case(0);
    translate([-(outer_diam+cutout_depth * 2)/2, -6, -5])
        cube([cutout_depth * 2, 12, 10]);
}

ident = 2;
translate([inner_diam/2 - ident - 0.8, 0, -cover_height/2]) 
{
    difference()
    {
        translate([0, -15/2, 0])
            cube([ident, 15, cover_height]);
        w2 = 10;
        translate([0, -w2/2, 0])
            cube([ident, w2, cover_height]);
    }
}
jack_case(jack_inner_diam);

