package com.example.demo.features.admin.controller;

import com.example.demo.features.admin.model.Admin;
import com.example.demo.features.admin.service.AdminServices;
import com.example.demo.features.order.model.Orders;
import com.example.demo.features.order.service.OrderServices;
import com.example.demo.features.product.model.Product;
import com.example.demo.features.product.service.ProductServices;
import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;


@Controller
@RequestMapping("/admin")
public class DashboardController {

    @Autowired private UserServices userServices;
    @Autowired private AdminServices adminServices;
    @Autowired private ProductServices productServices;
    @Autowired private OrderServices orderServices;

    // Original: /admin/services
    @GetMapping("/services")
    public String adminDashboard(Model model) {
        List<User> users = this.userServices.getAllUser();
        List<Admin> admins = this.adminServices.getAllAdmin();
        List<Product> products = this.productServices.getAllProducts();
        List<Orders> orders = this.orderServices.getOrders();

        model.addAttribute("users", users);
        model.addAttribute("admins", admins);
        model.addAttribute("products", products);
        model.addAttribute("orders", orders);

        return "Admin_Page";
    }
}