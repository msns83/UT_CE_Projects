package com.bourse.wealthwise.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jms.annotation.EnableJms;
import com.bourse.wealthwise.messaging.CapitalRaiseMessageParser;

@Configuration
@EnableJms
public class JmsConfig {
    @Bean
    public CapitalRaiseMessageParser capitalRaiseMessageParser() {
        return new CapitalRaiseMessageParser();
    }
}

// basically a class that is always listening on for messages on the configured queue and upon consumption makes a parser object for later use