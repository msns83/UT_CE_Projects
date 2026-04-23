package com.example.demo.features.order.service;

import com.example.demo.features.order.model.Orders;
import com.example.demo.features.order.repository.OrderRepository;
import com.example.demo.features.user.model.User;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderServicesRepositoryTest {

    @Mock OrderRepository orderRepository;
    @InjectMocks OrderServices orderServices;

    private Orders order(int id, double price, int quantity, double total, User user) {
        Orders o = new Orders();
        o.setoId(id);
        o.setoPrice(price);
        o.setoQuantity(quantity);
        o.setTotalAmmout(total);
        o.setUser(user);
        return o;
    }

    private User user(int id, String name) {
        User u = new User();
        u.setU_id(id);
        u.setUname(name);
        return u;
    }

    @Test
    @DisplayName("getOrders delegates to repository.findAll")
    void getOrders_calls_findAll() {
        Orders o1 = order(1, 10.0, 1, 10.0, null);
        Orders o2 = order(2, 5.0, 2, 10.0, null);
        when(orderRepository.findAll()).thenReturn(List.of(o1, o2));

        List<Orders> out = orderServices.getOrders();

        verify(orderRepository).findAll();
        Assertions.assertEquals(2, out.size());
        Assertions.assertSame(o1, out.get(0));
    }

    @Test
    @DisplayName("saveOrder delegates to repository.save")
    void saveOrder_calls_save() {
        Orders o = order(0, 12.5, 1, 12.5, null);
        orderServices.saveOrder(o);
        verify(orderRepository).save(o);
    }

    @Test
    @DisplayName("updateOrder sets id then saves")
    void updateOrder_sets_id_and_saves() {
        Orders patch = order(0, 20.0, 2, 40.0, null);

        orderServices.updateOrder(42, patch);

        Assertions.assertEquals(42, patch.getoId());
        verify(orderRepository).save(patch);
    }

    @Test
    @DisplayName("deleteOrder delegates to repository.deleteById")
    void deleteOrder_calls_deleteById() {
        orderServices.deleteOrder(9);
        verify(orderRepository).deleteById(9);
    }

    @Test
    @DisplayName("getOrdersForUser delegates to repository.findOrdersByUser")
    void getOrdersForUser_calls_repository() {
        User u = user(3, "Alice");
        Orders o = order(11, 15.0, 1, 15.0, u);
        when(orderRepository.findOrdersByUser(u)).thenReturn(List.of(o));

        List<Orders> out = orderServices.getOrdersForUser(u);

        verify(orderRepository).findOrdersByUser(u);
        Assertions.assertEquals(1, out.size());
        Assertions.assertSame(o, out.get(0));
    }

}