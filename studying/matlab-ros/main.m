clear all;
clc;

%% ROS basics

% initialize roscore
% rosinit;

% connect to roscore in a network machina
%rosinit('<ip-address>', <port>);   % connection on port 11311 by default
%rosinit(http://<ip-addres>:<port>)  

% shutds down ros
%rosshutdown;

% generates custom message interfaces
% For Matlab < 2021, install toolbox 'Robotics System Toolbox Interface for
% ROS Custom Messages'
%rosgenmsg('/home/filipe/ros/rosiSim_ws/src/'); % path to the workspace containing the packages that contains the messages you want to interface with

%% Topics

% list topics
%rostopic list

% information about a topic
%rostopic info /rosout

% subscribes to a topic
% sub_topic = rossubscriber('/sensor/imu');

% subscribes to a topic and points to a callback function
% sub_topic = rossubscriber('/manipulator/sensor/joints_pos', @fcn_callback_example);

% receives a message from a subscribed topic
% topic_data = receive(sub_topic, 10)

% defines a publisher
% pub_topic = rospublisher('/matlab/time', 'std_msgs/Header');

% publishes in a loop fashion
% fcn_publisher(pub_topic)


%% Service 

% creates a service and attachs to a function
% srv_server = rossvcserver('/matlab/sum', 'roscpp_tutorials/TwoInts', @fcn_service);

% creates a service client
% srv_client = rossvcclient('/matlab/sum');

% creates a service request message
% srv_request = rosmessage(srv_client);
% srv_request.A = 1;
% srv_request.B = 2;

% requests the service
% srv_call = call(srv_client, srv_request, 'Timeout', 3);
























