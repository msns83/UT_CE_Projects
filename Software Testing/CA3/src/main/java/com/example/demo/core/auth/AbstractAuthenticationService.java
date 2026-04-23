package com.example.demo.core.auth;

import java.util.Objects;

public abstract class AbstractAuthenticationService<T> {

    public final boolean authenticate(String email, String rawPassword) {
        if (!validateInput(email, rawPassword)) {
            return false;
        }

        T account = findByEmail(email);
        if (account == null) {
            return false;
        }

        String storedPassword = extractPassword(account);
        return passwordsMatch(rawPassword, storedPassword);
    }

    protected boolean validateInput(String email, String rawPassword) {
        return email != null && !email.isBlank()
                && rawPassword != null && !rawPassword.isBlank();
    }

    protected abstract T findByEmail(String email);

    protected abstract String extractPassword(T account);

    protected boolean passwordsMatch(String rawPassword, String storedPassword) {
        return Objects.equals(rawPassword, storedPassword);
    }
}
