This is a MATLAB-based implementation of Andrew Howars' 2008 paper:
Real-Time Stereo Visual Odometry for Autonomous Ground Vehicles
(https://www-robotics.jpl.nasa.gov/publications/Andrew_Howard/howard_iros08_visodom.pdf)

Note that this is not an exact implementation. A few things, such as the feature detector,
are different. Also, since it based on MATLAB, and not on C/C++ like the original author,
it is not really "real time". In fact, each VO computation takes around 10-15 seconds.
However, the code algorithms components are the same.

Requirements: 
MATLAB2014a or newer, with the following toolbooxes:
1) Computer Vision
2) Optmization

How to run?
A file demo.m is provided which takes in the input images provided int he sample_data folder,
and runs the algorithm on it. 
For a better test of the algorithm, it is suggested that you download KITTI's Visual Odometry
dataset, and test the algorithm on them.

In order to run thig algorithm on your own data, you must modify the intrinsic and extrinsic
calibration parameter in the code. 

The results folder of this repo provides an images that visualises the performance of the
implementation on the first sequence of the KITTI VO dataset, with blue dots denoting the
ground truth information.

For any queries, contact: avisingh599@gmail.com


License: MIT