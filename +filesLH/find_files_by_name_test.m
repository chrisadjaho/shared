function tests = find_files_by_name_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)
% Just syntax test. Without creating a test directory full of files, this is hard to test.

compS = configLH.Computer([]);
baseDir = compS.sharedDirV{1};
fileMaskIn = '*.m';
inclSubDirs = true;

% No regex
findStrV = {'find_files', 'cannot find this'};
useRegEx = false;

outV = filesLH.find_files_by_name(baseDir, fileMaskIn, inclSubDirs, findStrV, useRegEx);

% Regex
findStrV = 'find_f[ile]+s';
useRegEx = true;
outV = filesLH.find_files_by_name(baseDir, fileMaskIn, inclSubDirs, findStrV, useRegEx);

% keyboard;

end