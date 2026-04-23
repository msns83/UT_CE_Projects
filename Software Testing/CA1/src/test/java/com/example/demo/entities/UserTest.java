package com.example.demo.entities;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.MethodSource;
import java.util.List;
import java.util.function.BiConsumer;
import java.util.stream.Stream;

public class UserTest {

    @Test
    public void givenTwoUsers_WhenBothIdenticalInProperties_ThenMustHaveSameToString() {
        User user1 = new User();
        User user2 = new User();
        assertEquals(user1.toString(), user2.toString());
    }


    @ParameterizedTest
    @CsvSource({
            "daryl.dixon@gmail.com, crossbow",
            "rick.grimes@gmail.com, revolver",
            "negan.smith@gmail.com, lucille",
    })
    public void createUser_MustHaveEmailAndPassword_IfUserIsRegistered(String email, String password) {
        User user = new User(email, password);
        assertEquals(email, user.getUemail());
        assertEquals(password, user.getUpassword());
    }


    @Test
    void givenEmptyUser_WhenOrdersAreAdded_ThenSizeMustIncrease() {
        User user = new User();
        Orders o1 = new Orders();
        Orders o2 = new Orders();

        user.setOrders(List.of(o1, o2));

        assertEquals(2, user.getOrders().size());
        assertTrue(user.getOrders().contains(o1));
        assertTrue(user.getOrders().contains(o2));
    }

    @ParameterizedTest
    @MethodSource("userPropertyProvider")
    void givenEmtpyUser_WhenPropertyIsSet_ThenToStringMustContainValue(BiConsumer<User, Object> setter, Object value) {
        User user = new User();
        assertFalse(user.toString().contains(String.valueOf(value)));
        setter.accept(user, value);
        assertTrue(user.toString().contains(String.valueOf(value)));
    }

    static Stream<Arguments> userPropertyProvider() {
        return Stream.of(
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<User, Object>) (u, v) -> u.setUname((String) v), "Daryl Dixon"),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<User, Object>) (u, v) -> u.setUemail((String) v), "daryl.dixon@gmail.com"),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<User, Object>) (u, v) -> u.setUpassword((String) v), "crossbow"),
                org.junit.jupiter.params.provider.Arguments.of((BiConsumer<User, Object>) (u, v) -> u.setUnumber((Long) v), 9876543210L)
        );
    }

}
