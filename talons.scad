$fn = 30;
function calcScale(scaleFactors, count, iteration) =
scaleFactors[0] +
        ((scaleFactors[1] - scaleFactors[0])) * iteration / count;

module hullSweep(steps, rotation, offsetTo, scaleFactors)
{
        for (i = [0: steps - 2] ) {
                scaleAmt1 = calcScale(scaleFactors, steps, i);
                scaleAmt2 = calcScale(scaleFactors, steps, i + 1);

                hull()
                {
                        rotate(rotation * i)
                        translate(offsetTo * i)
                        scale([scaleAmt1, scaleAmt1, scaleAmt1])
                        children();
                        rotate(rotation * (i + 1))
                        translate(offsetTo * (i + 1))
                        scale([scaleAmt2, scaleAmt2, scaleAmt2])
                        children();
                }
        }
}

// Examples
// Horn #1
hullSweep(40, [0, 0, 4], [1, 1, 1.5], [5, 0])
scale([1, 2, 1])
sphere(1);

// Horn #2
translate([50, 0, 0])
hullSweep(20, [0, 0, 4], [1, 1, 1.5], [5, 0])
scale([1, 2, 1])
sphere(1);

// Short horn
translate([100, 0, 0])
hullSweep(40, [0, 0, 3], [1, 1, 1.5], [10, 0])
union()
{
        sphere(1);
        translate([4, 0, 0])
        sphere(1.5);
}
