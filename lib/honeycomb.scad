/*
Author: Daniel <headbulb>
Small library to create a repeating honeycomb pattern around center hex grid
*/





module hexagon2d(initialangle=0, radius=1) {
polygon(points=[[radius*cos(initialangle),radius*sin(initialangle)],
				[radius*cos(initialangle+60),radius*sin(initialangle+60)],
				[radius*cos(initialangle+120),radius*sin(initialangle+120)],
				[radius*cos(initialangle+180),radius*sin(initialangle+180)],
				[radius*cos(initialangle+240),radius*sin(initialangle+240)],
				[radius*cos(initialangle+300),radius*sin(initialangle+300)]]);
}
// Number of cells = 1+summation(start=1, end=boundry, 6*n)
module hexagongrid(height=1, boundry=1, outerhexradius=1, innerhexradius=0.9, orientation=0, inneronly=true ) {
for (i = [-(boundry) : 1 :boundry ] ){
    for(j = [-(boundry) : 1 : boundry ]){
            z = -(i+j);
            if(z<boundry+1 && z>-(boundry+1)){
             //   echo("i:", i, "j:", j, "z:", z);
                x1 = outerhexradius*(i*cos(300+orientation)+j*cos(60+orientation)+z*cos(180+orientation));
                y1 = outerhexradius*(i*sin(300+orientation)+j*sin(60+orientation)+z*sin(180+orientation));
				if(inneronly==true){
					//color([abs(i)/5,abs(j)/5,abs(z)/5])
					translate([x1,y1,0])
					linear_extrude(height=height) 
					 hexagon2d(initialangle=orientation, radius=innerhexradius);
				}
				else {
						difference() {
							//color([abs(i)/5,abs(j)/5,abs(z)/5])
							translate([x1,y1,0])
							linear_extrude(height=height) 
							 hexagon2d(initialangle=orientation, radius=outerhexradius);
							translate([x1,y1,0])linear_extrude(height=height)
							 hexagon2d(initialangle=orientation, radius=innerhexradius);
					}
				
				}
            } //if Z
    }// for j
}// for i
}


// Find the radius of the outerhex. Basically find an edge hex center then two vectors from that point. 
// One vector to the corner, second vector a little outside that. A 120-30-30 or 30-60-90 triangle
function adj(s) = s/2;
function hyp(s) = adj(s)/cos(30);
function x2(s, boundry) = s*((boundry)*cos(0)-(boundry)*cos(240))+s*cos(60)+hyp(s)*cos(330);
function y2(s, boundry) = s*((boundry)*sin(0)-(boundry)*sin(240))+s*sin(60)+hyp(s)*sin(330);
function outerhexradius(s, boundry) = sqrt((x2(s, boundry)*x2(s, boundry)+y2(s, boundry)*y2(s, boundry)));
//outerhex=sqrt((x2*x2+y2*y2));

