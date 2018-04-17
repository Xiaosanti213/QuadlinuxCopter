function setUpProject()
%   setUpProject  Configure the environment for this project 
%   ���ù��̻���
%   Set up the environment for the current project. This function is set to
%   Run at Startup.

% Use Simulink Project API to get the current project: ��ȡ��ǰ����Ŀ¼
p = slproject.getCurrentProject;

projectRoot = p.RootFolder;
% Set the location of slprj to be the "work" folder of the current project:
myCacheFolder = fullfile(projectRoot, 'work');
if ~exist(myCacheFolder, 'dir')
    mkdir(myCacheFolder)
end
Simulink.fileGenControl('set', 'CacheFolder', myCacheFolder, ...
   'CodeGenFolder', myCacheFolder);