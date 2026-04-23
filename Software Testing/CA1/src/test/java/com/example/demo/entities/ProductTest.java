package com.example.demo.entities;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import java.util.function.BiConsumer;
import java.util.stream.Stream;
import static org.junit.jupiter.api.Assertions.*;

public class ProductTest {

    @Test
    public void givenTwoProducts_WhenBothIdenticalInProperties_ThenMustHaveSameToString() {
        Product p1 = new Product();
        Product p2 = new Product();
        assertEquals(p1.toString(), p2.toString());
    }

    @ParameterizedTest
    @MethodSource("productPropertyProvider")
    void givenEmtpyProduct_WhenPropertyIsSet_ThenToStringMustContainValue(BiConsumer<Product, Object> setter, Object value) {
        Product product = new Product();
        assertFalse(product.toString().contains(String.valueOf(value)));
        setter.accept(product, value);
        assertTrue(product.toString().contains(String.valueOf(value)));
    }

    static Stream<Arguments> productPropertyProvider() {
        return Stream.of(
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<Product, Object>) (p, v) -> p.setPname((String) v), "productName"),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<Product, Object>) (p, v) -> p.setPdescription((String) v), "productDescription"),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<Product, Object>) (p, v) -> p.setPprice((double) v), 123.456)
        );
    }

}
