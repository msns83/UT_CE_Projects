package com.bourse.wealthwise.domain.services;

import com.bourse.wealthwise.domain.entity.action.BaseAction;
import com.bourse.wealthwise.domain.entity.security.SecurityChange;
import com.bourse.wealthwise.domain.entity.security.SecurityProperty;
import com.bourse.wealthwise.repository.ActionRepository;
import com.bourse.wealthwise.repository.PortfolioRepository;
import com.bourse.wealthwise.repository.SecurityPriceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PortfolioSecurityService {

    private final PortfolioRepository portfolioRepository;
    private final ActionRepository actionRepository;
    private final SecurityPriceRepository priceRepository;

    HashMap<String, SecurityProperty> properties = new HashMap<>();

    public List<SecurityProperty> getSecuritiesForPortfolio(String portfolioId, LocalDateTime localDateTime) {
        properties.clear();

        List<BaseAction> actions = actionRepository.findAllActionsOf(
                portfolioRepository.findById(portfolioId).orElseThrow(() -> new IllegalArgumentException("Portfolio not found")).getUuid())
                .stream()
                .filter(action -> action.getDatetime() != null && action.getDatetime().isBefore(localDateTime))
                .toList();

        for (BaseAction action : actions){
            this.checkActionForProperty(action);
        }

        List<SecurityProperty> propertiesList = new ArrayList<>(this.properties.values()) ;

        for (SecurityProperty property : propertiesList){
            double price = priceRepository.getLatestPriceBefore(property.getSecurity().getIsin(), localDateTime)
                    .orElseThrow(() -> new IllegalStateException("Value not present"));
            property.calculateValue(price);
        }

        propertiesList.sort(Comparator.comparing(sp -> sp.getSecurity().getName()));

        return  propertiesList;
    }

    private void checkActionForProperty(BaseAction action){
        List<SecurityChange> securityChanges = action.getSecurityChanges() ;

        if(!securityChanges.isEmpty()){
            SecurityChange securityChange = securityChanges.getFirst() ;
            SecurityProperty foundedProperty = this.properties.get(securityChange.getSecurity().getIsin());

            if (foundedProperty == null){
                foundedProperty = SecurityProperty.builder()
                        .security(securityChange.getSecurity())
                        .volume(BigInteger.ZERO)
                        .build();
                this.properties.put(securityChange.getSecurity().getIsin(), foundedProperty);
            }

            foundedProperty.changeVolume(securityChange.getVolumeChange());
        }
    }
}