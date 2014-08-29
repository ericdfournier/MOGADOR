function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs 
%      are applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property 
%      application stop.  All inputs are passed to gui_OpeningFcn via 
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 29-Aug-2014 10:06:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%__________________________________________________________________________
%                           GUI INITIALIZATION
%__________________________________________________________________________


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%__________________________________________________________________________
%                            INPUT PARAMETERS
%__________________________________________________________________________


% --- Executes on button press in browseGridMaskFilepath.
function browseGridMaskFilepath_Callback(hObject, ~, handles)

% Read in user selected filepath string and update gui display

[file, path] = uigetfile({'*.mat'});
handles.gridMaskFilepath = [path, file];
set(handles.textGridMaskFilepath,'String',...
    handles.gridMaskFilepath);

% Update handles structure

guidata(hObject, handles);


% --- Executes on button press in browseGridMaskGeoRasterReferenceFilepath.
function browseGridMaskGeoRasterReferenceFilepath_Callback(hObject, ~, ... 
    handles)

% Read in user selected spatial reference filepath string and update gui

[file, path] = uigetfile({'*.mat'});
handles.gridMaskGeoRasterReferenceFilepath = [path, file];
set(handles.textGridMaskGeoRasterReferenceFilepath, 'String', ...
    handles.gridMaskGeoRasterReferenceFilepath);

% Update handles structure

guidata(hObject, handles);


% --- Executes on button press in browseObjectiveVariablesFilepath.
function browseObjectiveVariablesFilepath_Callback(hObject, ~, handles)

% Read in user selected filepath string and update gui display

[file, path] = uigetfile({'*.mat'});
handles.objectiveVariablesFilepath = [path, file];
set(handles.textObjectiveVariablesFilepath,'String',...
    handles.objectiveVariablesFilepath);

% Update handles structure

guidata(hObject, handles);


% --- Executes on button press in loadFileSystemParameters.
function loadFileSystemParameters_Callback(hObject, ~, handles)

% Load user selected filepaths

tmp = load(handles.gridMaskFilepath);        
handles.gridMask = tmp.gridMask;
    
tmp = load(handles.gridMaskGeoRasterReferenceFilepath);
handles.gridMaskGeoRasterRef = tmp.gridMaskGeoRasterRef;

tmp = load(handles.objectiveVariablesFilepath);
handles.objectiveVariables = tmp.objectiveVariables;

set(handles.textLoadFileSystemParametersSuccess,'String',...
    'Success!');
    
% Update handles structure

guidata(hObject, handles);


%__________________________________________________________________________
%                     PROBLEM STATEMENT PARAMETERS
%__________________________________________________________________________


% --- Executes on button press in selectSourceLocationFromMap.
function selectSourceLocationFromMap_Callback(hObject, ~, handles)

% Get button status

selectLocationButtonStatus = get(hObject,'Value');

% Prompt user with map display for selecting the source location

if selectLocationButtonStatus == 1
    
    tmp = getSourceIndexFnc( ...
        handles.gridMaskGeoRasterRef, ...
        handles.gridMask );
    handles.sourceRow = tmp(1,1);
    handles.sourceCol = tmp(1,2);
    
    set(handles.inputSourceIndexRow,'String',...
        num2str(handles.sourceRow));
    set(handles.inputSourceIndexColumn,'String',...
        num2str(handles.sourceCol));

elseif selectLocationButtonStatus == 0
    
    handles.sourceRow = [];
    handles.sourceCol = [];
    
end

% Update handles structure

guidata(hObject, handles);


function inputSourceIndexRow_Callback(hObject, ~, handles)

% Read in user input source index row

tmp = get(hObject,'String');
handles.sourceRow = str2double(tmp);
 
% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputSourceIndexRow_CreateFcn(hObject, ~, ~)

if ispc && isequal( ...
        get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))

    set(hObject,'BackgroundColor','white');
    
end


function inputSourceIndexColumn_Callback(hObject, ~, handles)

% Read in user input source index column


tmp = get(hObject,'String');
handles.sourceCol = str2double(tmp);

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputSourceIndexColumn_CreateFcn(hObject, ~, ~)

