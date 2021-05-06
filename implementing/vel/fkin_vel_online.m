clear all;
clc;
close all;

%% preamble

% inform where the phd-codes folder is located for finding related code
folder_phd_codes = '/home/filipe/gitSources/doc/phd-codes';

addpath(strcat(folder_phd_codes,'/implementing/modelling'));
addpath(strcat(folder_phd_codes,'/implementing/lib/dq'));
addpath('./lib');

%% preamble

% loading robot dualquaternion modules
load('model_dq.mat');


%% ROS

% initializing ros connection
ros_gentle_init();

% loading ros rosi topics
r_tpc = rosi_ros_topic_info();

% subscribing
sub_pose_vel_rosi = rossubscriber(r_tpc.pose_vel_rosi.adr, r_tpc.pose_vel_rosi.msg);
sub_pose_rosi = rossubscriber(r_tpc.pose_rosi.adr, r_tpc.pose_rosi.msg);
sub_vel_manipulator_joints = rossubscriber(r_tpc.vel_joints.adr, r_tpc.vel_joints.msg);


%% Loop

disp('Loop initiated...');
while true
    
    % retrieve joints velocity
    qd = ros_retrieve_mani_joints(sub_vel_manipulator_joints);
    
    % retrieve rosi base pose
    dq_world_base = ros_retrieve_dq(sub_pose_rosi);
    
    % retrieve base velocity
    omega_world_base = ros_retrieve_dq(sub_pose_vel_rosi);
    
    % updating joints screw twists
    joint_screw = {};
    for i=1:length(dq_arm_arr)
        joint_screw{i} = get_joint_screw('r', 'z') * qd(i);
    end
    
    dqd_res = DualQuaternion();
    
    
    
    
    
    % computing dqd
    dqd_world_base = 0.5 * omega_world_base * dq_world_base;    
end



















