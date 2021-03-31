function h = ros_retrieve_pose(sub_pose)

    % receives ros msg
    data = receive(sub_pose, 3);

    % creating quaternion object with received msg
    q_p = quaternion(data.Wp, data.Xp, data.Yp, data.Zp);
    q_d = quaternion(data.Wd, data.Xd, data.Yd, data.Zd);
    
    % mounting and returning the pose dual quaternion
    h = DualQuaternion();
    h = h.setDQFromQuat(q_p, q_d);
end

