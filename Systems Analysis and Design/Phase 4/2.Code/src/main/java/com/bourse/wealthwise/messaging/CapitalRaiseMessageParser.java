package com.bourse.wealthwise.messaging;

import java.math.BigDecimal;

public class CapitalRaiseMessageParser {
    public CapitalRaiseMessage parse(String raw) {
        if (raw == null) throw new IllegalArgumentException("Null message");
        String[] t = raw.trim().split("\\s+");
        if (t.length != 3 || !"CAPITAL_RAISE".equalsIgnoreCase(t[0])) {
            throw new IllegalArgumentException("Invalid CAPITAL_RAISE format");
        }
        BigDecimal factor = new BigDecimal(t[2]);
        if (factor.signum() <= 0) {
            throw new IllegalArgumentException("Factor must be > 0");
        }
        return new CapitalRaiseMessage(t[1], factor);
    }
}