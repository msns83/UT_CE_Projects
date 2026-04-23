package com.example.demo.features.order.service;

import com.example.demo.features.user.model.User;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderCheckoutServiceFlowTest {

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
        u.setUname("User" + id);
        return u;
    }

    @Test
    @DisplayName("Captures exact charged amount using ArgumentCaptor")
    void captures_exact_charged_amount() {
        User u = user(1);
        when(orderServices.calculateTotalForUser(u)).thenReturn(145.75);
        when(paymentGateway.charge(u, 145.75)).thenReturn(true);

        CheckoutResult result = checkoutService.checkout(u);

        ArgumentCaptor<Double> amountCaptor = ArgumentCaptor.forClass(Double.class);
        verify(paymentGateway).charge(eq(u), amountCaptor.capture());
        Assertions.assertEquals(145.75, amountCaptor.getValue());
        Assertions.assertTrue(result.isSuccessful());
        Assertions.assertEquals(145.75, result.getChargedAmount());
    }

    @Test
    @DisplayName("Ensures order: charge then confirmation (success case)")
    void ensures_charge_before_confirmation() {
        User u = user(2);
        when(orderServices.calculateTotalForUser(u)).thenReturn(200.0);
        when(paymentGateway.charge(u, 200.0)).thenReturn(true);

        CheckoutResult result = checkoutService.checkout(u);

        InOrder inOrder = inOrder(paymentGateway, confirmationSender);
        inOrder.verify(paymentGateway).charge(u, 200.0);
        inOrder.verify(confirmationSender).sendConfirmation(u, 200.0);

        Assertions.assertTrue(result.isSuccessful());
    }

    @Test
    @DisplayName("First payment fails then succeeds (thenReturn sequence)")
    void first_fails_second_succeeds_sequence() {
        User u = user(3);
        when(orderServices.calculateTotalForUser(u)).thenReturn(99.99);
        when(paymentGateway.charge(u, 99.99)).thenReturn(false, true);

        CheckoutResult first = checkoutService.checkout(u);
        CheckoutResult second = checkoutService.checkout(u);

        verify(paymentGateway, times(2)).charge(u, 99.99);
        verify(confirmationSender, times(1)).sendConfirmation(u, 99.99);

        Assertions.assertFalse(first.isSuccessful());
        Assertions.assertTrue(second.isSuccessful());
    }

    @Test
    @DisplayName("Uses Answer to validate dynamic calculation and conditional acceptance")
    void dynamic_amount_validation_with_answer() {
        User u = user(4);

        when(orderServices.calculateTotalForUser(u))
                .thenAnswer(inv -> {
                    double base = 120.0;
                    double tax = base * 0.1;
                    return base + tax;
                });

        when(paymentGateway.charge(eq(u), anyDouble()))
                .thenAnswer(inv -> {
                    double amt = inv.getArgument(1);
                    return Math.abs(amt - 132.0) < 0.0001;
                });

        CheckoutResult result = checkoutService.checkout(u);

        ArgumentCaptor<Double> captor = ArgumentCaptor.forClass(Double.class);
        verify(paymentGateway).charge(eq(u), captor.capture());
        double sent = captor.getValue();


        verify(confirmationSender).sendConfirmation(u, 132.0);

        Assertions.assertEquals(132.0, sent);
        Assertions.assertTrue(result.isSuccessful());
        Assertions.assertEquals(132.0, result.getChargedAmount());
    }
}