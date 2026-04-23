package com.example.demo.features.admin.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.example.demo.core.auth.AbstractAuthenticationService;
import com.example.demo.features.admin.model.Admin;
import com.example.demo.features.admin.repository.AdminRepository;

@Component
public class AdminServices extends AbstractAuthenticationService<Admin> {

    @Autowired
    private AdminRepository adminRepository;

    public List<Admin> getAllAdmin() {
        return (List<Admin>) this.adminRepository.findAll();
    }

    public Admin getAdmin(int id) {
        Optional<Admin> optional = this.adminRepository.findById(id);
        return optional.orElse(null);
    }

    public void updateAdmin(Admin admin, int id) {
        admin.setAdminId(id);
        this.adminRepository.save(admin);
    }

    public void deleteAdmin(int id) {
        this.adminRepository.deleteById(id);
    }

    public void addAdmin(Admin admin) {
        this.adminRepository.save(admin);
    }


    public boolean validateLoginCredentials(String email, String password) {
        return authenticate(email, password);
    }

    @Override
    protected Admin findByEmail(String email) {
        return adminRepository.findByAdminEmail(email);
    }

    @Override
    protected String extractPassword(Admin admin) {
        return admin != null ? admin.getAdminPassword() : null;
    }
}
