This is a MATLAB-based implementation of Andrew Howard's 2008 paper:
Real-Time Stereo Visual Odometry for Autonomous Ground Vehicles

A copy of the publication is freely available [here](https://www-robotics.jpl.nasa.gov/publications/Andrew_Howard/howard_iros08_visodom.pdf).

I also have a [blog post](http://avisingh599.github.io/vision/visual-odometry-full/) describing the implementation, which is especialy recommended for beginners. 

Note that this is not an exact implementation. A few things, such as the feature detector,
are different. Also, since it is based on MATLAB, and not C/C++ like the original author,
it is not really "real time". In fact, each VO computation takes around 10-15 seconds.
However, the core algorithm is the same.

Requirements: 

MATLAB R2014a or newer, with the following toolbooxes:

1.  Computer Vision
2.  Optmization

How to run?
A file demo.m is provided which takes in the input images provided in the sample_data folder,
and runs the algorithm on it. 
For a better test of the algorithm, it is suggested that you download KITTI's Visual Odometry
dataset, and test the algorithm on their sequences. 

In order to run this algorithm on your own data, you must modify the intrinsic and extrinsic
calibration parameter in the code.

The results folder of this repo provides an images that visualises the performance of the
implementation on the first sequence of the KITTI VO dataset, with blue dots denoting the
ground truth information.

For any queries, contact: avisingh599@gmail.com

License: MIT