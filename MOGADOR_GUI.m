function varargout = MOGADOR_GUI(varargin)
% MOGADOR_GUI MATLAB code for MOGADOR_GUI.fig
%      MOGADOR_GUI, by itself, creates a new MOGADOR_GUI or raises the 
%      existing singleton*.
%
%      H = MOGADOR_GUI returns the handle to a new MOGADOR_GUI or the handle to
%      the existing singleton*.
%
%      MOGADOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the 
%      local function named CALLBACK in MOGADOR_GUI.M with the given input 
%      arguments.
%
%      MOGADOR_GUI('Property','Value',...) creates a new MOGADOR_GUI or raises 
%      the existing singleton*.  Starting from the left, property value 
%      pairs are applied to the GUI before MOGADOR_OpeningFcn gets called. 
%      An unrecognized property name or invalid value makes property 
%      application stop.  All inputs are passed to MOGADOR_OpeningFcn via 
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MOGADOR_GUI

% Last Modified by GUIDE v2.5 22-Aug-2014 09:01:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MOGADOR_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MOGADOR_GUI_OutputFcn, ...
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


% --- Executes just before MOGADOR_GUI is made visible.
function MOGADOR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MOGADOR_GUI (see VARARGIN)

% Choose default command line output for MOGADOR_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MOGADOR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MOGADOR_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inputSourceRowSubscript_Callback(hObject, eventdata, handles)
% hObject    handle to inputSourceRowSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputSourceRowSubscript as text
%        str2double(get(hObject,'String')) returns contents of inputSourceRowSubscript as a double


% --- Executes during object creation, after setting all properties.
function inputSourceRowSubscript_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputSourceRowSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputPopulationSizeRowCount_Callback(hObject, eventdata, handles)
% hObject    handle to inputPopulationSizeRowCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputPopulationSizeRowCount as text
%        str2double(get(hObject,'String')) returns contents of inputPopulationSizeRowCount as a double


% --- Executes during object creation, after setting all properties.
function inputPopulationSizeRowCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputPopulationSizeRowCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputGenomeLengthColumnCount_Callback(hObject, eventdata, handles)
% hObject    handle to inputGenomeLengthColumnCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputGenomeLengthColumnCount as text
%        str2double(get(hObject,'String')) returns contents of inputGenomeLengthColumnCount as a double


% --- Executes during object creation, after setting all properties.
function inputGenomeLengthColumnCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputGenomeLengthColumnCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputSourceColumnSubscript_Callback(hObject, eventdata, handles)
% hObject    handle to inputSourceColumnSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputSourceColumnSubscript as text
%        str2double(get(hObject,'String')) returns contents of inputSourceColumnSubscript as a double


% --- Executes during object creation, after setting all properties.
function inputSourceColumnSubscript_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputSourceColumnSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputDestinationRowSubscript_Callback(hObject, eventdata, handles)
% hObject    handle to inputDestinationRowSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputDestinationRowSubscript as text
%        str2double(get(hObject,'String')) returns contents of inputDestinationRowSubscript as a double


% --- Executes during object creation, after setting all properties.
function inputDestinationRowSubscript_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputDestinationRowSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputDestinationColumnSubscript_Callback(hObject, eventdata, handles)
% hObject    handle to inputDestinationColumnSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputDestinationColumnSubscript as text
%        str2double(get(hObject,'String')) returns contents of inputDestinationColumnSubscript as a double


% --- Executes during object creation, after setting all properties.
function inputDestinationColumnSubscript_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputDestinationColumnSubscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectWalkType.
function selectWalkType_Callback(hObject, eventdata, handles)
% hObject    handle to selectWalkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectWalkType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectWalkType


% --- Executes during object creation, after setting all properties.
function selectWalkType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectWalkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectExecutionType.
function selectExecutionType_Callback(hObject, eventdata, handles)
% hObject    handle to selectExecutionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectExecutionType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectExecutionType


