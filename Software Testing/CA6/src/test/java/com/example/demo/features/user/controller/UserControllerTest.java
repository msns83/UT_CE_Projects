package com.example.demo.features.user.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.demo.features.user.model.User;
import com.example.demo.features.user.service.UserServices;

@WebMvcTest(UserController.class)
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserServices userServices;

    @Test
    @WithMockUser
    public void testAddUser() throws Exception {
        mockMvc.perform(post("/addingUser")
                        .with(csrf())
                        .flashAttr("user", new User()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/services"));
    }

    @Test
    @WithMockUser
    public void testUpdateUser() throws Exception {
        mockMvc.perform(get("/updatingUser/{id}", 1)
                        .flashAttr("user", new User()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/services"));
    }

    @Test
    @WithMockUser
    public void testDeleteUser() throws Exception {
        mockMvc.perform(get("/deleteUser/{id}", 1))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/services"));
    }
}