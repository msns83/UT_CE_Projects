package com.bourse.wealthwise.domain.entity.action.utils;

import com.bourse.wealthwise.domain.entity.action.Buy;
import com.bourse.wealthwise.domain.entity.action.Sale;
import com.bourse.wealthwise.domain.entity.action.Withdrawal;
import com.bourse.wealthwise.domain.entity.action.Deposit;
import com.bourse.wealthwise.domain.entity.action.*;
import java.time.format.DateTimeFormatter;

public class ActionDescriptionVisitor implements ActionVisitor {

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    
    @Override
    public String visit(Buy buy) {
        return String.format("[%s] Bought %s of %s @ %d/unit (Total: %s)",
                buy.getDatetime().format(formatter),
                buy.getVolume(),
                buy.getSecurity().getSymbol(),
                buy.getPrice(),
                buy.getTotalValue());
    }

    @Override
    public String visit(Sale sale) {
        return String.format("[%s] Sold %s of %s @ %d/unit (Total: %s)",
                sale.getDatetime().format(formatter),
                sale.getVolume(),
                sale.getSecurity().getSymbol(),
                sale.getPrice(),
                sale.getTotalValue());
    }

    @Override
    public String visit(Deposit deposit) {
        return String.format("[%s] Deposited amount: %s",
                deposit.getDatetime().format(formatter),
                deposit.getAmount());
    }

    @Override
    public String visit(Withdrawal withdrawal) {
        return String.format("[%s] Withdrew amount: %s",
                withdrawal.getDatetime().format(formatter),
                withdrawal.getAmount());
    }


    @Override
    public String visit(StockRightUsage stockRightUsage) {
        return String.format("[%s] Used %s of %s to convert to main stock",
                stockRightUsage.getDatetime().format(formatter),
                stockRightUsage.getVolume(),
                stockRightUsage.getStockRight().getSymbol());
    }

    @Override
    public String visit(CapitalRaise capitalRaise) {
        // The condition and the second return are for the deferred mode

        //if (capitalRaise.getRightsQuantity() != null) {
        return String.format("[%s] Capital raise %s -> rights %s qty %d (factor %s)",
                capitalRaise.getDatetime().format(formatter),
                capitalRaise.getOriginalSecurityId(),
                capitalRaise.getRightsSecurityId(),
                capitalRaise.getRightsQuantity(),
                capitalRaise.getFactor());
        //}
        // return String.format("[%s] Capital raise (deferred) %s factor %s",
        //         capitalRaise.getDatetime().format(formatter),
        //         capitalRaise.getOriginalSecurityId(),
        //         capitalRaise.getFactor());
    }

}