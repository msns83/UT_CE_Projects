package com.bourse.wealthwise.domain.actions;

import com.bourse.wealthwise.domain.entity.account.User;
import com.bourse.wealthwise.domain.entity.action.Buy;
import com.bourse.wealthwise.domain.entity.action.Deposit;
import com.bourse.wealthwise.domain.entity.action.Sale;
import com.bourse.wealthwise.domain.entity.action.StockRightUsage;
import com.bourse.wealthwise.domain.entity.portfolio.Portfolio;
import com.bourse.wealthwise.domain.entity.security.Security;
import com.bourse.wealthwise.domain.entity.security.SecurityType;
import com.bourse.wealthwise.domain.services.BalanceActionService;
import com.bourse.wealthwise.repository.ActionRepository;
import com.bourse.wealthwise.repository.PortfolioRepository;
import com.bourse.wealthwise.repository.SecurityRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class StockRightActionsTest {

    @Autowired
    private ActionRepository actionRepository;
    @Autowired
    private PortfolioRepository portfolioRepository;
    @Autowired
    private SecurityRepository securityRepository;
    @Autowired
    private BalanceActionService balanceActionService;

    private Portfolio portfolio;
    private Security mainStock;
    private Security stockRight;
    private User user;

    @BeforeEach
    void setUp() {
        // 1. Create User and Portfolio
        user = User.builder().uuid(UUID.randomUUID().toString()).build();
        portfolio = new Portfolio(UUID.randomUUID().toString(), user, "StockRightTestPortfolio");
        portfolioRepository.save(portfolio);

        // 2. Create Securities
        mainStock = Security.builder().symbol("FOOLAD").isin("ISIN001").securityType(SecurityType.STOCK).build();
        stockRight = Security.builder().symbol("HFOOLAD").isin("ISIN002").securityType(SecurityType.STOCK_RIGHT).build();
        securityRepository.addSecurity(mainStock);
        securityRepository.addSecurity(stockRight);

        // 3. Give the portfolio some cash to work with
        Deposit initialDeposit = Deposit.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolio)
                .datetime(LocalDateTime.now().minusDays(1))
                .amount(BigInteger.valueOf(100000)) // 100,000 Toman
                .build();
        actionRepository.save(initialDeposit);
    }

    /*
        Task 6: Tests for buying and selling stock rights
    */
    @Test
    void portfolioCanBuyAndSellStockRights() {

        // Buy "150 * 50 = 7,500" Tomans worth of HFOOLAD
        Buy buyStockRights = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolio)
                .datetime(LocalDateTime.now().minusHours(2))
                .security(stockRight)
                .volume(BigInteger.valueOf(50))
                .price(150)
                .totalValue(BigInteger.valueOf(7500))
                .build();
        actionRepository.save(buyStockRights);

        // Expect balance to equal to "100,000 - 7,500 = 92,500"
        BigInteger balanceAfterBuy = balanceActionService.getBalanceForPortfolio(portfolio.getUuid(), LocalDateTime.now());
        assertEquals(0, BigInteger.valueOf(92500).compareTo(balanceAfterBuy));

        // Sell "170 * 27 = 4590" Tomans worth of HFOOLAD
        Sale saleStockRights = Sale.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolio)
                .datetime(LocalDateTime.now().minusHours(1))
                .security(stockRight)
                .volume(BigInteger.valueOf(27))
                .price(170)
                .totalValue(BigInteger.valueOf(4590))
                .build();
        actionRepository.save(saleStockRights);

        // Expect balance to equal to "92,500 + 4,590 = 97,090"
        BigInteger balanceAfterSale = balanceActionService.getBalanceForPortfolio(portfolio.getUuid(), LocalDateTime.now());
        assertEquals(0, BigInteger.valueOf(97090).compareTo(balanceAfterSale));
    }

    /*
        Task 8: Test for action of using stock rights
    */
    @Test
    void stockRightUsageAction_ConvertsRightsToUntradableSharesAndDeductsCost() {
        // Add 100 unit of rights worth of "100 * 10 = 1,000" Tomans to portfolio
        Buy initialRights = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolio)
                .datetime(LocalDateTime.now().minusDays(1))
                .security(stockRight)
                .volume(BigInteger.valueOf(100))
                .price(10)
                .totalValue(BigInteger.valueOf(1000))
                .build();
        actionRepository.save(initialRights);

        // Expect current balance to equal to "100,00 - 1,000 = 99,000"
        BigInteger balanceBeforeUsage = balanceActionService.getBalanceForPortfolio(portfolio.getUuid(), LocalDateTime.now());
        assertEquals(0, balanceBeforeUsage.compareTo(BigInteger.valueOf(99000)));

        StockRightUsage useRights = StockRightUsage.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolio)
                .datetime(LocalDateTime.now().minusHours(7))
                .stockRight(stockRight)
                .mainStock(mainStock)
                .volume(BigInteger.valueOf(70))
                .build();
        actionRepository.save(useRights);

        /*
            selling 70 rights, knowing each one costs 100 Tomans, it'll have an overall cost of "70 * 100 = 1,000"
            Expect current balance to equal to "99,000 - 7,000 = 92,000"
        */
        BigInteger expectedBalance = balanceBeforeUsage.subtract(BigInteger.valueOf(7000));
        BigInteger actualBalance = balanceActionService.getBalanceForPortfolio(portfolio.getUuid(), LocalDateTime.now());
        assertEquals(0, expectedBalance.compareTo(actualBalance));

        // Expect action of selling rights to generate two changes in security
        assertEquals(2, useRights.getSecurityChanges().size());
    }
}
