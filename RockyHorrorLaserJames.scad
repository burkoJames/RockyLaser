// Rocky Horror Laser
// 20-Aug-2016

$fn = 50;

StrutDiameter = 15;
StrutHeight = 53;
BodyDiameter = 20;
SphereDiameter = 38;
SphereHeight = SphereDiameter/2-5;
BoltHeight = SphereHeight+8;

HandleHeight=105;

TineTip = 11;
TineLength = 275;
TineCurveBasis = StrutHeight+BodyDiameter/2;
TineCurveRadius = 30;
BodyLength = 150;

GuardRadius = 25;
TriggerWidth = 15;
TriggerDepth = 2;

BedHeight = 275;
BedWidth = 298;

True = 1;
False = 0;

AttachPointLength = 30;

PinHeight = 10;
PinWidth = 3;
RemoveOffset = 1;
HeightOffset = .8;

BodyTranslation = BodyLength/2-10;


module CurvedAdapter()
{
    Angle=15;
    
    rotate(a=Angle, v=[-1,0,0])
       translate([0,0,-11])
          difference()
          {
             cylinder(h=20, r= StrutDiameter/2);
     
             union()
             {
                translate([0,(StrutDiameter+5)/2, BodyDiameter+4])
                   rotate(a=90, v=[1, 0, 0])
                      cylinder(h=StrutDiameter+5, r=BodyDiameter/2);
            
                translate([-20,-20,-9])
                   rotate (a=Angle, v=[1,0,0])  
                      cube([40,40,14]);
             }
          }
}
module TopPiece()
{
    Strut();
    translate([0, 0, StrutHeight+SphereHeight])
        Ball();
    LightningBolt();
}


module Strut()
{
    cylinder(h=StrutHeight, r=StrutDiameter/2);
}


module Ball()
{    
        sphere(r=SphereDiameter/2);
}


module LightningBolt()
{
    s = 0.6;
    translate([-70, 0, StrutHeight+BoltHeight])
    scale([s, 1, s])
    rotate(a=90, v=[1, 0, 0])
    rotate(a=-7, v=[0, 0, 1])
    translate([0, 0, -2])
    linear_extrude(height=4, center=false, convexity=10, twist=0) 
    {
        polygon([
        [45, 0],  // bottom left
        [110, 0], // bottom right
        [110, 20], [80, 20],
        [90, 30],
        [50, 40],
        [65, 55],
        [ 0, 60], // top left
        [35, 45],
        [25, 30], 
        [60, 20]
        // bottom left = start = [50, 0]
        ]);
    }
}

module TwoTopPieces()
{
    intersection()
    {
        translate([-120, 0, 0]) cube([270, 270, 50]);
    
        union()
        {
            translate([0, 0, 2]) rotate(a=-90, v = [1, 0, 0]) TopPiece();
            translate([50, 0, -2.001]) mirror([1, 0, 0])
                rotate(a=-90, v = [1, 0, 0]) TopPiece();
        }
    }
}
module Tine(ExtraLength, RemoveAttachment)//an individual Tine
{
    difference()
    {
        union()
        {
            rotate(a=90,v=[0, 1, 0])
                cylinder (h=TineLength+ExtraLength, r1=BodyDiameter/2, r2=TineTip/2, center=true);
            translate([TineLength/2,0,0])
                sphere(r=TineTip/2);
        }
        
        if (RemoveAttachment)
        {
            translate([-(TineLength/2+20),-BodyDiameter,-BodyDiameter])
                cube([AttachPointLength+20,BodyDiameter*2,BodyDiameter]);
        }
    }
}
module Tines()//All Tine Pieces
{
    difference()
    {
        union()
        {   
            translate([0,-100,-0.01])
                rotate(a=180, v= [1,0,0])
                    Tine(0,1);
            translate([0,-60,-0.01])
                rotate(a=180, v=[1,0,0])
                    Tine(0,1);
            translate([0,-20,-0.01])
                rotate(a=180, v=[1,0,0])
                    Tine(0,1);
            translate([0,20,0])
                Tine(0,0);
            translate([0,60,0])
                Tine(0,0);
            translate([0,100,0])
                Tine(0,0);
        }
        translate([-(TineLength+20)/2       ,-(TineLength+20)/2,-15])
            cube ([TineLength+20,          TineLength+20,15]);
    }
}
module GunBase()//The Base all parts come off of
{
    translate([0,BodyLength/2-20,0])//move the center of the object to the center of the grid
    {
        TineBase();//creates the cross peice, the corners, and the bases for the side tines
    
        rotate(a=90, v=[-1,0,0])
            cylinder(h=TineCurveRadius,r=BodyDiameter/2);//create the center tine base
    
        rotate(a=90, v=[1,0,0])
            cylinder(h=BodyLength,r=BodyDiameter/2);//create the body
    
        translate([0,-(BodyLength+  SphereHeight),0])
            Ball();//create the ball at the body's end
    }
}
module TineBase()
{
    rotate (a=90, v = [0, 1, 0])
        cylinder (h=((StrutHeight*2)+BodyDiameter), r=BodyDiameter/2, center=true); //cross peice
    
