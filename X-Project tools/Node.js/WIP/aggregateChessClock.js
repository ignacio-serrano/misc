function updateYMDHM(obj, str) {
    if (str.includes(':')) {
        var a = str.split(':');
        obj.hour = a[0];
        obj.minute = a[1];
    } else if (str.includes('/')) {
        var a = str.split('/');
        obj.day = a[0];
        obj.month = parseInt(a[1], 10) - 1;
        obj.year = a[2];
    }
}

function dateFromYMDHM(moment) {
    return new Date(moment.year, moment.month, moment.day, moment.hour, moment.minute);
}

function printTree(tree) {
    for (var i in tree) {
        if (i !== '_elapsed') {
            var p = '';
            for (var c = 0; c < printTree.indent; c++) {
                p += '  '
            }
            p += i + ': ' + tree[i]._elapsed + ' minutes';
            console.log(p);

            printTree.indent++;
            printTree(tree[i]);
            printTree.indent--;
        }
    }
}
printTree.indent = 0;

var fs = require('fs');
//var stat = fs.statSync('Y:\\Chess Clock.txt');
//console.log('Y:\\Chess Clock.txt is ' + (stat.isFile() ? '' : 'NOT ') + 'a file.');

//console.log(process.argv);

var start = null;
var end = null;

var startFlag = false;
var endFlag = false;
var startObj = {
    year: null,
    month: null,
    day: null,
    hour: 0,
    minute: 0
};
var endObj = {
    year: null,
    month: null,
    day: null,
    hour: 0,
    minute: 0
};

for (var i = 2; i < process.argv.length; i++) {
    var currentArg = process.argv[i];
    if (currentArg === '--from') {
        startFlag = true;
        endFlag = false;
        start = process.argv[i+1] + ' ' + process.argv[i+2];
    } else if (currentArg === '--to') {
        startFlag = false;
        endFlag = true;
        end = process.argv[i+1] + ' ' + process.argv[i+2];
    } else if (startFlag) {
        updateYMDHM(startObj, currentArg);
    } else if (endFlag) {
        updateYMDHM(endObj, currentArg);
    }
}

if (startObj.year !== null &&
        startObj.month !== null &&
        startObj.day !== null) {
    console.log('Start date set!');
    start = dateFromYMDHM(startObj);
}
if (endObj.year !== null &&
        endObj.month !== null &&
        endObj.day !== null) {
    console.log('End date set!');
    end = dateFromYMDHM(endObj);
}

console.log('Start: ' + start);
console.log('End: ' + end);

var content = fs.readFileSync('Y:\\Chess Clock.txt', 'binary').split('\r\n');

var taskTree = {_elapsed: 0};
var previousDateTime = null;
for (var i = 0; i < content.length; i++) {
    var currentLine = content[i];
    /* Skips empty lines. */
    if (currentLine === '') {
        continue;
    }
    var a = currentLine.split(' ');
    var currentMoment = {};
    updateYMDHM(currentMoment, a[0]);
    updateYMDHM(currentMoment, a[1]);
    currentDateTime = dateFromYMDHM(currentMoment);

    if (currentDateTime >= start && currentDateTime < end) {
        var currentTaskStr = a[2];
        for (var j = 3; j < a.length; j++) {
            currentTaskStr+= ' ' + a[j];
        }
        //console.log(currentTaskStr);

        a = currentTaskStr.split('/');
        //console.log(a);

        var currentTaskNode = taskTree;
        for (var j = 0; j < a.length; j++) {
            if (typeof currentTaskNode[a[j]] === 'undefined') {
                currentTaskNode[a[j]] = {_elapsed: 0};
            }
            currentTaskNode = currentTaskNode[a[j]];
            if (previousDateTime !== null) {
                currentTaskNode._elapsed+= (currentDateTime - previousDateTime)/1000/60;
            }
        }
        previousDateTime = currentDateTime;
    }
}

//console.log(taskTree);
printTree(taskTree);
