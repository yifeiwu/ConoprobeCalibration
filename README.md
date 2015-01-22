Conoprobe calibration and verification

Purpose: 
Calculate the transformation between a tracked rigid body and the location pointed to by the conoprobe. 

Premise: 
The works like a laser range finder, it outputs a laser beam and uses holography to report the distance between where the beam is interrupted and the tip of the laser diode.  The data output looks like that from file pose1.txt
A tracked rigid body can be affixed to the conoscope and used to calculate the 3D coordinates of the laser point(outputs look like pose1.csv).  Similar to a solid probe, the calibration can be performed as a pivot calibration by using ~ 20 poses with the constraint that the probe is pointed at the same one location for each pose. 
The goal of the calibration is to find the direction and origin of the laser beam in relation to the tracked rigid body.
A simpler method was proposed for this using 1 pose and 2+ calibration points. 

Method: 
Assuming the conoprobe + rigid body remains stationary,  we obtain one pose reading which we call pose1. 
We put something in front of the laser thereby creating a point where the laser intersects the surface of the object. We record the conoprobe distance reading and we also obtain the 3D location of the intersection by pointing to it with a tracked solid probe.  We’ll call these readings distance1 and truthpoint1.
Now we move the object and repeat to obtain a second set of distance and a second truthpoint, aptly named distance2 and truthpoint2. 

Calculations:
The two truth points are collinear since we did not move the laser. Thus the line they lie on can be used to produce the direction vector of the laser. Since we also have distance measurements, the distance can be subtracted from one of the truthpoints along the direction vector to obtain the laser origin.

Use calibrate2.m followed by calibrationerror2.m. Output is a cono.ini file containing the transform matrix.

Verification:
Additional truthpoints and pose/distance sets can be taken to determine the variance from the calibration.
This work was based off a pivot based calibration protocol made by Jessica Burgner.
Last edited: Yifei Wu 1/2015
