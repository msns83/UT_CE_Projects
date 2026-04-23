package com.bourse.wealthwise.messaging;

import java.math.BigDecimal;

public record CapitalRaiseMessage(String securityId, BigDecimal factor) {}


// This class is used to make a DTO, a Data Transfer Object which is used for safer and more structured passing of the data,
// a raw message is consumed from artemis, then in parser we transform it into this DTO which is then given to the listener
// where in listener we process the capital raise message and make a capital raise action.