package com.bourse.wealthwise.repository;

import com.bourse.wealthwise.domain.entity.security.SecurityPrice;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Component
public class SecurityPriceRepository {

    private final Map<String, Map<LocalDateTime, Double>> priceMap = new HashMap<>();

    public void addPrice(String isin, LocalDateTime date, double price) {
        priceMap
                .computeIfAbsent(isin, k -> new HashMap<>())
                .put(date, price);
    }

    public Optional<Double> getPrice(String isin, LocalDateTime date) {
        return Optional.ofNullable(
                priceMap.getOrDefault(isin, Collections.emptyMap()).get(date)
        );
    }

    public Optional<Double> getLatestPriceBefore(String isin, LocalDateTime date) {
        Map<LocalDateTime, Double> datePriceMap = priceMap.get(isin);
        if (datePriceMap == null || datePriceMap.isEmpty()) {
            return Optional.empty();
        }

        return datePriceMap.entrySet().stream()
                .filter(entry -> entry.getKey().isBefore(date))
                .max(Map.Entry.comparingByKey())
                .map(Map.Entry::getValue);
    }


    public List<SecurityPrice> getPricesForSecurity(String isin) {
        Map<LocalDateTime, Double> datePriceMap = priceMap.getOrDefault(isin, Collections.emptyMap());
        List<SecurityPrice> prices = new ArrayList<>();
        datePriceMap.forEach((date, price) -> prices.add(new SecurityPrice(isin, date, price)));
        return prices;
    }

    public void clear() {
        priceMap.clear();
    }
}
