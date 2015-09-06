##Stereo Visual Odometry

This is a MATLAB-based implementation of Andrew Howard's 2008 paper:
Real-Time Stereo Visual Odometry for Autonomous Ground Vehicles

[Link to the paper](https://www-robotics.jpl.nasa.gov/publications/Andrew_Howard/howard_iros08_visodom.pdf).

##[Blog Post](http://avisingh599.github.io/vision/visual-odometry-full/)

Note that this is not an exact implementation. A few things, such as the feature detector,
are different. Also, since it is based on MATLAB, and not C/C++ like the original author,
it is not really "real time". In fact, each VO computation takes around 10-15 seconds.
However, the core algorithm is the same.

###Requirements: 

MATLAB R2014a or newer, with the following toolbooxes:

1.  Computer Vision
2.  Optmization

###How to run?
A file demo.m is provided which takes in the input images provided in the sample_data folder,
and runs the algorithm on it. 
For a better test of the algorithm, it is suggested that you download KITTI's Visual Odometry
dataset, and test the algorithm on their sequences. 

In order to run this algorithm on your own data, you must modify the intrinsic and extrinsic
calibration parameter in the code.

###Results
![Results on the KITTI VO Benchmark Sequence 0 (2000 frames)](https://github.com/avisingh599/vo-howard08/blob/master/results/2000_frames.bmp)

Results on the KITTI VO Benchmark Sequence 0 (2000 frames). Blue is the ground truth, green is the VO estimation.

###Contact
For any queries, contact: avisingh599@gmail.com

###License
MIT