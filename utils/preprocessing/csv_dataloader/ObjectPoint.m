classdef ObjectPoint < handle
    %OBJECTPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        X;
        references;
        index;
    end
    
    methods
        function obj = ObjectPoint()
            obj.id = 0;
            obj.X=[];
            obj.references=[];
            obj.index=0;
        end
        
        function obj = setIndex(obj,index)
            obj.index = index;
        end
        
        function index = getIndex(obj)
            index = obj.index;
        end
        
        function nbrref = getNbrRef(obj)
            nbrref = size(obj.references,2);
        end
        
        function id = getId(obj)
            id = obj.id;
        end
        
        function X = getX(obj)
            X = obj.X;
        end
        
        function obj = readId(obj,line)
            obj.id = str2double(line);
        end
        
        function  obj = readObjectPoint(obj,line)
            values = split(line, ",");
            
            for i = 1:size(values)
                obj.X(i) = str2num(values{i});
            end
            
        end
        
        function  obj = readReferences(obj,line)
            values = split(line, ",");
            
            for i = 1:size(values)
                tmp(i) = str2num(values{i});
            end
            
            obj.references = tmp(2:end);
            obj.references = reshape(obj.references,2,length(obj.references)/2);
        end
    end
end