    difference()//right curve
    {
        translate([StrutHeight+BodyDiameter/2,TineCurveRadius,0])
            rotate_extrude (convexity = 10)//Donut base of the curve
                translate([TineCurveRadius,0,0]) circle(r=BodyDiameter/2);
        
        union()
        {//The pieces to remove from the donut
            translate([0,-BodyDiameter,-(BodyDiameter+10)/2])
                cube([TineCurveBasis,TineCurveBasis+BodyDiameter*2,BodyDiameter+10]);
            translate([TineCurveBasis-5,TineCurveRadius,-BodyDiameter+10/2])
                cube([TineCurveRadius+20,TineCurveRadius+15,BodyDiameter+10]); 
        }
    }
    
    difference()
    {//the left corner
        translate([-(StrutHeight+BodyDiameter/2),TineCurveRadius,0])
            rotate_extrude (convexity = 10)//The donut base of the corner
                translate([TineCurveRadius,0,0]) circle(r=BodyDiameter/2);
        union()
        {//the peices to remover from the donut
            translate([-TineCurveBasis,-BodyDiameter,-(BodyDiameter+10)/2])
                cube([TineCurveBasis,TineCurveBasis+BodyDiameter*2,BodyDiameter+10]);
            translate([-(TineCurveBasis+TineCurveRadius*2),TineCurveRadius,-BodyDiameter+10/2])
                cube([TineCurveRadius*2+5,TineCurveRadius+15,BodyDiameter+10]); 
        }
    }
}
module GunBasePeice ()
{
    intersection()
    {
        GunBase();
        
        translate([-150,-150,0])
            cube([300,300,30]);
    }
}

module GunHandle()
{
    cylinder(h=HandleHeight, r=BodyDiameter/2);
    
    translate ([0,0,HandleHeight+SphereHeight])
        Ball();
    
    Trigger();
    
    HandleAdaptor();
}

module Trigger()
{
    
    
    intersection()
    {
        rotate (a=90, v=[1,0,0])
            translate([BodyDiameter/2,0,-7.5])
                rotate_extrude (convexity=10)
                    translate ([GuardRadius,0,0])
                        polygon (points = [
                            [0,0],
                            [0,TriggerWidth],
                            [TriggerDepth,TriggerWidth],
                            [TriggerDepth,0]]);
        
        translate([0,-10,0])
            cube([70,60,60]);
    }
}
module HandleAdaptor()
{
    rotate(a=180, v=[1,0,0])
        difference()
        {
            union()
            {
                cylinder(h=9, r= BodyDiameter/2);
                
                linear_extrude (height=9, center=false, convexity=10, twist=0)
                {
                    polygon([
                    [(GuardRadius+BodyDiameter/2),(-TriggerWidth/2)],
                    [(GuardRadius+BodyDiameter/2),(TriggerWidth/2)],
                    [(GuardRadius+BodyDiameter/2+TriggerDepth),(TriggerWidth/2)],
                    [(GuardRadius+BodyDiameter/2+TriggerDepth),(-TriggerWidth/2)]]);
                }
            }
     
            translate([-(BodyDiameter/2+5),0,BodyDiameter/2+1])
                rotate(a=90, v=[0, 1, 0])
                    cylinder(h=80, r=BodyDiameter/2);
            
        }
}
module GunHandleParts()
{
    intersection ()
    {
        translate ([20,0,0])
            union()
            {
                rotate (a=90, v=[-1,0,0])
                    GunHandle();
                translate ([-45,0,0])
                    mirror(v=[1,0,0])
                        rotate (a=90, v=[-1,0,0])
                            GunHandle();
            }
        
        translate ([-100,-20,0])
            cube([200,200,40]);
    }
}
module FullDesign ()
{
    translate([0,-10,0])
        SideBody();
    
