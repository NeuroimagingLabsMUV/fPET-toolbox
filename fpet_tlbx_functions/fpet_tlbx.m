function fpet_tlbx(fpetbatch)
% fpet toolbox: analysis of functional PET data
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License version 2
% as published by the Free Software Foundation.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
%
% Version: 2.0.0

% set version
v = '2.0.0';
fpetbatch.v = v;

disp('*****')
disp('running fpet toolbox.')

% existing data
error_flag = fpet_tlbx_check_exist(fpetbatch);
if error_flag == 1
    return
end

% glm
if isfield(fpetbatch,'run_glm') && (fpetbatch.run_glm == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 1);
    if error_flag == 0
        fpet_tlbx_glm(fpetbatch);
    end
end

% psc
if isfield(fpetbatch,'run_psc') && (fpetbatch.run_psc == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 2);
    if error_flag == 0
        fpet_tlbx_psc(fpetbatch);
    end
end

% quant
if isfield(fpetbatch,'run_quant') && (fpetbatch.run_quant == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 3);
    if error_flag == 0
        fpet_tlbx_quant(fpetbatch);
    end
end

% tacplot
if isfield(fpetbatch,'run_tacplot') && (fpetbatch.run_tacplot == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 4);
    if error_flag == 0
        fpet_tlbx_tacplot(fpetbatch);
    end
end

% ica
if isfield(fpetbatch,'run_ica') && (fpetbatch.run_ica == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 5);
    if error_flag == 0
        fpet_tlbx_ica(fpetbatch);
    end
end

% conn
if isfield(fpetbatch,'run_conn') && (fpetbatch.run_conn == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 6);
    if error_flag == 0
        fpet_tlbx_conn(fpetbatch);
    end
end

% cov
if isfield(fpetbatch,'run_cov') && (fpetbatch.run_cov == 1)
    error_flag = fpet_tlbx_check_input(fpetbatch, 7);
    if error_flag == 0
        fpet_tlbx_cov(fpetbatch);
    end
end

disp('fpet toolbox finished.')
disp('*****')

return


