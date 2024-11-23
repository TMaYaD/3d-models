$fn = 46;

resolution =  20;

xmax = 20;

curvature = -0.03;

base_r = 3;

// parabola y = curvature(x-xmax)^2 - xmax^2
// curvature defines the curvature, but also controls the maximum y
// base_r controls the radius at the base, tapering to near zero point
// slope of parabola y' = 2*curvature(x-xmax)
// perpendicular slope T = 1/y'
// "x" is parametric as t*x, and one increment further as (t + s)*x
// then the whole thing is tilted back by the slope at x = 0: atan(1/(2*curvature*xmax))
// this means xmax isn't really the maximum x, but the projection onto the x axis

module horn(xmax, base_r, curvature=-0.03, resolution=20) {
    s = 1/resolution;

    rotate([0, atan(1/(2*curvature*xmax)), 0]){
        for(t=[0:s:1]){
            u = t + s;
            hull(){
            translate( [t*xmax, 0, (curvature*pow((t - 1)*xmax,2) - curvature*pow(xmax,2))] ) rotate([ 0, atan(1/(2*curvature*((t - 1)*xmax))), 0]) cylinder(r =  base_r*(1 - t), h = .1);

            translate( [u*xmax, 0, (curvature*pow((u - 1)*xmax,2) - curvature*pow(xmax,2))] ) rotate([ 0, atan(1/(2*curvature*(u - 1)*xmax)), 0]) cylinder(r =  base_r*(1 - u), h = .1);
            }
        }
    }
}

horn(xmax, base_r, curvature, resolution);
