classdef EC8 < RobotBaseClass
    %% Epson C8 robot model

    properties(Access = public)   
        plyFileNameStem = 'EC8';
    end
    
    methods
%% Constructor
        function self = EC8(baseTr,useTool,toolFilename)
            if nargin < 3
                if nargin == 2
                    error('If you set useTool you must pass in the toolFilename as well');
                elseif nargin == 0 % Nothing passed
                    baseTr = transl(0,0,0);  
                end             
            else % All passed in 
                self.useTool = useTool;
                toolTrData = load([toolFilename,'.mat']);
                self.toolTr = toolTrData.tool;
                self.toolFilename = [toolFilename,'.ply'];
            end
          
            self.CreateModel();
			self.model.base = self.model.base.T * baseTr;
            self.model.tool = self.toolTr;
            self.PlotAndColourRobot();

            drawnow
        end

%% CreateModel
        function CreateModel(self)
            link(1) = Link('d',0.472-0.2915,'a',0.1,'alpha',-pi/2,'qlim',deg2rad([-240 240]), 'offset',0);
            link(2) = Link('d',0,'a',0.3,'alpha',0,'qlim', deg2rad([-158 65]), 'offset',0);
            link(3) = Link('d',0,'a',0.03,'alpha',pi/2,'qlim', deg2rad([-61 202]), 'offset', 0);
            link(4) = Link('d',0.31,'a',0,'alpha',-pi/2,'qlim',deg2rad([-200 200]),'offset', 0);
            link(5) = Link('d',0,'a',0,'alpha',pi/2,'qlim',deg2rad([-135,135]), 'offset',0);
            link(6) = Link('d',0.08,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);

            self.model = SerialLink(link,'name',self.name);
        end      
    end
end
