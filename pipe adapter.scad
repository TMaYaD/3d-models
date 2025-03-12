$fn=$preview ? 16 : 64;

ID1 = 0;
OD1 = 25;
L1 = 30;

ID2 = 33;
OD2 = 0;
L2 = 30;

T = 3;
JL = 0;

assert(ID1 > 0 || OD1 > T, "Atleast one of ID1 or OD1 must be assigned and positive.");
assert(ID2 > 0 || OD2 > T, "Atleast one of ID2 or OD2 must be assigned and positive.");

id1 = ID1 > 0 ? ID1 : OD1 - 2 * T;
od1 = OD1 > 0 ? OD1 : ID1 + 2 * T;

id2 = ID2 > 0 ? ID2 : OD2 - 2 * T;
od2 = OD2 > 0 ? OD2 : ID2 + 2 * T;

jl = JL > 0 ? JL : max(od2-od1, id2-id1)/2;

echo (id1, od1, id2, od2, jl);

difference() {
        cylinder(d=od1, h=L1);
        cylinder(d=id1, h=L1);
}

translate([0,0,L1])
difference() {
        cylinder(d1=od1, d2=od2, h=jl);
        cylinder(d1=id1, d2=id2, h=jl);
}

translate([0,0,L1+jl])
difference() {
        cylinder(d=od2, h=L2);
        cylinder(d=id2, h=L2);

}
