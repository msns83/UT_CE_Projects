const { validateUserInfo } = require("../../main/resources/static/JavaScript/userValidation");

describe("validateUserInfo", () => {
  test("valid input => isValid true", () => {
    const result = validateUserInfo({
      email: "test@example.com",
      username: "ali",
      password: "1234",
    });

    expect(result.isValid).toBe(true);
    expect(result.errors).toEqual({});
  });

  test("invalid email => isValid false", () => {
    const result = validateUserInfo({
      email: "not-an-email",
      username: "ali",
      password: "1234",
    });

    expect(result.isValid).toBe(false);
    expect(result.errors.email).toBe("Email is invalid");
  });

  test("empty input => required errors", () => {
    const result = validateUserInfo({});

    expect(result.isValid).toBe(false);
    expect(result.errors).toEqual({
      email: "Email is required",
      username: "Username is required",
      password: "Password is required",
    });
  });
});