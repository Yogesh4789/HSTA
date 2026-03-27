package com.helpdesk.service;

import java.util.Calendar;
import java.util.Date;

import com.helpdesk.bean.SLAPolicyBean;
import com.helpdesk.dao.SLAPolicyDAO;

public class SLAService {

    private final SLAPolicyDAO slaPolicyDAO;

    public SLAService() {
        this.slaPolicyDAO = new SLAPolicyDAO();
    }

    public Date calculateDeadline(String priority) {
        String effectivePriority = (priority == null || priority.trim().isEmpty()) ? "HIGH" : priority.trim();
        SLAPolicyBean policy = slaPolicyDAO.getSLAByPriority(effectivePriority);

        // Fallback to HIGH policy if requested policy does not exist
        if (policy == null) {
            policy = slaPolicyDAO.getSLAByPriority("HIGH");
        }

        int resolutionHours = 24;
        if (policy != null && policy.getResolutionTimeHours() > 0) {
            resolutionHours = policy.getResolutionTimeHours();
        }

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.HOUR_OF_DAY, resolutionHours);
        return calendar.getTime();
    }
}
