package com.bourse.wealthwise.domain.actions;

import com.bourse.wealthwise.domain.entity.account.User;
import com.bourse.wealthwise.domain.entity.action.*;
import com.bourse.wealthwise.domain.entity.portfolio.Portfolio;
import com.bourse.wealthwise.domain.entity.security.Security;
import com.bourse.wealthwise.domain.entity.security.SecurityType;
import com.bourse.wealthwise.repository.ActionRepository;
import com.bourse.wealthwise.repository.PortfolioRepository;
import com.bourse.wealthwise.repository.SecurityRepository;
import org.awaitility.Awaitility;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jms.core.JmsTemplate;

import java.math.BigInteger;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class CapitalRaiseActionTest {

    @Autowired
    private SecurityRepository securityRepository;
    @Autowired
    private PortfolioRepository portfolioRepository;
    @Autowired
    private ActionRepository actionRepository;
    @Autowired
    private JmsTemplate jmsTemplate;

    @Value("${app.messaging.capitalRaiseQueue}")
    private String queue;

    private Security underlying;
    private Portfolio p1;
    private Portfolio p2;

    @BeforeEach
    void setup() {
        underlying = Security.builder()
                .isin("AAA111")
                .symbol("AAA")
                .name("Alpha Co")
                .securityType(SecurityType.STOCK)
                .build();
        securityRepository.addSecurity(underlying);

        p1 = new Portfolio("P1", User.builder().build(), "port1");
        portfolioRepository.save(p1);
        Buy buy1 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(p1)
                .datetime(LocalDateTime.now().minusMinutes(1))
                .security(underlying)
                .volume(BigInteger.valueOf(100))
                .price(10)
                .totalValue(BigInteger.valueOf(1000))
                .actionType(ActionType.BUY)
                .actor(Actor.MANUAL)
                .build();

        p2 = new Portfolio("P2", User.builder().build(), "port2");
        portfolioRepository.save(p2);
        Buy buy2 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(p2)
                .datetime(LocalDateTime.now().minusMinutes(1))
                .security(underlying)
                .volume(BigInteger.valueOf(35))
                .price(10)
                .totalValue(BigInteger.valueOf(350))
                .actionType(ActionType.BUY)
                .actor(Actor.MANUAL)
                .build();

        actionRepository.clear();
        actionRepository.save(buy1);
        actionRepository.save(buy2);
    }

    @Test
    void capitalRaiseMessage_createsRightsPerHolding() {
        //System.out.println("Send now: CAPITAL_RAISE AAA111 0.5");
        jmsTemplate.convertAndSend(queue, "CAPITAL_RAISE AAA111 0.5");
        Awaitility.await().atMost(Duration.ofSeconds(10)).pollInterval(Duration.ofMillis(250))
                .untilAsserted(() -> {
                    List<CapitalRaise> raises = allActions()
                            .filter(a -> a instanceof CapitalRaise)
                            .map(a -> (CapitalRaise) a)
                            .toList();
                    assertThat(raises).hasSize(2);

                    CapitalRaise p1Raise = raises.stream()
                            .filter(r -> r.getPortfolio().getUuid().equals(p1.getUuid()))
                            .findFirst().orElseThrow();
                    CapitalRaise p2Raise = raises.stream()
                            .filter(r -> r.getPortfolio().getUuid().equals(p2.getUuid()))
                            .findFirst().orElseThrow();

                    assertThat(p1Raise.getRightsQuantity()).isEqualTo(50);
                    assertThat(p2Raise.getRightsQuantity()).isEqualTo(17);
                });
    }

    @Test
    void capitalRaiseUnknownSecurity_noActionCreated() {
        //System.out.println("Send now: CAPITAL_RAISE UNKNOWN 0.5");
        jmsTemplate.convertAndSend(queue, "CAPITAL_RAISE UNKNOWN 0.5");
        Awaitility.await().atMost(Duration.ofSeconds(5)).pollInterval(Duration.ofMillis(250))
                .untilAsserted(() -> {
                    long count = allActions()
                            .filter(a -> a instanceof CapitalRaise)
                            .count();
                    assertThat(count).isZero();
                });
    }

    @Test
    void capitalRaiseZeroHoldings_noActions() {
        // Create security with no buys
        securityRepository.addSecurity(Security.builder()
                .isin("BBB222").symbol("BBB").name("Beta").build());
        jmsTemplate.convertAndSend(queue, "CAPITAL_RAISE BBB222 0.5");
        //System.out.println("Send now (after Beta added): CAPITAL_RAISE BBB222 0.5");
        Awaitility.await().atMost(Duration.ofSeconds(5)).pollInterval(Duration.ofMillis(250))
                .untilAsserted(() -> {
                    long count = allActions()
                            .filter(a -> a instanceof CapitalRaise
                                    && ((CapitalRaise) a).getOriginalSecurityId().equals("BBB222"))
                            .count();
                    assertThat(count).isZero();
                });
    }

    private Stream<BaseAction> allActions() {
        return Stream.concat(
                actionRepository.findAllActionsOf(p1.getUuid()).stream(),
                actionRepository.findAllActionsOf(p2.getUuid()).stream()
        );
    }
}