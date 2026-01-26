use <BOSL/shapes.scad>

module conn_fem(sizes, tolerance) {
//    z_scale = all_scale-(abs(1-all_scale)/2);
//    echo(z_scale)
//    translate([0, 0, pos.z/2*z_scale])
//        scale([all_scale, all_scale, z_scale])
//            cuboid(pos);
    translate(sizes/2)
        cuboid([
            sizes.x + tolerance * 2,
            sizes.y + tolerance * 2,
            sizes.z + tolerance * 2
        ]);
}

module conn_mal(sizes, tolerance) {
    translate(sizes/2)
//        scale(1/all_scale)
            cuboid(sizes);
}

tolerance = 0.5;

conn_mal([10, 20, 30], tolerance);

difference() {
    cube(100, 100, 100);
    conn_fem([10, 20, 30], tolerance);
}
