package com.example.app;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

@Component
public class Listener {
    private final JmsTemplate jmsTemplate;
    private final Portfolio_Handler portfolioHandler;

    @Autowired
    public Listener(JmsTemplate jmsTemplate, Portfolio_Handler portfolioHandler) {
        this.jmsTemplate = jmsTemplate;
        this.portfolioHandler = portfolioHandler;
    }

    @JmsListener(destination = "INQ")
    public void receiveMessage(String message) {
//        for debugging
//        System.out.println("Received message: " + message);

        String response = portfolioHandler.processCommand(message);

        jmsTemplate.convertAndSend("OUTQ", response);
    }
}