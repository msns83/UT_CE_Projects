package com.bourse.wealthwise.domain.entity.security;

import lombok.Data;
import lombok.Getter;
import lombok.experimental.SuperBuilder;

import java.math.BigInteger;

@Getter
@SuperBuilder
@Data
public class SecurityProperty {

    private BigInteger volume ;
    private double value ;
    private Security security;

    public void changeVolume(BigInteger change) {
        this.volume = this.volume.add(change);
    }

    public void calculateValue(double price) {
        this.value = volume.doubleValue() * price;
    }
}
