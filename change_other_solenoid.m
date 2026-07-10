function change_other_solenoid(beamline, strengthspot, val, parameter)
    code = beamline(val,1);
    if(beamline(val+1,1) == code)
        beamline(val+1,strengthspot) = parameter;
    elseif(beamline(val-1,1) == code)
        beamline(val-1,strengthspot) = parameter;
    elseif(beamline(val+2,1) == code)
        beamline(val+2,strengthspot) = parameter;
    elseif(beamline(val-2,1) == code)
        beamline(val-2,strengthspot) = parameter;
    end
end