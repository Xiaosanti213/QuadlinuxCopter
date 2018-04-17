function setUpProject()
%   setUpProject  Configure the environment for this project 
%   配置工程环境
%   Set up the environment for the current project. This function is set to
%   Run at Startup.

% Use Simulink Project API to get the current project: 获取当前工程目录
p = slproject.getCurrentProject;

projectRoot = p.RootFolder;
% Set the location of slprj to be the "work" folder of the current project:
myCacheFolder = fullfile(projectRoot, 'work');
if ~exist(myCacheFolder, 'dir')
    mkdir(myCacheFolder)
end
Simulink.fileGenControl('set', 'CacheFolder', myCacheFolder, ...
   'CodeGenFolder', myCacheFolder);