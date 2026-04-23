package com.example.demo.features.order.service;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.features.order.model.Orders;
import com.example.demo.features.order.util.Logic;
import com.example.demo.features.user.model.User;

@Service
public class OrderLogicService {

    @Autowired
    private OrderServices orderServices;

    public double processNewOrder(Orders order, User user) {
        double totalAmount = Logic.countTotal(order.getoPrice(), order.getoQuantity());

        order.setTotalAmmout(totalAmount);
        order.setUser(user);
        order.setOrderDate(new Date());

        this.orderServices.saveOrder(order);

        return totalAmount;
    }
}