    rotate(a=90, v=[0,0,1])
        translate([(TineLength/2+BodyLength/2-20+TineCurveRadius), -(StrutHeight+BodyDiameter/2+TineCurveRadius),0])
            Tine(0,True);//right tine
    
    rotate(a=90, v=[0,0,1])
        translate([(TineLength/2+BodyLength/2-20+TineCurveRadius), (StrutHeight+BodyDiameter/2+TineCurveRadius),0])
            Tine(0,True);//left tine
    
    rotate(a=90, v=[0,0,1])
        rotate (a=90, v=[-1,0,0])
            translate([(TineLength/2+BodyLength/2-20+TineCurveRadius), 0,0])
                Tine(0,True);//center tine
    
    translate([0,BodyLength/2-20,0])
        TineCurves();
}
module SideBody()
{
    translate([0,BodyLength/2-10,0])//move the center of the object to the center of the grid
    {
        difference()
        {
            rotate (a=90, v = [0, 1, 0])
                cylinder (h=BodyDiameter+AttachPointLength*2, r=BodyDiameter/2, center=true);//create the base for the corners
            
            union()
            {
                translate([-(BodyDiameter/2+AttachPointLength+3),-(BodyDiameter/2+3),0])
                    cube([AttachPointLength+3,BodyDiameter+5,30]);
                translate([(BodyDiameter/2),-(BodyDiameter/2+3),0])
                   cube([AttachPointLength+3,BodyDiameter+5,30]);
            }
        }
        
        difference ()
        {
            rotate(a=90, v=[-1,0,0])
                cylinder(h=TineCurveRadius+AttachPointLength,r=BodyDiameter/2);//create the center tine base
            
            translate([-20,TineCurveRadius,-20])
                cube([20,AttachPointLength+5,40]);
        }
    
        rotate(a=90, v=[1,0,0])
            cylinder(h=BodyLength,r=BodyDiameter/2);//create the body
    
        translate([0,-(BodyLength+  SphereHeight),0])
            Ball();//create the ball at the body's end
    }
    
    rotate (a=180, v = [1,0,0])
        rotate (a=90, v=[0,0,-1])
            rotate (a=-15, v=[0,1,0])
            translate([10,0,0])
                StaticGunHandle();
    
    translate ([0,20,0])
        rotate (a=15, v=[1,0,0])
        {
            rotate (a=90, v=[0,0,-1])    
                translate ([-30,0,-3])
                    TopPiece();
        }
}
module LeftSideBody()
{
    rotate (a=90, v=[0,1,0])
    {
        difference()
        {
            SideBody ();
    
            height = 275;
            width = 298;
    
            translate ([0,-height/2, -width/2])
                cube ([100,height,width]);
        }
    }
}
module RightSideBody()
{
    rotate (a=90, v=[0,-1,0])
    {
        difference()
        {
        SideBody ();
    
        translate ([-100,-BedHeight/2, -BedWidth/2])
            cube ([100,BedHeight,BedWidth]);
        }
    }
}
module StaticGunHandle ()
{
    cylinder(h=HandleHeight, r=BodyDiameter/2);
    
    translate ([0,0,HandleHeight+SphereHeight])
        Ball();
    
    StaticTrigger();
}
module StaticTrigger ()
{
    intersection()
    {
        rotate (a=90, v=[1,0,0])
            translate([BodyDiameter/2,0,-7.5])
                rotate_extrude (convexity=10)
                    translate ([GuardRadius,0,0])
                        polygon (points = [
                            [0,0],
                            [0,TriggerWidth],
                            [TriggerDepth,TriggerWidth],
                            [TriggerDepth,0]]);
        
        translate([0,-10,-10])
            cube([70,40,60]);
    }
}
module TineCurves ()
{
    rotate (a=90, v = [0, 1, 0])
    {
        difference()
        {
            cylinder (h=((StrutHeight*2)+BodyDiameter)+4, r=BodyDiameter/2, center=true); //cross peice
            
            union()
            {
                cylinder (h=BodyDiameter, r=BodyDiameter/2+5, center=true);//body of gun
                
                translate([0,-BodyDiameter,-(BodyDiameter/2+AttachPointLength)])
                    cube([BodyDiameter,BodyDiameter*2,(AttachPointLength*2+BodyDiameter)]);//Attachment Points
            }
        }
    }
    
