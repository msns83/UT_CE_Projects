package com.bourse.wealthwise.messaging;

import com.bourse.wealthwise.domain.entity.action.CapitalRaise;
import com.bourse.wealthwise.domain.entity.portfolio.Portfolio;
import com.bourse.wealthwise.domain.entity.security.Security;
import com.bourse.wealthwise.domain.entity.security.SecurityType;
import com.bourse.wealthwise.domain.entity.security.SecurityChange;
import com.bourse.wealthwise.repository.ActionRepository;
import com.bourse.wealthwise.repository.PortfolioRepository;
import com.bourse.wealthwise.repository.SecurityRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.util.List;

@Component
@RequiredArgsConstructor
public class CapitalRaiseListener {
    private static final Logger log = LoggerFactory.getLogger(CapitalRaiseListener.class);
    private final CapitalRaiseMessageParser parser;
    private final PortfolioRepository portfolioRepository;
    private final SecurityRepository securityRepository;
    private final ActionRepository actionRepository;

    @Value("${app.capitalRaise.strategy:immediate}")
    private String strategy;

    @JmsListener(destination = "${app.messaging.capitalRaiseQueue}")
    public void onMessage(String text) {
        try {
            CapitalRaiseMessage msg = parser.parse(text);
//            if ("deferred".equalsIgnoreCase(strategy)) {
//                handleDeferred(msg);
//            } else {
            handleImmediate(msg);
            //}
        } catch (Exception e) {
            log.error("Capital raise processing failed for '{}': {}", text, e.getMessage(), e);
        }
    }

    private void handleImmediate(CapitalRaiseMessage msg) {
        String originalIsin = msg.securityId();
        Security original = securityRepository.findSecurityByIsin(originalIsin);
        if (original == null) {
            log.warn("Unknown security {}, skipping", originalIsin);
            return;
        }
        BigDecimal factor = msg.factor();
        log.info("Processing capital raise original={} factor={}", originalIsin, factor);

        List<Portfolio> portfolios = portfolioRepository.findAll();

        String rightsIsin = null;
        int created = 0;

        for (Portfolio p : portfolios) {
            int currentQty = getCurrentQuantity(p, originalIsin);
            if (currentQty <= 0) {
                log.debug("Portfolio={} holds 0 of {}, skipping", p.getUuid(), originalIsin);
                continue;
            }

            int rightsQty = factor
                    .multiply(BigDecimal.valueOf(currentQty))
                    .setScale(0, RoundingMode.DOWN)
                    .intValue();
            
            log.info("Portfolio={} currentQty={} computedRights={}", p.getUuid(), currentQty, rightsQty);
            
            if (rightsQty <= 0) continue;
            
            if (rightsIsin == null) {
                rightsIsin = "H" + originalIsin;
                ensureRightsSecurity(rightsIsin, originalIsin);
            }

            CapitalRaise action = CapitalRaise.create(p, originalIsin, rightsIsin, rightsQty, factor);

            actionRepository.save(action);
            created++;
                
            log.info("Created CapitalRaise action portfolio={} rightsQty={} original={} rightsIsin={} actionId={}",
                    p.getUuid(), rightsQty, originalIsin, rightsIsin, action.getUuid());
        }
        if (created == 0) {
            log.info("No portfolios eligible for rights original={}, nothing created.", originalIsin);
        } else {
            log.info("Capital raise processed original={} actionsCreated={}", originalIsin, created);
        }
    }

//    private void handleDeferred(CapitalRaiseMessage msg) {
//        String original = msg.securityId();
//        if (securityRepository.findSecurityByIsin(original) == null) {
//            log.warn("Unknown security {}, skipping deferred", original);
//            return;
//        }
//
//        log.warn("Deferred mode selected but deferred factory currently commented out.");
//    }

    private void ensureRightsSecurity(String rightsId, String original) {
        if (securityRepository.findSecurityByIsin(rightsId) != null) return;
        Security rights = Security.builder()
                .isin(rightsId)
                .symbol(rightsId)
                .name("Rights for " + original)
                .securityType(SecurityType.STOCK_RIGHT)
                .build();
        securityRepository.addSecurity(rights);
        log.info("Created rights security {}", rightsId);
    }

    private int getCurrentQuantity(Portfolio portfolio, String securityIsin) {
        return actionRepository.findAllActionsOf(portfolio.getUuid()).stream()
                .flatMap(a -> a.getSecurityChanges().stream())
                .filter(sc -> sc.getSecurity() != null &&
                        securityIsin.equals(sc.getSecurity().getIsin()))
                .map(SecurityChange::getVolumeChange)
                .reduce(BigInteger.ZERO, BigInteger::add)
                .intValue();
    }
}