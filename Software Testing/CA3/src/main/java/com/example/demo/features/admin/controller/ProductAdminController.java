package com.example.demo.features.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.example.demo.features.product.model.Product;
import com.example.demo.features.product.service.ProductServices;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/products")
public class ProductAdminController {

    @Autowired
    private ProductServices productServices;

    @GetMapping("/add")
    public String addProductPage() { return "Add_Product"; }

    @GetMapping("/update/{productId}")
    public String updateProductPage(@PathVariable("productId") int id, Model model) {
        Product product = this.productServices.getProduct(id);
        model.addAttribute("product", product);
        return "Update_Product";
    }
}