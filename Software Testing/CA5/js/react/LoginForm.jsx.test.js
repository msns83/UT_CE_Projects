import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { LoginForm } from "./LoginForm";

describe("LoginForm", () => {
  test("renders form fields", () => {
    render(<LoginForm />);
    expect(screen.getByLabelText("Email")).toBeInTheDocument();
    expect(screen.getByLabelText("Password")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Log in" })).toBeInTheDocument();
  });

  test("user can type into the form", async () => {
    const user = userEvent.setup();
    render(<LoginForm />);

    await user.type(screen.getByLabelText("Email"), "user@example.com");
    await user.type(screen.getByLabelText("Password"), "1234");

    expect(screen.getByLabelText("Email")).toHaveValue("user@example.com");
    expect(screen.getByLabelText("Password")).toHaveValue("1234");
  });

  test("mocks fetch; called once with correct params; shows modal on 200 OK", async () => {
    global.fetch = jest.fn();
    const fetchSpy = jest.spyOn(global, "fetch").mockResolvedValue({ ok: true, status: 200 });

    const user = userEvent.setup();
    render(<LoginForm endpoint="/api/login" />);

    await user.type(screen.getByLabelText("Email"), "user@example.com");
    await user.type(screen.getByLabelText("Password"), "1234");
    await user.click(screen.getByRole("button", { name: "Log in" }));

    expect(fetchSpy).toHaveBeenCalledTimes(1);
    expect(fetchSpy).toHaveBeenCalledWith("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "user@example.com", password: "1234" })
    });

    await waitFor(() => {
      expect(screen.getByRole("dialog")).toHaveTextContent("Login successful");
    });

    fetchSpy.mockRestore();
  });
});