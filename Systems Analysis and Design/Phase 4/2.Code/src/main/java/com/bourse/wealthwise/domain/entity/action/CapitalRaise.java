package com.bourse.wealthwise.domain.entity.action;

import com.bourse.wealthwise.domain.entity.action.utils.ActionVisitor;
import com.bourse.wealthwise.domain.entity.balance.BalanceChange;
import com.bourse.wealthwise.domain.entity.portfolio.Portfolio;
import com.bourse.wealthwise.domain.entity.security.Security;
import com.bourse.wealthwise.domain.entity.security.SecurityChange;
import com.bourse.wealthwise.domain.entity.security.SecurityType;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@SuperBuilder
@Getter
@EqualsAndHashCode(callSuper = true)
public class CapitalRaise extends BaseAction {
    private final String originalSecurityId;
    private final String rightsSecurityId;
    private final Integer rightsQuantity;
    private final BigDecimal factor;

    @Override
    public List<BalanceChange> getBalanceChanges() {
        return Collections.emptyList();
    }

    @Override
    public List<SecurityChange> getSecurityChanges() {
        // For Defferd Mode
        // if (rightsSecurityId == null || rightsQuantity == null) {
        //     return Collections.emptyList();
        // }
        return List.of(SecurityChange.builder()
                .uuid(UUID.randomUUID())
                .datetime(getDatetime())
                .portfolio(getPortfolio())
                .security(Security.builder()
                        .isin(rightsSecurityId)
                        .symbol(rightsSecurityId)
                        .name("Rights for " + originalSecurityId)
                        .securityType(SecurityType.STOCK_RIGHT)
                        .build())
                .action(this)
                .isTradable(Boolean.FALSE)
                .volumeChange(BigInteger.valueOf(rightsQuantity.longValue()))
                .build());
    }

    @Override
    public String accept(ActionVisitor visitor) {
        return visitor.visit(this);
    }

    public static CapitalRaise create(Portfolio portfolio,
                                               String originalSecurityId,
                                               String rightsSecurityId,
                                               int rightsQuantity,
                                               BigDecimal factor) {
        return CapitalRaise.builder()
                .uuid(UUID.randomUUID().toString())
                .datetime(LocalDateTime.now())
                .portfolio(portfolio)
                .tracing_number(null)
                .actionType(ActionType.CAPITAL_RAISE)
                .actor(Actor.PUBLISHER)
                .originalSecurityId(originalSecurityId)
                .rightsSecurityId(rightsSecurityId)
                .rightsQuantity(rightsQuantity)
                .factor(factor)
                .build();
    }

    // This create mode which is the deferred mode is in the case of we not calculating the rightsQuantitiy and save 
    // the originalSecurityQuantity alongside the Factor so we can calculate it later following the event-based approach

    // public static CapitalRaise create(String originalSecurityId,
    //                                           BigDecimal factor) {
    //     return CapitalRaise.builder()
    //             .uuid(UUID.randomUUID().toString())
    //             .datetime(LocalDateTime.now())
    //             .portfolio(null)
    //             .tracing_number(null)
    //             .actionType(ActionType.CAPITAL_RAISE)
    //             .actor(Actor.SYSTEM)
    //             .originalSecurityId(originalSecurityId)
    //             .rightsSecurityId(null)
    //             .rightsQuantity(null)
    //             .factor(factor)
    //             .build();
    // }
}