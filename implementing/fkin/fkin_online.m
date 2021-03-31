clear all;
clc;
close all;

%% preamble

% inform where the phd-codes folder is located for finding related code
folder_phd_codes = '/home/filipe/gitSources/doc/phd-codes';

addpath(strcat(folder_phd_codes,'/implementing/modelling'));
addpath('./lib');

% loading robot dualquaternion modules
load('model_dq.mat');


%% ROS 

% initializing ros connection
ros_gentle_init();

% loading ros rosi topics
r_tpc = rosi_ros_topic_info();

% subscribing to topics
sub_pos_manipulator_joints = rossubscriber(r_tpc.pos_joints.adr, r_tpc.pos_joints.msg);
sub_pose_rosi = rossubscriber(r_tpc.pose_rosi.adr, r_tpc.pose_rosi.msg);
sub_pose_sp = rossubscriber(r_tpc.pose_sp.adr, r_tpc.pose_sp.msg);


%% Fkin Loop
while true
    
    %% Retrieving ROS data
    
    % robot joints vector from ROS
    q = ros_retrieve_pos_mani_joints(sub_pos_manipulator_joints);
    
    % rosi base pose
    h_world_base = ros_retrieve_pose(sub_pose_rosi);
    
    % tcp pose
    h_world_tcp = ros_retrieve_pose(sub_pose_sp);
    
    %% Updating manipulator joints transforms given joints angles
    
    for i = 1:length(dq_mani_arr)
        dq_mani_arr_up{i} = dq_joint_rot(q(i)) * dq_mani_arr{i};
    end
    
    
    %% Performing fkin
    
    % computing until the manipulator base
    dq_res = DualQuaternion();
    dq_res = dq_base_gen3base * h_world_base * dq_res;
    
    % computing for manipulator the manipulator joints
    for i=1:7 
        dq_res = dq_mani_arr_up{i} * dq_res;
    end
    
    % computing fkin until the TCP
    dq_res = dq_j7_tcp * dq_res;
    
    %% 

    % extracting the th
    ori_1 = dq_res.q_p
    tr_1 = dq_res.extractTranslation
    
end












