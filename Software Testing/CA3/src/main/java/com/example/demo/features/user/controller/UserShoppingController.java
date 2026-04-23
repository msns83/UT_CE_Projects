package com.example.demo.features.user.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.features.order.model.Orders;
import com.example.demo.features.order.service.OrderLogicService;
import com.example.demo.features.order.service.OrderServices;
import com.example.demo.features.product.model.Product;
import com.example.demo.features.product.service.ProductServices;
import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;

@Controller
public class UserShoppingController {

    @Autowired private ProductServices productServices;
    @Autowired private OrderServices orderServices;
    @Autowired private OrderLogicService orderLogicService;
    @Autowired private UserServices userServices;

    @GetMapping("/user/dashboard")
    public String userDashboard(Model model, User user) {
        User currentUser = this.userServices.getUserByEmail(user.getUemail());

        List<Orders> orders = this.orderServices.getOrdersForUser(currentUser);
        model.addAttribute("orders", orders);
        model.addAttribute("name", currentUser.getUname());
        return "BuyProduct";
    }


    @PostMapping("/product/search")
    public String searchHandler(@RequestParam("productName") String name, Model model, User user) {
        User currentUser = this.userServices.getUserByEmail(user.getUemail());

        Product product = this.productServices.getProductByName(name);
        List<Orders> orders = this.orderServices.getOrdersForUser(currentUser);

        if (product == null) {
            model.addAttribute("message", "SORRY...! Product Unavailable");
        }

        model.addAttribute("orders", orders);
        model.addAttribute("product", product);
        return "BuyProduct";
    }

    @PostMapping("/product/order")
    public String orderHandler(@ModelAttribute Orders order, Model model, User user) {
        User currentUser = this.userServices.getUserByEmail(user.getUemail());

        double totalAmount = this.orderLogicService.processNewOrder(order, currentUser);

        model.addAttribute("amount", totalAmount);
        return "Order_success";
    }

    @GetMapping("/product/back")
    public String back(Model model, User user) {
        User currentUser = this.userServices.getUserByEmail(user.getUemail());

        List<Orders> orders = this.orderServices.getOrdersForUser(currentUser);
        model.addAttribute("orders", orders);
        return "BuyProduct";
    }
}