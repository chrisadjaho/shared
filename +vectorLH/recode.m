function v = recode(vIn, searchV, replaceV, otherVal, replaceOther, dbg)
% Replace each occurrence of a value in searchV by the corresponding value in replaceV
%{
% TASK:
%  Does not do nested replacements (1->2  then 2->3)
%  It only replaces the values in the original vector vIn

IN:
   searchV  ::  numeric
      values to be searched
   replaceV ::  numeric or cell
      values to replace those in searchV
   replaceOther  ::  logical
      replace all other values with otherVal or keep them?
   otherVal

OUT:
   vector with replace values

% EXAMPLE:
%  vIn = [1 2 3 4];
%  searchV = [2 3];
%  replaceV = [222 333];
%  otherVal = 999;
%  replaceOther = 1;
%  Then v = [999 222 333 999]

% AUTHOR: Lutz Hendricks, 1996

Note:
Built-in function 'changem' does something similar, except it does not touch values that are not in
replaceV. Part of mapping toolbox
%}

%% Input check
if dbg
   validateattributes(searchV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(replaceV)})
   assert(isa(replaceOther, 'logical'));
end


%% Main
if isnumeric(replaceV)
   if replaceOther
      v = repmat(otherVal, size(vIn));
   else
      v = vIn;
   end

   for i1 = 1 : length(searchV)
      v(vIn == searchV(i1)) = replaceV(i1);
   end
   
else
   % Replace with cell values
   assert(isa(replaceV, 'cell'));
   
   % Must replace values that are not found (b/c type changes)
   v = repmat({otherVal}, size(vIn));

   for i1 = 1 : length(searchV)
      v(vIn == searchV(i1)) = replaceV(i1);
   end
end
   

end