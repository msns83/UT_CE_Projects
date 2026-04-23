package com.example.demo.features.site.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.features.admin.dto.AdminLogin;
import com.example.demo.features.product.model.Product;
import com.example.demo.features.product.service.ProductServices;
import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;

@Controller
public class HomeController {

    @Autowired
    private ProductServices productServices;

    @Autowired
    private UserServices userServices;

    @GetMapping(value = {"/home", "/"})
    public String home() {
        return "Home";
    }

    @GetMapping("/products")
    public String products(Model model) {
        List<Product> allProducts = this.productServices.getAllProducts();
        model.addAttribute("products", allProducts);
        return "Products";
    }

    @GetMapping("/location")
    public String location() {
        return "Locate_us";
    }

    @GetMapping("/about")
    public String about() {
        return "About";
    }

    @GetMapping({"/login", "/loging"})
    public String login(Model model) {
        model.addAttribute("adminLogin", new AdminLogin());
        return "Login";
    }

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("userRegistration", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerSubmit(@ModelAttribute("userRegistration") User user, Model model) {
        if (user == null || user.getUemail() == null || user.getUemail().isBlank()
                || user.getUname() == null || user.getUname().isBlank()
                || user.getUpassword() == null || user.getUpassword().isBlank()
                || user.getUnumber() == null) {
            model.addAttribute("error", "All fields are required.");
            return "register";
        }

        if (user.getUpassword().length() < 4) {
            model.addAttribute("error", "Password must be at least 4 characters.");
            return "register";
        }

        User existing = this.userServices.getUserByEmail(user.getUemail());
        if (existing != null) {
            model.addAttribute("error", "Email is already registered.");
            return "register";
        }

        this.userServices.addUser(user);
        return "redirect:/login";
    }
}
