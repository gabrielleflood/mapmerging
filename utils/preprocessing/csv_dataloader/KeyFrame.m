classdef KeyFrame < handle
    %KEYFRAME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        K;
        state;
        features;
        distorted_features;
        observations;
        index;
        R;
        t;
        descriptors;
    end
    
    methods
        function obj = keyframe()
            %KEYFRAME Construct an instance of this class
            %   Detailed explanation goes here
            obj.id =0;
            obj.K=[];
            obj.state = [];
            obj.features = [];
            obj.distorted_features = [];
            obj.observations= [];
            obj.index = 0;
            obj.R=[];
            obj.t = [];
            obj.descriptors = [];
        end
        
        function c = getPrincipalPoint(obj)
            c = obj.K(1:2,3);
        end
        
        function R = getR(obj)
            R = obj.R;
        end
        
        function t = gett(obj)
            t = obj.t;
        end
        
        function P = getP(obj)
            P = [obj.R obj.t];
        end
        
        function K = getK(obj)
            K = obj.K;
        end
        
        function x = getFeature(obj, index)
            x = obj.features(:,index+1); % here index starts from zero!
        end
        
        function x = getDistortedFeature(obj, index)
            x = obj.distorted_features(:,index+1); % here index starts from zero!
        end
        
        function obs = getObservations(obj)
            obs = obj.observations;
        end
        
        function descriptor = getDescriptor(obj,index)
            descriptor = obj.descriptors(index+1,:);% here index starts from zero!
        end
        
        function nbr = getNbrObs(obj)
            nbr = size(obj.observations,2);
        end
        
        function obj = setIndex(obj,index)
            obj.index = index;
        end
        
        function index = getIndex(obj)
            index = obj.index;
        end
        
        function id = getId(obj)
            id = obj.id;
        end
        
        function obj = readId(obj,line)
            obj.id = str2double(line);
        end
        
        function  obj = readCalibration(obj,line)
            values = split(line, ",");
            
            for i = 1:size(values)
                calib(i) = str2num(values{i});
            end
            
            
            obj.K = [calib(1), 0, calib(3);
                0 calib(2), calib(4);
                0 0 1];
        end
        
        function  obj = readState(obj,line)
            
            values = split(line, ",");
            
            for i = 1:size(values)
                obj.state(i) = str2num(values{i});
            end
            
            obj.R = quat2rot(obj.state(7:10))';
            
            obj.t = -obj.R*obj.state(1:3)';
            
        end
        
        function  obj = readFeatures(obj,line)
            values = split(line, ",");
            
            for i = 1:size(values)
                tmp(i) = str2num(values{i});
            end
            
            obj.features = tmp(2:end);
            obj.features = reshape(obj.features,2,length(obj.features)/2);
        end
        
        function  obj = readDistortedFeatures(obj,line)
            values = split(line, ",");
            
            for i = 1:size(values)
                tmp(i) = str2num(values{i});
            end
            
            obj.distorted_features = tmp(2:end);
            obj.distorted_features = reshape(obj.distorted_features,2,length(obj.distorted_features)/2);
        end
        
        function  obj = readDescriptors(obj,fid)
            
            nbr_desc = str2num(fgetl(fid));
            
            for i =1:nbr_desc
                
                line =fgetl(fid);
                values = split(line, ",");
                tmp=[];
                
                for i = 1:size(values)
                    tmp(i) = str2num(values{i});
                end
                
                obj.descriptors = [obj.descriptors;tmp];
            end
            
            obj.descriptors = cast(obj.descriptors, 'uint8');
        end
        
        function  obj = readObservations(obj,line)
            
            values = split(line, ",");
            
            for i = 1:size(values)
                tmp(i) = str2num(values{i});
            end
            
            obj.observations = tmp(2:end);
            obj.observations = reshape(obj.observations,2,length(obj.observations)/2);
            
        end
    end
end

