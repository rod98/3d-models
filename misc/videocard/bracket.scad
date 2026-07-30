include <BOSL2/std.scad>
use <BOSL2/shapes3d.scad>

fn=90;

inner_d = 3;
outer_d = 5;

shoulder_w = 3;
shoulder_h = 1.5;

tube_height=3;

xdist = 40.5 + inner_d - 0.5;
ydist = 40.5 + inner_d - 0.5;

difference() 
{
    union() 
    {
        ycopies(ydist, 2)
        xcopies(xdist, 2)
        tube(id=inner_d, od=outer_d, h=tube_height, $fn=90, anchor=BOTTOM);

        zrot(45)
        cube([xdist * sqrt(2), shoulder_w, shoulder_h], anchor=CENTER+BOTTOM);

        zrot(45)
        cube([shoulder_w, ydist * sqrt(2), shoulder_h], anchor=CENTER+BOTTOM);
        
        cube([20, 20, shoulder_h], anchor=CENTER+BOTTOM);
    }
    
    union()
    {
        ycopies(ydist, 2)
        xcopies(xdist, 2)
        cyl(d=inner_d, h=tube_height+10, $fn=90);
        
        cube([14, 14, shoulder_h+5], anchor=CENTER);
    }
}