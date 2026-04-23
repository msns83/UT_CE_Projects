package com.example.demo.features.order.service;

import com.example.demo.features.user.model.User;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderCheckoutServiceInteractionTest {

    @Mock OrderServices orderServices;
    @Mock PaymentGateway paymentGateway;
    @Mock ConfirmationSender confirmationSender;

    OrderCheckoutService checkoutService;

    @BeforeEach
    void setup() {
        checkoutService = new OrderCheckoutService(orderServices, paymentGateway, confirmationSender);
    }

    private User user(int id) {
        User u = new User();
        u.setU_id(id);
        u.setUname("TestUser");
        return u;
    }

    @Test
    @DisplayName("Null user -> no interactions with services")
    void null_user_no_interactions() {
        CheckoutResult result = checkoutService.checkout(null);

        Assertions.assertFalse(result.isSuccessful());
        Assertions.assertEquals("User details are required", result.getMessage());
        Assertions.assertEquals(0.0, result.getChargedAmount());

        verifyNoInteractions(orderServices);
        verifyNoInteractions(paymentGateway);
        verifyNoInteractions(confirmationSender);
    }

    @Test
    @DisplayName("Zero cart total -> no payment or confirmation")
    void zero_cart_total_skips_payment_and_confirmation() {
        User u = user(1);
        when(orderServices.calculateTotalForUser(u)).thenReturn(0.0);

        CheckoutResult result = checkoutService.checkout(u);

        Assertions.assertFalse(result.isSuccessful());
        Assertions.assertEquals("Cart total must be greater than zero", result.getMessage());
        Assertions.assertEquals(0.0, result.getChargedAmount());

        verify(orderServices, times(1)).calculateTotalForUser(u);
        verifyNoInteractions(paymentGateway);
        verifyNoInteractions(confirmationSender);
    }

    @Test
    @DisplayName("Payment declined -> confirmation not sent")
    void payment_declined_skips_confirmation() {
        User u = user(2);
        when(orderServices.calculateTotalForUser(u)).thenReturn(150.0);
        when(paymentGateway.charge(u, 150.0)).thenReturn(false);

        CheckoutResult result = checkoutService.checkout(u);

        Assertions.assertFalse(result.isSuccessful());
        Assertions.assertEquals("Payment declined", result.getMessage());
        Assertions.assertEquals(0.0, result.getChargedAmount());

        verify(orderServices).calculateTotalForUser(u);
        verify(paymentGateway).charge(u, 150.0);
        verifyNoInteractions(confirmationSender);
    }
}