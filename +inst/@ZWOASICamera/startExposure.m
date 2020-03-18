function startExposure(Z,expTime)
% set up the scenes for taking a single exposure

    switch Z.CamStatus
        case {'idle','unknown'} % shall we try exposing for 'unknown' too?
            if exist('expTime','var')
                Z.ExpTime=expTime;
            end

            Z.progressive_frame=0;

            Z.allocate_image_buffer

            t0=now;
            ret=ASIStartExposure(Z.camhandle);
            t1=now;
            
            Z.time_start_delta=t1-t0;
            
            success=ret==inst.ASI_ERROR_CODE.ASI_SUCCESS;

            Z.setLastError(success,'could not start single exposure');

            if success
                Z.time_start=t0;
                Z.lastExpTime=Z.ExpTime;
                Z.CamStatus='exposing';
            else
                Z.time_start=NaN;
                Z.lastExpTime=NaN;
                Z.CamStatus='unknown';
                Z.deallocate_image_buffer
            end
        otherwise
            Z.deallocate_image_buffer
            Z.lastError='camera not ready to start exposure';
    end

end
