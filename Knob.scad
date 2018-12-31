// Higher definition curves
$fs = 0.01;
$fa=1; 

use <roundcylinders.scad>

cone_extra_cushion = 0.6;
cone_bottom_radius = 40.9 / 2 + cone_extra_cushion;
// The difference between and bottom radius is so small that the 3D printer cannot make a gradual
// transition with a good resolution, that's why using same higher value from the bottom value for both.
// It also provides the ability for it to go in easier and then lodge securely when fully inserted.
//coneTopRadius = 38.6 / 2; // Actually measured cone top radius
cone_top_radius = cone_bottom_radius;
cone_height = 39.1;
number_of_cuts = 24;

// Computing "angleCone" would be needed if we want to construct a cone instead of a cylinder knob to 
// rotate the cyllinder groove cutouts.

// Calculating angle of the side of the cone. Variable is not used anywhere.
//triangle_bottom = cone_bottom_radius - cone_top_radius;
//triangle_hypotenuse = pow(pow(cone_height, 2) + pow(triangle_bottom, 2), 0.5);
//angle_cone = acos((pow(cone_height, 2) + pow(triangle_hypotenuse, 2) - pow(triangle_bottom, 2)) / 2 * cone_height * triangle_hypotenuse);
micro = 0.01;
height_padding = 6;
radius_padding = 8;

// Creates a circular set of "number_of_cones" cones with radius "cone_radius" and height "cone_height"
// distributed evenly around a circle of with radius "circle_radius".
module cones_in_a_circle(circle_radius, number_of_cones, cone_radius, cone_height) {
    for (i=[1:number_of_cones])  {
        translate([
                circle_radius*cos(i*(360/number_of_cones)),
                circle_radius*sin(i*(360/number_of_cones)),
                0]) {
            cylinder(r=cone_radius, h=cone_height, $fn=20, center = false);
        }
    };

}


union() {
    difference() {
        difference() {
            // Outer cylinder
            rcylinder(
                    h = cone_height + height_padding, 
                    r1 = cone_bottom_radius + radius_padding, 
                    r2 = cone_top_radius + radius_padding, 
                    radius1 = 0,
                    radius2 = 4,
                    center = false,
                    debug=false);
            // Inside cut
            difference() {
                translate([0, 0, -micro]) {
                    // Cut inside cylinder.
                    cylinder(
                            h = cone_height + micro,
                            r1 = cone_bottom_radius,
                            r2 = cone_top_radius,
                            center = false);
                }
                // Cut inside ridges that fit the original knob.
                cones_in_a_circle(
                        circle_radius = cone_top_radius,
                        number_of_cones = number_of_cuts,
                        cone_radius = 1.6,
                        cone_height = cone_height);
            }
        }
        // Cut outer knob ridges.
        cones_in_a_circle(
                circle_radius = cone_bottom_radius + radius_padding,
                number_of_cones = number_of_cuts,
                cone_radius = 2.4,
                cone_height = cone_height + height_padding + 2*micro);
    }
    translate([9, -6, cone_height+height_padding]) {
        linear_extrude(1)
            text("+", font = "Comic Sans MS", size = 20);
    }
    translate([-23, -6, cone_height+height_padding]) {
        linear_extrude(1)
            text("-", font = "Comic Sans MS", size = 20);
    }
    translate([-2, 18, cone_height+height_padding]) {
		rotate(a = [0, 0, -33]) {
			linear_extrude(1)
				text("→", font = "Arial", size = 16);
		}
    }
    translate([-2, 27.5, cone_height+height_padding]) {
		rotate(a = [0, 0, -33-90-20]) {
			linear_extrude(1)
				text("→", font = "Arial", size = 16);
		}
    }
}