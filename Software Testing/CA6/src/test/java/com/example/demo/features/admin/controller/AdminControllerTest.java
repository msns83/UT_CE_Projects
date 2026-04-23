package com.example.demo.features.admin.controller;

import java.util.ArrayList;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import com.example.demo.features.admin.model.Admin;
import com.example.demo.features.admin.service.AdminServices;
import com.example.demo.features.order.service.OrderServices;
import com.example.demo.features.product.service.ProductServices;
import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;

@WebMvcTest(AdminController.class)
public class AdminControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AdminServices adminServices;

    @MockBean
    private UserServices userServices;

    @MockBean
    private ProductServices productServices;

    @MockBean
    private OrderServices orderServices;

    @Test
    @WithMockUser
    public void testAdminLoginSuccess() throws Exception {
        given(adminServices.validateAdminCredentials(anyString(), anyString())).willReturn(true);

        mockMvc.perform(post("/adminLogin")
                .with(csrf())
                .param("email", "admin@test.com")
                .param("password", "password"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/services"));
    }

    @Test
    @WithMockUser
    public void testAdminLoginFailure() throws Exception {
        given(adminServices.validateAdminCredentials(anyString(), anyString())).willReturn(false);

        mockMvc.perform(post("/adminLogin")
                .with(csrf())
                .param("email", "wrong@test.com")
                .param("password", "wrong"))
                .andExpect(status().isOk())
                .andExpect(view().name("Login"))
                .andExpect(model().attributeExists("error"));
    }

    @Test
    @WithMockUser
    public void testUserLoginSuccess() throws Exception {
        User mockUser = new User();
        mockUser.setUname("Test User");
        given(userServices.validateLoginCredentials(anyString(), anyString())).willReturn(true);
        given(userServices.getUserByEmail(anyString())).willReturn(mockUser);
        given(orderServices.getOrdersForUser(any(User.class))).willReturn(new ArrayList<>());

        mockMvc.perform(post("/userLogin")
                .with(csrf())
                .param("userEmail", "user@test.com")
                .param("userPassword", "password"))
                .andExpect(status().isOk())
                .andExpect(view().name("BuyProduct"))
                .andExpect(model().attributeExists("orders"));
    }

    @Test
    @WithMockUser
    public void testAddAdmin() throws Exception {
        mockMvc.perform(post("/addingAdmin")
                .with(csrf())
                .flashAttr("admin", new Admin()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/services"));
    }
}
