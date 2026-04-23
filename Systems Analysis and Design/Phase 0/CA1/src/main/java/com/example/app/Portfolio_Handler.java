package com.example.app;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class Portfolio_Handler {

    private final Map<String, Integer> portfolio = new HashMap<>();

    public String processCommand(String command) {
        String[] parts = command.split(" ");
        String action = parts[0];
        String security;
        int amount;

        switch (action) {
            case "BUY":
                security = parts[1];
                amount = Integer.parseInt(parts[2]);
                return buySecurity(security, amount);

            case "SELL":
                security = parts[1];
                amount = Integer.parseInt(parts[2]);
                return sellSecurity(security, amount);

            case "ADD":
                security = parts[1];
                return addSecurity(security);

            case "PORTFOLIO":
                return showPortfolio();

            default:
                return "Unknown command";
        }
    }

    private String buySecurity(String security, int amount) {
        if (!portfolio.containsKey(security)) {
            return "1 Unknown security";
        }
        portfolio.put(security, portfolio.get(security) + amount);
        return "0 Trade successful";
    }

    private String sellSecurity(String security, int amount) {
        if (!portfolio.containsKey(security)) {
            return "1 Unknown security";
        }
        if (portfolio.get(security) < amount) {
            return "2 Not enough positions";
        }
        portfolio.put(security, portfolio.get(security) - amount);
        return "0 Trade successful";
    }

    private String addSecurity(String security) {
        portfolio.putIfAbsent(security, 0);
        return "0 Success";
    }

    private String showPortfolio() {
        StringBuilder response = new StringBuilder("0 ");
        for (Map.Entry<String, Integer> entry : portfolio.entrySet()) {
            response.append(entry.getKey()).append(" ").append(entry.getValue()).append(" | ");
        }
        if (response.length() > 2) {
            response.setLength(response.length() - 3);
        }
        return response.toString();
    }
}