if ispc && isequal( ...
        get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


% --- Executes on button press in selectDestinationLocationFromMap.
function selectDestinationLocationFromMap_Callback(hObject, ~, handles)

% Get button status

selectLocationButtonStatus = get(hObject,'Value');

% Prompt user with map display for selecting the source location

if selectLocationButtonStatus == 1
    
    tmp = getSourceIndexFnc( ...
        handles.gridMaskGeoRasterRef, ...
        handles.gridMask );
    handles.destinRow = tmp(1,1);
    handles.destinCol = tmp(1,2);
    
    set(handles.inputDestinationIndexRow,'String',...
        num2str(handles.destinRow));
    set(handles.inputDestinationIndexColumn,'String',...
        num2str(handles.destinCol));
    
elseif selectLocationButtonStatus == 0
    
    handles.destinRow = [];
    handles.destinCol = [];
    
end

% Update handles structure

guidata(hObject, handles);


function inputDestinationIndexRow_Callback(hObject, ~, handles)

% Read in user input destination index row

 tmp = get(hObject,'String');
 handles.destinRow = str2double(tmp);

% Update handles structure 

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputDestinationIndexRow_CreateFcn(hObject, ~, ~)

if ispc && isequal( ...
        get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function inputDestinationIndexColumn_Callback(hObject, ~, handles)

% Read in user input destination column

tmp = get(hObject,'String');
handles.destinCol = str2double(tmp);

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputDestinationIndexColumn_CreateFcn(hObject, ~, ~)

if ispc && isequal( ...
        get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


% --- Executes on button press in loadProblemStatementParameters.
function loadProblemStatementParameters_Callback(hObject, ~, handles)

% Get button status

loadProblemStatementButtonStatus = get(hObject,'Value');

if loadProblemStatementButtonStatus == 1
    
    % Write parameters to handle structure
    
    handles.sourceIndex = ...
        [handles.sourceRow handles.sourceCol];
    handles.destinIndex = ...
        [handles.destinRow handles.destinCol];
    
    set(handles.textLoadProblemStatementParametersSuccess,'String',...
    'Success!');
    
elseif loadProblemStatementButtonStatus == 0 
    
    % Clear parameters within handle structure
    
    handles.sourceIndex = [];
    handles.destinIndex = [];
    
end

% Update handles structure

guidata(hObject,handles);


%__________________________________________________________________________
%                    POPULATION INITIALIZATION PARAMETERS
%__________________________________________________________________________


function inputIndividuals_Callback(hObject, ~, handles)

% Read in the user input number of individuals in the population

handles.populationSizeString = get(hObject,'String');
set(handles.inputIndividuals,'String',...
    handles.populationSizeString);

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputIndividuals_CreateFcn(hObject, ~, ~)

if ispc && isequal( ...
        get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function inputRandomness_Callback(hObject, ~, handles)

% Read in randomness coefficient

handles.randomnessString = get(hObject,'String');
set(handles.inputRandomness,'String',...
    handles.randomnessString);

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputRandomness_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectExecutionType.
function selectExecutionType_Callback(hObject, ~, handles)

% Read in execution type selection

handles.executionTypeRaw = get(hObject,'Value')-1;

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function selectExecutionType_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectWalkType.
function selectWalkType_Callback(hObject, ~, handles)

% Read in walk type selection

handles.walkTypeRaw = get(hObject,'Value')-1;

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function selectWalkType_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slideObjectiveFraction_Callback(hObject, ~, handles)

% Get objective fraction slider position

handles.objectiveFractionRaw = get(hObject,'Value');

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slideObjectiveFraction_CreateFcn(hObject, ~, ~)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function inputMinimumClusterSize_Callback(hObject, ~, handles)

% Read in minimum cluster size 

handles.minimumClusterSizeString = get(hObject,'String');

% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputMinimumClusterSize_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in initializePopulation.
function initializePopulation_Callback(hObject, ~, handles)

% Get button status

initializePopulationButtonStatus = get(hObject,'Value');

if initializePopulationButtonStatus == 1
    
    % Write parameters to handle structure
    
    handles.populationSize = str2double(handles.populationSizeString);
    handles.randomness = str2double(handles.randomnessString);
    handles.executionType = handles.executionTypeRaw;
    handles.walkType = handles.walkTypeRaw;
    handles.objectiveFraction = handles.objectiveFractionRaw;
    handles.minimumClusterSize = str2double(handles.minimumClusterSizeString);
    
elseif initializedPopulationButtonStatus == 0 
    
    % Clear parameters within handle structure
    
    handles.populationSize = [];
    handles.randomness = [];
    handles.executionType = [];
    handles.walkType = [];
    handles.objectiveFraction = [];
    handles.minimumClusterSize = [];
    
end

guidata(hObject, handles);

% Update handles structure

guidata(hObject,handles);

% Intialize Population

maxGenerations = 100;
i = 1;
o = cell(maxGenerations,3);

o{i,1} = initPopFnc(...
    handles.populationSize,...
    handles.sourceIndex,...
	handles.destinIndex,...
	handles.objectiveVariables,...
    handles.objectiveFraction,...
	handles.minimumClusterSize,...
    handles.walkType,...
    handles.randomness,...
    handles.executionType,...
	handles.gridMask          );

o{i,2} = popFitnessFnc(...
    o{1,1},...
    handles.objectiveVariables,...
    handles.gridMask          );

o{i,3} = popAvgFitnessFnc(...
    o{1,1},...
    handles.objectiveVariables,...
    handles.gridMask          );

handles.o = o;

% Update handles structure

guidata(hObject, handles);

% Display success message

set(handles.textInitializePopulationSuccess,'String',...
    'Success!');

% Update Handles Structure

guidata(hObject, handles);

disp(handles);
