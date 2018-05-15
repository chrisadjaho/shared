% Binary decision of the form
%  max(V1, V2 + p) with p ~ N(0, sigmaP)
classdef BinaryDecision < handle
   
properties
   % Std dev of pref shock
   sigmaP  double
   
   dbg = 0;
end

methods
   %% Constructor
   function bS = BinaryDecision(sigmaP)
      bS.sigmaP = sigmaP;
   end
   
   
   %% Decision prob, given values
   %{
   Prob of choosing option 1, given values
   Equals Pr(p < v1V - v2V) = normcdf(v1V - v2V)
   %}
   function prob1V = prob1(bS, v1V, v2V)
      prob1V = normcdf(v1V - v2V,  0,  bS.sigmaP);
      validateattributes(prob1V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
         'size', size(v1V)})
   end
   
   
   %% Expected utility before pref shock is revealed
   function [eUtilV, prob1V] = expected_utility(bS, v1V, v2V)
      % Input check
      if bS.dbg
         validateattributes(v1V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(v2V)})
         validateattributes(v2V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
      end

      % Prob of choosing option 1
      prob1V = bS.prob1(v1V, v2V);
      
      % Mean of pref shock, conditional on choosing option 2 (p > v1 - v2)
      % For very large v1-v2, prob1 = 1 and the truncated mean cannot be computed
      pMeanV = distribLH.truncated_normal(0, bS.sigmaP,  (v1V - v2V) .* (prob1V < 1 - 1e-6),  [],  bS.dbg);
      eUtilV = prob1V .* v1V + (1 - prob1V) .* (v2V + pMeanV);
      
      % Check for cases with probabilities very close to 0 or 1
      iV = (prob1V > 1 - 1e-6);
      if any(iV)
         eUtilV(iV) = v1V(iV);
      end
      iV = (prob1V < 1e-6);
      if any(iV)
         eUtilV(iV) = v2V(iV);
      end

      validateattributes(eUtilV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(v1V)})

%       rng('default');
%       pV = randn(1e6,1) .* bS.sigmaP;
%       pV(pV <= v1V - v2V) = [];
%       pMean = mean(pV);
%       keyboard
   end
   
end
   
   
end