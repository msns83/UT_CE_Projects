package com.bourse.wealthwise.domain.services;

import com.bourse.wealthwise.domain.entity.account.User;
import com.bourse.wealthwise.domain.entity.action.ActionType;
import com.bourse.wealthwise.domain.entity.action.Buy;
import com.bourse.wealthwise.domain.entity.action.Sale;
import com.bourse.wealthwise.domain.entity.action.Withdrawal;
import com.bourse.wealthwise.domain.entity.portfolio.Portfolio;
import com.bourse.wealthwise.domain.entity.security.Security;
import com.bourse.wealthwise.domain.entity.security.SecurityProperty;
import com.bourse.wealthwise.repository.ActionRepository;
import com.bourse.wealthwise.repository.PortfolioRepository;
import com.bourse.wealthwise.repository.SecurityPriceRepository;
import com.bourse.wealthwise.repository.SecurityRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class PortfolioSecurityServiceTest {

    @Autowired
    private PortfolioRepository portfolioRepository;
    @Autowired
    private PortfolioSecurityService portfolioSecurityService;
    @Autowired
    private ActionRepository actionRepository;
    @Autowired
    private SecurityPriceRepository securityPriceRepository;
    @Autowired
    private SecurityRepository securityRepository;

    @BeforeEach
    public void setUp() {
        User user = User.builder().build();
        Portfolio portoA = new Portfolio("21e4", user, "first_portfo");
        Portfolio protoB = new Portfolio("22e4", user, "second_portfo");

        securityRepository.addSecurity(Security.builder().isin("11").name("foolad").symbol("FOO").build());
        securityRepository.addSecurity(Security.builder().isin("22").name("mess").symbol("MSS").build());
        securityRepository.addSecurity(Security.builder().isin("33").name("apple").symbol("APPL").build());

        securityPriceRepository.addPrice("11", LocalDateTime.now(), 2);
        securityPriceRepository.addPrice("22", LocalDateTime.now(), 3);
        securityPriceRepository.addPrice("33", LocalDateTime.now(), 4);

        portfolioRepository.save(portoA);
        portfolioRepository.save(protoB);
    }

    @Test
    public void noSecurityForPortfolio_getProperty_EmptyListReturned(){
        assertEquals(
                portfolioSecurityService.getSecuritiesForPortfolio("21e4", LocalDateTime.now())
                ,
                List.of());
    }

    @Test
    public void BuysEnters_getNewProperty_ChangedPropertiesReturned(){

        Buy buy1 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(100))
                .price(3)
                .totalValue(BigInteger.valueOf(300))
                .security(securityRepository.findSecurityByIsin("11"))
                .actionType(ActionType.BUY)
                .build();

        Buy buy2 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(25))
                .price(4)
                .totalValue(BigInteger.valueOf(100))
                .security(securityRepository.findSecurityByIsin("22"))
                .actionType(ActionType.BUY)
                .build();

        Buy buy3 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(60))
                .price(4)
                .totalValue(BigInteger.valueOf(200))
                .security(securityRepository.findSecurityByIsin("33"))
                .actionType(ActionType.BUY)
                .build();

        actionRepository.save(buy1);
        actionRepository.save(buy2);
        actionRepository.save(buy3);

        List<SecurityProperty> answer = new ArrayList<>() ;
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("33")).volume(BigInteger.valueOf(60)).value(240).build());
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("11")).volume(BigInteger.valueOf(100)).value(200).build());
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("22")).volume(BigInteger.valueOf(25)).value(75).build());


        assertEquals(
                answer
                ,
                portfolioSecurityService.getSecuritiesForPortfolio("21e4", LocalDateTime.now())
        );

        actionRepository.clear();
    }


    @Test
    public void BuysSalesEnters_getNewProperty_ChangedPropertiesReturned(){

        Buy buy1 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(100))
                .price(3)
                .totalValue(BigInteger.valueOf(300))
                .security(securityRepository.findSecurityByIsin("11"))
                .actionType(ActionType.BUY)
                .build();

        Buy buy2 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(25))
                .price(4)
                .totalValue(BigInteger.valueOf(100))
                .security(securityRepository.findSecurityByIsin("22"))
                .actionType(ActionType.BUY)
                .build();

        Buy buy3 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(60))
                .price(4)
                .totalValue(BigInteger.valueOf(240))
                .security(securityRepository.findSecurityByIsin("33"))
                .actionType(ActionType.BUY)
                .build();

        Sale sale1 = Sale.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(11))
                .price(3)
                .totalValue(BigInteger.valueOf(33))
                .security(securityRepository.findSecurityByIsin("22"))
                .actionType(ActionType.SALE)
                .build();

        actionRepository.save(buy1);
        actionRepository.save(buy2);
        actionRepository.save(buy3);
        actionRepository.save(sale1);

        List<SecurityProperty> answer = new ArrayList<>() ;
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("33")).volume(BigInteger.valueOf(60)).value(240).build());
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("11")).volume(BigInteger.valueOf(100)).value(200).build());
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("22")).volume(BigInteger.valueOf(14)).value(42).build());


        assertEquals(
                answer
                ,
                portfolioSecurityService.getSecuritiesForPortfolio("21e4", LocalDateTime.now())
        );

        actionRepository.clear();
    }

    @Test
    public void SeveralActionsEnters_getNewProperty_CorrectPropertiesReturned(){

        Buy buy1 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(100))
                .price(3)
                .totalValue(BigInteger.valueOf(300))
                .security(securityRepository.findSecurityByIsin("11"))
                .actionType(ActionType.BUY)
                .build();

        Buy buy2 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(25))
                .price(4)
                .totalValue(BigInteger.valueOf(100))
                .security(securityRepository.findSecurityByIsin("22"))
                .actionType(ActionType.BUY)
                .build();

        Withdrawal withdrawal = Withdrawal.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .amount(BigInteger.valueOf(1000))
                .actionType(ActionType.WITHDRAWAL)
                .build();
        actionRepository.save(withdrawal);

        Buy buy3 = Buy.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(60))
                .price(4)
                .totalValue(BigInteger.valueOf(240))
                .security(securityRepository.findSecurityByIsin("33"))
                .actionType(ActionType.BUY)
                .build();

        Sale sale1 = Sale.builder()
                .uuid(UUID.randomUUID().toString())
                .portfolio(portfolioRepository.findById("21e4").orElseThrow(() -> new IllegalStateException("Value not present")))
                .datetime(LocalDateTime.now())
                .volume(BigInteger.valueOf(11))
                .price(3)
                .totalValue(BigInteger.valueOf(33))
                .security(securityRepository.findSecurityByIsin("22"))
                .actionType(ActionType.SALE)
                .build();

        actionRepository.save(buy1);
        actionRepository.save(buy2);
        actionRepository.save(buy3);
        actionRepository.save(sale1);
        actionRepository.save(withdrawal);

        List<SecurityProperty> answer = new ArrayList<>() ;
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("33")).volume(BigInteger.valueOf(60)).value(240).build());
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("11")).volume(BigInteger.valueOf(100)).value(200).build());
        answer.add(SecurityProperty.builder().security(securityRepository.findSecurityByIsin("22")).volume(BigInteger.valueOf(14)).value(42).build());


        assertEquals(
                answer
                ,
                portfolioSecurityService.getSecuritiesForPortfolio("21e4", LocalDateTime.now())
        );

        actionRepository.clear();
    }

}


