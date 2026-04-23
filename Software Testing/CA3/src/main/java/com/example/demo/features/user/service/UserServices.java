package com.example.demo.features.user.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.example.demo.core.auth.AbstractAuthenticationService;
import com.example.demo.features.user.model.User;
import com.example.demo.features.user.repository.UserRepository;

@Component
public class UserServices extends AbstractAuthenticationService<User> {

    @Autowired
    private UserRepository userRepository;

    public List<User> getAllUser() {
        return (List<User>) this.userRepository.findAll();
    }

    public User getUser(int id) {
        Optional<User> optional = this.userRepository.findById(id);
        return optional.orElse(null);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findUserByUemail(email);
    }

    public void updateUser(User user, int id) {
        user.setU_id(id);
        this.userRepository.save(user);
    }

    public void deleteUser(int id) {
        this.userRepository.deleteById(id);
    }

    public void addUser(User user) {
        this.userRepository.save(user);
    }

    public boolean validateLoginCredentials(String email, String password) {
        return authenticate(email, password);
    }

    @Override
    protected User findByEmail(String email) {
        return userRepository.findUserByUemail(email);
    }

    @Override
    protected String extractPassword(User user) {
        return user != null ? user.getUpassword() : null;
    }
}
