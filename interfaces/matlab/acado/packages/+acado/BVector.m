% A matrix built from standard Matlab matrix notations.
% Stored both as a Matrix and as a VariablesGrid Object
%
%  Usage:
%    >> BVector([MATRIX]);
%
%  Parameters:
%    [MATRIX] a numeric  vector
%
%
%  Example:
%
%
%  Licence:
%    This file is part of ACADO Toolkit  - (http://www.acadotoolkit.org/)
%
%    ACADO Toolkit -- A Toolkit for Automatic Control and Dynamic Optimization.
%    Copyright (C) 2008-2009 by Boris Houska and Hans Joachim Ferreau, K.U.Leuven.
%    Developed within the Optimization in Engineering Center (OPTEC) under
%    supervision of Moritz Diehl. All rights reserved.
%
%    ACADO Toolkit is free software; you can redistribute it and/or
%    modify it under the terms of the GNU Lesser General Public
%    License as published by the Free Software Foundation; either
%    version 3 of the License, or (at your option) any later version.
%
%    ACADO Toolkit is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%    Lesser General Public License for more details.
%
%    You should have received a copy of the GNU Lesser General Public
%    License along with ACADO Toolkit; if not, write to the Free Software
%    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
%
%    Author: Rien Quirynen
%    Date: 2013
%
classdef BVector < acado.Matrix
    properties
    end
    
    methods
        function obj = BVector(val)
            if nargin > 0
                global ACADO_;
                
                if (isa(val, 'numeric'))
                    ACADO_.count_matrix = ACADO_.count_matrix+1;
                    obj.name = strcat('acadodata_M', num2str(ACADO_.count_matrix));
                    
                    obj.items = val;
                    
                    ACADO_.helper.addInstruction(obj);
                    
                elseif (isa(val, 'acado.MexInput'))
                    
                    if (val.type ~= 2)
                        error('MexInput should be in this case a vector, not a scalar or matrix.');
                    end
                    
                    obj.name = val.name;
                    
                else
                    error('Matrix expects a numeric value or a acado.MexInput');
                    
                end
            end
        end
        
        function getInstructions(obj, cppobj, get)
            if (get == 'FB')
                
                % This is NOT executed for mex inputs
                
                dlmwrite(sprintf('%s_data_%s.txt', cppobj.problemname, obj.name), obj.items, 'delimiter', '\t', 'precision', '%d');
                
                fprintf(cppobj.fileMEX,sprintf('    BVector %s;\n    %s.read( "%s_data_%s.txt" );\n', obj.name, obj.name, cppobj.problemname, obj.name));
                
                
            end
        end
        
    end
    
end

