var filePath = '~/Documents/windowPositions/';
var app = Application.currentApplication();
app.includeStandardAdditions = true;
//get list of files in special folder
var fileList = Application("System Events").folders.byName(filePath).diskItems.name();
if (fileList.length > 0) {
	//choose file
	var whichFile = app.chooseFromList(fileList, {withPrompt: "Which Positions?", defaultItems: fileList[0], cancelButtonName: 'Save/Cancel'});
	
}
if (!whichFile) {
	//hit save/cancel
	saveWindowPositions();
} else {
	loadWindowPositions(whichFile[0]);
}

function saveWindowPositions() {
	//prompt name
	try { 
		var prompt = app.displayDialog('Save positions under what name?', {defaultAnswer: "My Window Positions"});
	} catch (e) {
		//do nothing if cancelled
		return;
	}
	positionsName = prompt.textReturned;
	
	var savedPositions = [];
	
	//loop through all applications
	var appList = Application("System Events").applicationProcesses.whose({visible: true}).name();
	
	for (appNum in appList) {
		var appName = appList[appNum];
		
		//loop thru all windows for apps
		var windowList = Application(appName).windows;
		
		for (windowNum in  windowList) {
			var whichWindow = windowList[windowNum];
			
			//put app name, window num, and loc in list
			savedPositions.push({app: appName, window: windowNum, bounds: whichWindow.bounds()});
		}
	}
	
	// open new file
	var file = app.openForAccess(filePath + positionsName, { writePermission: true });
	app.setEof(file, { to: 0 });
	
	//write data to file
	app.write(JSON.stringify(savedPositions), {to: file});
	app.closeAccess(file);
}

function saveWindowPositions() {
	//prompt name
	try { 
		var prompt = app.displayDialog('Save positions under what name?', {defaultAnswer: "My Window Positions"});
	} catch (e) {
		//do nothing if cancelled
		return;
	}
	positionsName = prompt.textReturned;
	
	var savedPositions = [];
	
	//loop through all applications
	var appList = Application("System Events").applicationProcesses.whose({visible: true}).name();
	
	for (appNum in appList) {
		var appName = appList[appNum];
		
		//loop thru all windows for apps
		var windowList = Application(appName).windows;
		
		for (windowNum in  windowList) {
			var whichWindow = windowList[windowNum];
			
			//put app name, window num, and loc in list
			savedPositions.push({app: appName, window: windowNum, bounds: whichWindow.bounds()});
		}
	}
	
	// open new file
	var file = app.openForAccess(filePath + positionsName, { writePermission: true });
	app.setEof(file, { to: 0 });
	
	//write data to file
	app.write(JSON.stringify(savedPositions), {to: file});
	app.closeAccess(file);
}

function loadWindowPositions(filename) {
	//get saved pos 
	var fileText = app.read(Path(filePath + filename));
	var savedPositions = JSON.parse(fileText);
	
	//loop thru windows
	for (windowNum in savedPositions) {
		var windowData = savedPositions[windowNum];
		
		//if window, set pos
		if (windowData.window < Application(windowData.app).windows.length) {
			Application(windowData.app).windows[windowData.window].bounds = windowData.bounds;
		}
	}
}