    difference()//right curve
    {
        translate([StrutHeight+BodyDiameter/2,TineCurveRadius,0])
            rotate_extrude (convexity = 10)//Donut base of the curve
                translate([TineCurveRadius,0,0]) circle(r=BodyDiameter/2);
        
        union()
        {//The pieces to remove from the donut
            translate([0,-BodyDiameter,-(BodyDiameter+10)/2])
                cube([TineCurveBasis,TineCurveBasis+BodyDiameter*2,BodyDiameter+10]);
            translate([TineCurveBasis-5,TineCurveRadius,-BodyDiameter+10/2])
                cube([TineCurveRadius+20,TineCurveRadius+15,BodyDiameter+10]); 
        }
    }
    
    difference()//right curve tine Attachment point
    {
        translate([-(TineCurveBasis+TineCurveRadius),TineLength/2+TineCurveRadius,0])
            rotate (a=90, v=[0,0,1])
                Tine(2,0);
        union()
        {
            translate([-(TineCurveBasis+TineCurveRadius+BodyDiameter),TineCurveRadius,0])
                cube([BodyDiameter*2,AttachPointLength+10,BodyDiameter]);
            
            translate([-(TineCurveBasis+TineCurveRadius+BodyDiameter),(TineCurveRadius+AttachPointLength),-BodyDiameter])
                cube([BodyDiameter*2,TineLength,BodyDiameter*2]);
        }
    }
    
    difference()
    {//the left curve
        translate([-(StrutHeight+BodyDiameter/2),TineCurveRadius,0])
            rotate_extrude (convexity = 10)//The donut base of the corner
                translate([TineCurveRadius,0,0]) circle(r=BodyDiameter/2);
        union()
        {//the peices to remover from the donut
            translate([-TineCurveBasis,-BodyDiameter,-(BodyDiameter+10)/2])
                cube([TineCurveBasis,TineCurveBasis+BodyDiameter*2,BodyDiameter+10]);
            translate([-(TineCurveBasis+TineCurveRadius*2),TineCurveRadius,-BodyDiameter+10/2])
                cube([TineCurveRadius*2+5,TineCurveRadius+15,BodyDiameter+10]); 
        }
    }
    
    difference()//left curve tine Attachment point
    {
        translate([(TineCurveBasis+TineCurveRadius),TineLength/2+TineCurveRadius,0])
            rotate (a=90, v=[0,0,1])
                Tine(2,0);
        union()
        {
            translate([(TineCurveBasis+TineCurveRadius-BodyDiameter),TineCurveRadius,0])
                cube([BodyDiameter*2,AttachPointLength+10,BodyDiameter]);
            
            translate([(TineCurveBasis+TineCurveRadius-BodyDiameter),(TineCurveRadius+AttachPointLength),-BodyDiameter])
                cube([BodyDiameter*2,TineLength,BodyDiameter*2]);
        }
    }
        
}
module TineCurvePeices()
{
    intersection()
    {
        translate ([0,-50,-.01])
            union()
            {
                TineCurves();
            
                translate ([0,100,0])
                    rotate (a=180, v=[1,0,0])
                        TineCurves();
            }   
        
        translate ([-BedWidth/2,-BedHeight/2, 0])
            cube ([BedWidth,BedHeight,20]);
    }
}

module AlignmentPin(remove)
{
    x=.7;
    if(remove)
        cube([PinWidth+RemoveOffset, PinWidth+RemoveOffset, PinHeight+HeightOffset]);
    else
    {
        difference()
        {
            cube([PinWidth, PinWidth, PinHeight]);
            
            union()
            {
                translate ([-2.1312-x,-x,-.5])
                    rotate (a=45, v=[0,0,-1])
                        cube([3,3,11]);
                
                translate ([-2.1213+3+x,-x,-.5])
                    rotate (a=45, v=[0,0,-1])
                        cube([3,3,11]);
                
                translate ([-2.1312-x,3+x,-.5])
                    rotate (a=45, v=[0,0,-1])
                        cube([3,3,11]);
                
                translate ([-2.1213+3+x,3+x,-.5])
                    rotate (a=45, v=[0,0,-1])
                        cube([3,3,11]);
            }
        }
    }
}

