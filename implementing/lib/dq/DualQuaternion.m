classdef DualQuaternion 
    % Class for manipulating DualQuaternion objects
    
    properties
        q_p % quaternion primary part
        q_d % quaternion dual part
    end
    
    methods
        
        %% === CONSTRUCTOR METHOD
        
        function obj = DualQuaternion()            
            obj.q_p = quaternion(1,0,0,0);
            obj.q_d = quaternion(0,0,0,0);
        end
        
        
        %% === SETTING DUAL QUATERNIONS
        
        % Method for setting dq components based on orientation quaternion
        % and 3D translation vector
        function obj = setDQFromQuatAndTransl(obj, q_p, vec)
           obj.q_p = q_p.normalize;
           obj.q_d = (quaternion(0, vec(1), vec(2), vec(3)) * obj.q_p) * 0.5;  
        end
        
        
        % Method for setting dq components based on two quaternions
        function obj = setDQFromQuat(obj, q_p, q_d)
           obj.q_p = q_p.normalize;
           obj.q_d = q_d;
        end
        
        
        % Sets a pure translation dual quaternion
        function obj = setDQpureTranslation(obj, tr_vec)
           
            % divises the translation vector by two
            aux_v = tr_vec * 0.5;
            
            % mounts the dual quaternion
            obj.q_p = quaternion(1, 0, 0, 0);
            obj.q_d = quaternion(0, aux_v(1), aux_v(2), aux_v(3)); 
        end
        
        
        % Sets a pure rotation dual quaternion given an axis and an angle
        function obj = setDQpureRotation(obj, r_angle, r_axis)
            
            % aux variable
            sin_angle_div_2 = sin(r_angle/2);
            
            % mounting dual-quaternion
            obj.q_p = quaternion(cos(r_angle/2),...
                                 r_axis(1) * sin_angle_div_2,...
                                 r_axis(2) * sin_angle_div_2,...
                                 r_axis(3) * sin_angle_div_2);
            obj.q_d = quaternion(0,0,0,0);
            
        end
        
        %% === OPERATORS
        
        % Multiply operator for DualQuaternion objects
        function r = mtimes(lhs, rhs)
            
            % in case of dual quaternion objects multiplications
            if isa(lhs, 'DualQuaternion') && isa(rhs, 'DualQuaternion')
                % multiplicating primary and dual quaternion parts
                r_p = rhs.q_p * lhs.q_p;
                r_d = (rhs.q_d * lhs.q_p) + (rhs.q_p * lhs.q_d);
                
                % mounting resulting object
                r = DualQuaternion();
                r = r.setDQFromQuat(r_p, r_d);
            end
            
            % in case of dualquaternion and doublem multiplication
            if isa(lhs, 'DualQuaternion') && isa(rhs, 'double')
                % multiplicating primary and dual quaternion parts
                r_p = lhs.q_p * rhs;
                r_d = lhs.q_d * rhs;
                
                % mounting resulting object
                r = DualQuaternion();
                r = r.setDQFromQuat(r_p, r_d);
            end
            
            % in case of double and dual quaternion multiplication
            if isa(lhs, 'double') && isa(rhs, 'DualQuaternion')
                % multiplicating primary and dual quaternion parts
                r_p = rhs.q_p * lhs;
                r_d = rhs.q_d * lhs;
                
                % mounting resulting object
                r = DualQuaternion();
                r = r.setDQFromQuat(r_p, r_d);
            end
        end % end of multiply operator
        
        
        % Sum operator for DualQuaternion objects
        function r = plus(lhs, rhs)
            
            % summing parts 
            r_p = lhs.q_p + rhs.q_p;
            r_d = lhs.q_d + rhs.q_d;
            
            % mounting resulting object
            r = DualQuaternion();
            r = r.setDQFromQuat(r_p, r_d);
            
        end % end of add operator
        
        
        % Normalize Dual Quaternion
        function r = normalize(dq_in)
            
           % computing the primary part quaternion magnitude
           mag = dot(dq_in.q_p.compact, dq_in.q_p.compact);
            
           % normalizing both primary and dual parts
           r_p = dq_in.q_p * (1/mag);
           r_d = dq_in.q_d * (1/mag);
           
           % mounting resulting object
           r = DualQuaternion();
           r = r.setDQFromQuat(r_p, r_d);
        end
        
        
        
        % Conjugate operator
        function r = ctranspose(dq_in)
            
            % conjugating both quaternion parts
            r_p = dq_in.q_p.conj;
            r_d = dq_in.q_d.conj;
            
            % mounting returning object
            r = DualQuaternion();
            r = r.setDQFromQuat(r_p, r_d);
        end
        
       %% === CONVERSIONS AND EXTRACTIONS
       
       % Extracts the translation vector from the dual quaternion
       function tr = extractTranslation(obj)
           q_tr = (obj.q_d * 2) * (obj.q_p.conj);
           aux = q_tr.compact;
           tr = aux(2:end);
       end
       
       % Converts the pose dual-quaternion to homogeneous transform matrix
       function th = dq2th(obj)
          
           % normalizes the dq
           dq_n = obj.normalize;
           
           % extracts the rotation matrix
           rotm = quat2rotm(obj.q_p);
           
           % extracts the translation vector
           tr = obj.extractTranslation;
           
           % mounting the th matrix
           th = [[rotm,tr.'];[0, 0, 0, 1]];
       end
       
      %% === INTERFACES
     
      % overrides disp function
      function disp(obj)
          q_p = obj.q_p.compact;
          q_d = obj.q_d.compact;
          
          fprintf('(%d + %di + %dj + %dk) + (%d + %di + %dj + %dk)ε \n\n', ...
                    q_p(1), q_p(2), q_p(3), q_p(4), q_d(1), q_d(2), q_d(3), q_d(4));
      end
       
    end
end





























