% Bounded grid, calibrated from bounded parameters
%{
Example: 
   A model with a capital grid between kMin and kMax
   Calibrate the grid points 
   Calibrated parameters are

   updated grid construction; make new function for this +++++
   benefit: can control the grid end points with 2 parameters
      dxV(1) is the first grid point
      dxV(N):  k(N) = k(1) + dxV(N) * (1 - k1)
      dxV(n):  k(n) = k(n-1) + (k(N) - k(n-1)) * dxV(n)
      Then scale everything to lie in [kMin, kMax]

   original grid construction:
      k1Ratio = (k1 - kMin) / (kMax - kMin) 
         in [0, 1)
      dkV(1 : (n-1))
         dkV(j) = (k(j+1) - k(j)) / (kMax - k(j))
         in (0, 1)

When calling this, bound all inputs to ensure that grid points do not become identical
%}
classdef GridBounded
   
properties
   % No of grid points
   n  double
   % Bounds
   xMin  double
   xMax  double
%    % Minimum gap between grid points (optional)
%    minGap   double = 1e-8;
end


methods
   %% Constructor
   function gS = GridBounded(n, xMin, xMax)
      gS.n = n;
      gS.xMin = xMin;
      gS.xMax = xMax;
      
      gS.validate;
   end
   
   
   %% Validate
   function validate(gS)
      validateattributes(gS.xMax, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
         '>', gS.xMin + 1e-6})
   end
   
   
   %% Make the grid from calibrated parameters
   %{
   IN
      x1Ratio
         where is first grid point in permitted range?
         in (0,1)
      dxV
         grid increments in (0, 1)
         each gives location of grid point between next lower point and upper bound
   %}
   function gridV = make_grid(gS, x1Ratio, dxV)
      validateattributes(dxV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<', 1, ...
         'size', [gS.n - 1, 1]})
      validateattributes(x1Ratio, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>=', gS.xMin, ...
         '<', 1 - 1e-6})
      
      gridV = zeros(gS.n, 1);
      gridV(1) = gS.xMin  +  x1Ratio .* (gS.xMax - gS.xMin);
      for ig = 1 : (gS.n - 1)
         gridV(ig + 1) = gridV(ig) + dxV(ig) .* (gS.xMax - gridV(ig));
      end
      
      validateattributes(gridV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', ...
         '>=', gS.xMin,  '<=', gS.xMax,  'size', [gS.n, 1]})
   end
end
   
   
end