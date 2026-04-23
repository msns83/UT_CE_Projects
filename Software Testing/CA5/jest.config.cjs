module.exports = {
  testEnvironment: "jsdom",
  testMatch: ["**/*.js.test.js", "**/*.jsx.test.js"],
  setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
  transform: {
    "^.+\\.[jt]sx?$": "babel-jest"
  }
};