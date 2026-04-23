package com.example.demo.entities;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import java.util.function.BiConsumer;
import java.util.stream.Stream;
import static org.junit.jupiter.api.Assertions.*;

public class OrdersTest {

    @Test
    void givenTwoOrders_WhenBothIdenticalInProperties_ThenMustHaveSameToString() {
        Orders o1 = new Orders();
        Orders o2 = new Orders();
        assertEquals(o1.toString(), o2.toString());
    }

    @ParameterizedTest
    @MethodSource("ordersPropertyProvider")
    void givenEmptyOrder_WhenPropertyIsSet_ThenToStringMustContainValue(BiConsumer<Orders, Object> setter, Object value) {
        Orders orders = new Orders();
        assertFalse(orders.toString().contains(String.valueOf(value)));
        setter.accept(orders, value);
        assertTrue(orders.toString().contains(String.valueOf(value)));
    }

    static Stream<Arguments> ordersPropertyProvider() {
        return Stream.of(
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<Orders, Object>) (o, v) -> o.setoName((String) v), "orderName"),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<Orders, Object>) (o, v) -> o.setoPrice((double) v), 123.456),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<Orders, Object>) (o, v) -> o.setoQuantity((int) v), 123)
        );
    }
}
