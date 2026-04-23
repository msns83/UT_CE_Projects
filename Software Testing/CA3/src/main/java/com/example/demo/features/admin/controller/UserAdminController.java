package com.example.demo.features.admin.controller;

import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/users")
public class UserAdminController {

    @Autowired
    private UserServices userServices; // Only injects UserServices

    // Original: /addUser
    @GetMapping("/add")
    public String addUserPage() {
        return "Add_User";
    }

    // Original: /updateUser/{userId}
    @GetMapping("/update/{userId}")
    public String updateUserPage(@PathVariable("userId") int id, Model model) {
        User user = this.userServices.getUser(id);
        model.addAttribute("user", user);
        return "Update_User";
    }
}