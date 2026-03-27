package com.helpdesk.service;

import java.util.Date;
import java.util.List;

import com.helpdesk.bean.TicketBean;
import com.helpdesk.dao.TicketDAO;

public class TicketService {

    private final TicketDAO ticketDAO;
    private final PriorityRoutingService priorityRoutingService;
    private final SLAService slaService;

    public TicketService() {
        this.ticketDAO = new TicketDAO();
        this.priorityRoutingService = new PriorityRoutingService();
        this.slaService = new SLAService();
    }

    public boolean createTicket(TicketBean ticket) {
        if (ticket == null || ticket.getRaisedBy() <= 0 || isBlank(ticket.getTitle()) || isBlank(ticket.getDescription())
                || isBlank(ticket.getCategory())) {
            return false;
        }

        // Block duplicate ticket: same user + same title within last 10 minutes
        if (isDuplicateRecentTicket(ticket.getRaisedBy(), ticket.getTitle())) {
            return false;
        }

        String priority = priorityRoutingService.assignPriority(ticket.getCategory());
        ticket.setPriority(priority);

        int agentId = priorityRoutingService.findAvailableAgentId();
        if (agentId > 0) {
            ticket.setAssignedTo(agentId);
            ticket.setStatus("ASSIGNED");
        } else {
            ticket.setAssignedTo(0);
            ticket.setStatus("OPEN");
        }

        Date slaDeadline = slaService.calculateDeadline(priority);
        ticket.setSlaDeadline(slaDeadline);

        return ticketDAO.createTicket(ticket);
    }

    private boolean isDuplicateRecentTicket(int userId, String title) {
        List<TicketBean> userTickets = ticketDAO.getTicketsByUser(userId);
        if (userTickets == null || userTickets.isEmpty()) {
            return false;
        }

        String normalizedTitle = title.trim().toLowerCase();
        long now = System.currentTimeMillis();
        long tenMinutesInMillis = 10L * 60L * 1000L;

        for (TicketBean existingTicket : userTickets) {
            if (existingTicket.getTitle() == null || existingTicket.getCreatedAt() == null) {
                continue;
            }

            String existingTitle = existingTicket.getTitle().trim().toLowerCase();
            long ageMillis = now - existingTicket.getCreatedAt().getTime();

            if (normalizedTitle.equals(existingTitle) && ageMillis >= 0 && ageMillis <= tenMinutesInMillis) {
                return true;
            }
        }
        return false;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
