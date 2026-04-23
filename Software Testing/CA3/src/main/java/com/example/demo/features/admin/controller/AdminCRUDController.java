package com.example.demo.features.admin.controller;

import com.example.demo.features.admin.model.Admin;
import com.example.demo.features.admin.service.AdminServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/admins") // Clear, dedicated URL path
public class AdminCRUDController {
    @Autowired private AdminServices adminServices;

    @GetMapping("/add")
    public String addAdminPage() { return "Add_Admin"; }

    @PostMapping("/add")
    public String addAdmin(@ModelAttribute Admin admin) {
        this.adminServices.addAdmin(admin);
        return "redirect:/admin/services";
    }

    @GetMapping("/update/{adminId}")
    public String updatePage(@PathVariable("adminId") int id, Model model) {
        return "Update_Admin";
    }

    @GetMapping("/updating/{id}")
    public String updateAdmin(@ModelAttribute Admin admin, @PathVariable("id") int id) {
        this.adminServices.updateAdmin(admin, id);
        return "redirect:/admin/services";
    }

    // Original: /deleteAdmin/{id}
    @GetMapping("/delete/{id}")
    public String deleteAdmin(@PathVariable("id") int id) {
        this.adminServices.deleteAdmin(id);
        return "redirect:/admin/services";
    }
}