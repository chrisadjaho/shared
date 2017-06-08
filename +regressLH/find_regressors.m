function [idxV, betaV] = find_regressors(mdl, varNameStrV, dbg)
% Find regressors by name in a LinearModel
%{
If regressor not found: return NaN

'regressors_by_name' looks for partial matches

IN
   mdl
      linear model
   varNameStrV
      variable names, e.g. 'age'

OUT
   idxV
      mdl.Coefficients.Estimate(idxV) holds coefficient estimates
%}

if isa(varNameStrV, 'char')
   varNameStrV = {varNameStrV};
end

n = length(varNameStrV);

idxV = nan([n, 1]);
betaV = nan([n, 1]);
for i1 = 1 : n
   vIdx = find(strcmp(mdl.CoefficientNames, varNameStrV{i1}));
   if ~isempty(vIdx)
      idxV(i1) = vIdx;
      betaV(i1) = mdl.Coefficients.Estimate(vIdx);
   end
end

end