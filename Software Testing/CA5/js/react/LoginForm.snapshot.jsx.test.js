import React from "react";
import renderer from "react-test-renderer";
import { LoginForm } from "./LoginForm";

test("LoginForm snapshot", () => {
  const tree = renderer.create(<LoginForm />).toJSON();
  expect(tree).toMatchSnapshot();
});