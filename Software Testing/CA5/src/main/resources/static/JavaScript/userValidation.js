function validateUserInfo({ email, username, password } = {}) {
  const errors = {};

  if (!email) errors.email = "Email is required";
  else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) errors.email = "Email is invalid";

  if (!username) errors.username = "Username is required";

  if (!password) errors.password = "Password is required";
  else if (password.length < 4) errors.password = "Password must be at least 4 characters";

  return { isValid: Object.keys(errors).length === 0, errors };
}

module.exports = { validateUserInfo };

if (typeof window !== "undefined") {
  window.validateUserInfo = validateUserInfo;
}