module PinnedCurves()
{
    difference()
    {
        TineCurves();
        
        union()
        {
            //alignment pin for left curve along x axis
            translate([-TineCurveBasis+5,-(PinWidth/2),-(PinHeight/2)])
                AlignmentPin(True);
            //alignment pin for left curve along y axis
            translate([-(TineCurveBasis+TineCurveRadius),(TineCurveRadius*.60),-(PinHeight+HeightOffset)/2])
                AlignmentPin(True);
            //Alignment pin for right curve along x axis 
            translate([TineCurveBasis-5,-(PinWidth/2),-(PinHeight/2)])
                AlignmentPin(True);
            //Alignment pin for right curve along y axis
            translate([(TineCurveBasis+TineCurveRadius)-PinWidth,(TineCurveRadius*.60),-(PinHeight+HeightOffset)/2])
                AlignmentPin(True);
        }
    }
}

module PinnedCurvePieces()
{
    intersection()
    {
        translate ([0,-50,-.01])
            union()
            {
                PinnedCurves();
            
                translate ([0,100,0])
                    rotate (a=180, v=[1,0,0])
                        PinnedCurves();
            }   
        
        translate ([-BedWidth/2,-BedHeight/2, 0])
            cube ([BedWidth,BedHeight,20]);
    }
}

module PinGroup()
{
    for (x = [-50 : 6 : 50])
        rotate (a=90,v=[1,0,0])
            translate ([x,0,0])
                AlignmentPin(False);
}

module PinnedTine()
{
    difference()
    {
        Tine(0, True);
        
        union()
        {
            translate([-(PinWidth+RemoveOffset)/2, -(PinWidth+RemoveOffset)/2, -(PinHeight+HeightOffset)/2])
                AlignmentPin(True);
            
            translate([-75, -(PinWidth+RemoveOffset)/2, -(PinHeight+HeightOffset)/2])
                AlignmentPin(True);
        }
    }
}
module PinnedTines()
{
    difference()
    {
        union()
        {   
            translate([0,-20,-0.01])
                rotate(a=180, v=[1,0,0])
                    PinnedTine(0,True);
            translate([0,20,0])
                PinnedTine(0,0);
        }
        translate([-(TineLength+20)/2       ,-(TineLength+20)/2,-15])
            cube ([TineLength+20,          TineLength+20,15]);
    }
}

module PinnedSideBody()
{
    difference()
    {
        SideBody();
        
        union()
        {
            //Alignment Pin for Rear Ball
            translate([-(PinHeight/2+HeightOffset),-(BodyLength-BodyTranslation+SphereHeight+PinWidth),PinWidth/2])
                rotate(a=90, v=[0,1,0])
                    AlignmentPin(True);
            
            //Alignment Pin for bottom Ball
            translate([-(PinHeight/2+HeightOffset),-23,-116])
                rotate(a=90, v=[0,1,0])
                    AlignmentPin(True);
            
            //Alignment Pin for Top Ball
            translate([-(PinHeight/2+HeightOffset), 30, 72])
                rotate (a=90, v=[0,1,0])
                    AlignmentPin(True);
            
            //Alignment Pin for Handle
            translate([-(PinHeight/2+HeightOffset),7,PinWidth/2])
                rotate(a=90, v=[0,1,0])
                    AlignmentPin(True);
            
            //Alignment Pin for Attachment Joint
            translate([-(PinHeight/2+HeightOffset),(BodyTranslation-PinWidth/2),PinWidth/2])
                rotate(a=90, v=[0,1,0])
                    AlignmentPin(True);
        }
    }
}

module PinnedLeftSideBody()
{
    rotate (a=90, v=[0,1,0])
    {
        difference()
        {
            PinnedSideBody ();
    
            height = 275;
            width = 298;
    
            translate ([-.01,-height/2,-(width/2)])
                cube ([100,height,width]);
        }
    }
}
module PinnedRightSideBody()
{
    rotate (a=90, v=[0,-1,0])
    {
        difference()
        {
        PinnedSideBody ();
    
        translate ([-100,-BedHeight/2, -BedWidth/2])
            cube ([100,BedHeight,BedWidth]);
        }
    }
}
    
//TwoTopPieces();
 
//CurvedAdapter();

//Tine();

//Tines();

//GunBasePeice();

//GunHandleParts();

//FullDesign();

//SideBody();

//LeftSideBody();

//RightSideBody();

//TineCurves();

//TineCurvePeices();

//AlignmentPin(False);

//PinnedCurves();

//PinnedCurvePieces();

//PinGroup();

//PinnedTine();

//PinnedTines();

//PinnedSideBody();

//PinnedLeftSideBody();

//PinnedRightSideBody();