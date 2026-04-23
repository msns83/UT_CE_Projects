package com.example.demo.features.site.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;

@Controller
public class RegisterController {

    @Autowired
    private UserServices userServices;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("userRegistration", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("userRegistration") User user) {
        userServices.addUser(user);
        return "redirect:/login";
    }
}
