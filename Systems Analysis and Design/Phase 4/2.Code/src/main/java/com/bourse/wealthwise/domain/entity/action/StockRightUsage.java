package com.bourse.wealthwise.domain.entity.action;
import com.bourse.wealthwise.domain.entity.action.utils.ActionVisitor;
import com.bourse.wealthwise.domain.entity.balance.BalanceChange;
import com.bourse.wealthwise.domain.entity.security.Security;
import com.bourse.wealthwise.domain.entity.security.SecurityChange;
import lombok.Getter;
import java.math.BigInteger;
import java.util.List;
import lombok.experimental.SuperBuilder;
import java.util.UUID;

@SuperBuilder
@Getter
public class StockRightUsage extends BaseAction {
    private Security stockRight; // HFoolad
    private Security mainStock; // Foolad
    private BigInteger volume;
    private static final BigInteger COST_PER_RIGHT = BigInteger.valueOf(100);

    @Override
    public List<BalanceChange> getBalanceChanges() {
        // Subtract amount of right that's planned to be transformd to stock
        BigInteger totalCost = volume.multiply(COST_PER_RIGHT);
        return List.of(
                BalanceChange.builder()
                        .uuid(UUID.randomUUID())
                        .portfolio(this.portfolio)
                        .datetime(this.datetime)
                        .change_amount(totalCost.negate())
                        .action(this)
                        .build()
        );
    }

    @Override
    public List<SecurityChange> getSecurityChanges() {
        return List.of(
                // 1. amount of right that's planned to be transformd to stock
                SecurityChange.builder()
                        .uuid(UUID.randomUUID())
                        .portfolio(this.portfolio)
                        .datetime(this.datetime)
                        .security(this.stockRight)
                        .volumeChange(this.volume.negate())
                        .isTradable(true)
                        .action(this)
                        .build(),
                // 2. Add amount of stocks obtained by the rights
                SecurityChange.builder()
                        .uuid(UUID.randomUUID())
                        .portfolio(this.portfolio)
                        .datetime(this.datetime)
                        .security(this.mainStock)
                        .volumeChange(this.volume)
                        .isTradable(false)
                        .action(this)
                        .build()
        );
    }


    @Override public String accept(ActionVisitor visitor) { return visitor.visit(this); }
    private void setActionType(){
        this.actionType = ActionType.STOCK_RIGHT_USAGE;
    }
}
