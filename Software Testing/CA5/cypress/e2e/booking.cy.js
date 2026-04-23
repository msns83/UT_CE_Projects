describe("FoodFrenzy E2E booking flow", () => {
  it("home -> login -> order", () => {
    cy.visit("/");

    cy.contains("Log In").click();
    cy.url().should("include", "/login");

    cy.get("form.form").within(() => {
      cy.get('input[name="userEmail"]').type("user@example.com");
      cy.get('input[name="userPassword"]').type("1234");
      cy.contains("button", "Log in").click();
    });

    cy.contains("Product Search").should("be.visible");

    cy.get('input[name="productName"]').type("Chicken Biryani");
    cy.contains("button", "SEARCH").click();

    cy.get('input[name="oQuantity"]').type("1");
    cy.contains("button", "Order_Now").click();

    cy.contains("Ordered SuccessFully").should("be.visible");
  });
});