% --- Executes during object creation, after setting all properties.
function selectExecutionType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectExecutionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slideObjectiveFraction_Callback(hObject, eventdata, handles)
% hObject    handle to slideObjectiveFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slideObjectiveFraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideObjectiveFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function inputObjectiveVariableFilepath_Callback(hObject, eventdata, handles)
% hObject    handle to inputObjectiveVariableFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputObjectiveVariableFilepath as text
%        str2double(get(hObject,'String')) returns contents of inputObjectiveVariableFilepath as a double


% --- Executes during object creation, after setting all properties.
function inputObjectiveVariableFilepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputObjectiveVariableFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function inputOutputResultsDirectoryPath_Callback(hObject, eventdata, handles)
% hObject    handle to inputOutputResultsDirectoryPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputOutputResultsDirectoryPath as text
%        str2double(get(hObject,'String')) returns contents of inputOutputResultsDirectoryPath as a double


% --- Executes during object creation, after setting all properties.

function inputOutputResultsDirectoryPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputOutputResultsDirectoryPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inputSearchDomainFilepath_Callback(hObject, eventdata, handles)
% hObject    handle to inputSearchDomainFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p.searchDomainFilepath = get(hObject,'String');
p.gridMask = load(p.searchDomainFilepath);


% Hints: get(hObject,'String') returns contents of inputSearchDomainFilepath as text
%        str2double(get(hObject,'String')) returns contents of inputSearchDomainFilepath as a double

% --- Executes during object creation, after setting all properties.
function inputSearchDomainFilepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputSearchDomainFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function fileSystemParameters_Callback(hObject, eventdata, handles)
% hObject    handle to fileSystemParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function problemSpecificationParameters_Callback(hObject, eventdata, handles)
% hObject    handle to problemSpecificationParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to inputSearchDomainFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fileSystemParametersContext_Callback(hObject, eventdata, handles)
% hObject    handle to fileSystemParametersContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function inputMinimumObjectiveClusterSizeCellCount_Callback(hObject, eventdata, handles)
% hObject    handle to inputMinimumObjectiveClusterSizeCellCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputMinimumObjectiveClusterSizeCellCount as text
%        str2double(get(hObject,'String')) returns contents of inputMinimumObjectiveClusterSizeCellCount as a double


% --- Executes during object creation, after setting all properties.
function inputMinimumObjectiveClusterSizeCellCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputMinimumObjectiveClusterSizeCellCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputCoefficientOfRandomnessValue_Callback(hObject, eventdata, handles)
% hObject    handle to inputCoefficientOfRandomnessValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputCoefficientOfRandomnessValue as text
%        str2double(get(hObject,'String')) returns contents of inputCoefficientOfRandomnessValue as a double


% --- Executes during object creation, after setting all properties.
function inputCoefficientOfRandomnessValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputCoefficientOfRandomnessValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generateInitialPopulation.
function generateInitialPopulation_Callback(hObject, eventdata, handles)
% hObject    handle to generateInitialPopulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of generateInitialPopulation


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes on button press in loadFileSystemParameters.
function loadFileSystemParameters_Callback(hObject, eventdata, handles)
% hObject    handle to loadFileSystemParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadFileSystemParameters


% --- Executes on button press in loadProblemSpecificationParameters.
function loadProblemSpecificationParameters_Callback(hObject, eventdata, handles)
% hObject    handle to loadProblemSpecificationParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadProblemSpecificationParameters


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slideMutationFraction_Callback(hObject, eventdata, handles)
% hObject    handle to slideMutationFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slideMutationFraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideMutationFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function inputMutationCountValue_Callback(hObject, eventdata, handles)
% hObject    handle to inputMutationCountValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputMutationCountValue as text
%        str2double(get(hObject,'String')) returns contents of inputMutationCountValue as a double


% --- Executes during object creation, after setting all properties.
function inputMutationCountValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputMutationCountValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slideSelectionProbability_Callback(hObject, eventdata, handles)
% hObject    handle to slideSelectionProbability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slideSelectionProbability_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideSelectionProbability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slideSelectionFraction_Callback(hObject, eventdata, handles)
% hObject    handle to slideSelectionFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slideSelectionFraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideSelectionFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in selectCrossoverType.
function selectCrossoverType_Callback(hObject, eventdata, handles)
% hObject    handle to selectCrossoverType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectCrossoverType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectCrossoverType


% --- Executes during object creation, after setting all properties.
function selectCrossoverType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectCrossoverType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkIndividualPlot.
function checkIndividualPlot_Callback(hObject, eventdata, handles)
% hObject    handle to checkIndividualPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkIndividualPlot


% --- Executes on button press in checkPopulationParetoFrontierPlot.
function checkPopulationParetoFrontierPlot_Callback(hObject, eventdata, handles)
% hObject    handle to checkPopulationParetoFrontierPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkPopulationParetoFrontierPlot


% --- Executes on button press in checkPopulationEvolutionaryConvergencePlot.
function checkPopulationEvolutionaryConvergencePlot_Callback(hObject, eventdata, handles)
% hObject    handle to checkPopulationEvolutionaryConvergencePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkPopulationEvolutionaryConvergencePlot


% --------------------------------------------------------------------
function populationInitializationParameters_Callback(hObject, eventdata, handles)
% hObject    handle to populationInitializationParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function evoluationaryOperators_Callback(hObject, eventdata, handles)
% hObject    handle to evoluationaryOperators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selectionParameters_Callback(hObject, eventdata, handles)
% hObject    handle to selectionParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function crossoverParameters_Callback(hObject, eventdata, handles)
% hObject    handle to crossoverParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mutatoinParameters_Callback(hObject, eventdata, handles)
% hObject    handle to mutatoinParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function executionType_Callback(hObject, eventdata, handles)
% hObject    handle to executionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function walkSectionType_Callback(hObject, eventdata, handles)
% hObject    handle to walkSectionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function objectiveFraction_Callback(hObject, eventdata, handles)
% hObject    handle to objectiveFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function maximumObjectiveClusterSize_Callback(hObject, eventdata, handles)
% hObject    handle to maximumObjectiveClusterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_16_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sourceLocation_Callback(hObject, eventdata, handles)
% hObject    handle to sourceLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function destinationLocation_Callback(hObject, eventdata, handles)
% hObject    handle to destinationLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function populationSize_Callback(hObject, eventdata, handles)
% hObject    handle to populationSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function genomeLength_Callback(hObject, eventdata, handles)
% hObject    handle to genomeLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function inputObjectiveVariableFilepath_Callback(hObject, eventdata, handles)
% hObject    handle to inputObjectiveVariableFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mutationFraction_Callback(hObject, eventdata, handles)
% hObject    handle to mutationFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function crossoverType_Callback(hObject, eventdata, handles)
% hObject    handle to crossoverType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selectionFraction_Callback(hObject, eventdata, handles)
% hObject    handle to selectionFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selectionProbability_Callback(hObject, eventdata, handles)
% hObject    handle to selectionProbability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkIndividualFitnessTradeoffPlot.
function checkIndividualFitnessTradeoffPlot_Callback(hObject, eventdata, handles)
% hObject    handle to checkIndividualFitnessTradeoffPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkIndividualFitnessTradeoffPlot


% --------------------------------------------------------------------
function outputPlotParameters_Callback(hObject, eventdata, handles)
% hObject    handle to outputPlotParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function inputPlotIndividualRowValue_Callback(hObject, eventdata, handles)
% hObject    handle to inputPlotIndividualRowValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputPlotIndividualRowValue as text
%        str2double(get(hObject,'String')) returns contents of inputPlotIndividualRowValue as a double


