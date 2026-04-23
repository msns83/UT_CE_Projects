import React, { useState } from "react";

export function LoginForm({ endpoint = "/api/login" }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showModal, setShowModal] = useState(false);

  async function onSubmit(e) {
    e.preventDefault();

    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password })
    });

    if (res.ok) setShowModal(true);
  }

  return (
    <div>
      <form onSubmit={onSubmit} aria-label="login-form">
        <label htmlFor="email">Email</label>
        <input
          id="email"
          name="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <label htmlFor="password">Password</label>
        <input
          id="password"
          name="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />

        <button type="submit">Log in</button>
      </form>

      {showModal && <div role="dialog">Login successful</div>}
    </div>
  );
}