% --- Executes during object creation, after setting all properties.
function inputPlotIndividualRowValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputPlotIndividualRowValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function individualPlotParameters_Callback(hObject, eventdata, handles)
% hObject    handle to individualPlotParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function populationPlotParameters_Callback(hObject, eventdata, handles)
% hObject    handle to populationPlotParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function searchDomainFilepathContext_Callback(hObject, eventdata, handles)
% hObject    handle to searchDomainFilepathContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function populationEvolutionaryConvergencePlot_Callback(hObject, eventdata, handles)
% hObject    handle to populationEvolutionaryConvergencePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function populationParetoFrontierPlot_Callback(hObject, eventdata, handles)
% hObject    handle to populationParetoFrontierPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function individualToPlot_Callback(hObject, eventdata, handles)
% hObject    handle to individualToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function individualPlot_Callback(hObject, eventdata, handles)
% hObject    handle to individualPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function individualFitnessTradeoffPlot_Callback(hObject, eventdata, handles)
% hObject    handle to individualFitnessTradeoffPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkEpigeneticSmoothingOfFinalPopulation.
function checkEpigeneticSmoothingOfFinalPopulation_Callback(hObject, eventdata, handles)
% hObject    handle to checkEpigeneticSmoothingOfFinalPopulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkEpigeneticSmoothingOfFinalPopulation


% --------------------------------------------------------------------
function selectionFractionContext_Callback(hObject, eventdata, handles)
% hObject    handle to selectionFractionContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selectionProbabilityContext_Callback(hObject, eventdata, handles)
% hObject    handle to selectionProbabilityContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function crossoverTypeContext_Callback(hObject, eventdata, handles)
% hObject    handle to crossoverTypeContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mutationFractionContext_Callback(hObject, eventdata, handles)
% hObject    handle to mutationFractionContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mutationCountContext_Callback(hObject, eventdata, handles)
% hObject    handle to mutationCountContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_48_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function executionTypeContext_Callback(hObject, eventdata, handles)
% hObject    handle to executionTypeContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function walkTypeContext_Callback(hObject, eventdata, handles)
% hObject    handle to walkTypeContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function objectiveFractionContext_Callback(hObject, eventdata, handles)
% hObject    handle to objectiveFractionContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function minimumObjectiveClusterSizeContext_Callback(hObject, eventdata, handles)
% hObject    handle to minimumObjectiveClusterSizeContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function coefficientOfRandomnessContext_Callback(hObject, eventdata, handles)
% hObject    handle to coefficientOfRandomnessContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sourceLocationContext_Callback(hObject, eventdata, handles)
% hObject    handle to sourceLocationContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function destinationLocationContext_Callback(hObject, eventdata, handles)
% hObject    handle to destinationLocationContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function populationSizeContext_Callback(hObject, eventdata, handles)
% hObject    handle to populationSizeContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function genomeLengthContext_Callback(hObject, eventdata, handles)
% hObject    handle to genomeLengthContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function epigeneticSmoothingParameters_Callback(hObject, eventdata, handles)
% hObject    handle to epigeneticSmoothingParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function objectiveVariableFilepathContext_Callback(hObject, eventdata, handles)
% hObject    handle to objectiveVariableFilepathContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function outputResultsDirectoryPathContext_Callback(hObject, eventdata, handles)
% hObject    handle to outputResultsDirectoryPathContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function epigeneticSmoothingOfFinalPopulation_Callback(hObject, eventdata, handles)
% hObject    handle to epigeneticSmoothingOfFinalPopulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function problemSpecificationParametersContext_Callback(hObject, eventdata, handles)
% hObject    handle to problemSpecificationParametersContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function populationInitializationParametersContext_Callback(hObject, eventdata, handles)
% hObject    handle to populationInitializationParametersContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function evolutionaryOperators_Callback(hObject, eventdata, handles)
% hObject    handle to evolutionaryOperators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function outputPlots_Callback(hObject, eventdata, handles)
% hObject    handle to outputPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browseSearchDomainFilepath.
function browseSearchDomainFilepath_Callback(hObject, eventdata, handles)
% hObject    handle to browseSearchDomainFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browseObjectiveVariableFilepath.
function browseObjectiveVariableFilepath_Callback(hObject, eventdata, handles)
% hObject    handle to browseObjectiveVariableFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browseOutputResultsDirectoryPath.
function browseOutputResultsDirectoryPath_Callback(hObject, eventdata, handles)
% hObject    handle to browseOutputResultsDirectoryPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
