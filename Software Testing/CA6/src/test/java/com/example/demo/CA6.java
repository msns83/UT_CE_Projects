package com.example.demo;

import java.util.regex.Pattern;
import java.util.concurrent.TimeUnit;
import org.junit.*;
import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import org.openqa.selenium.*;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;

public class CA6 {
  private WebDriver driver;
  private String baseUrl;
  private boolean acceptNextAlert = true;
  private StringBuffer verificationErrors = new StringBuffer();

  @Before
  public void setUp() throws Exception {
    driver = new FirefoxDriver();
    baseUrl = "https://www.google.com/";
    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS);
  }

  @Test
  public void testCA6() throws Exception {
    driver.get("http://localhost:8080/home");
    driver.get("http://localhost:8080/home");
    driver.findElement(By.linkText("Log In")).click();
    driver.findElement(By.linkText("Register Here")).click();
    driver.findElement(By.id("uemail")).click();
    driver.findElement(By.id("uemail")).clear();
    driver.findElement(By.id("uemail")).sendKeys("test@test.com");
    driver.findElement(By.id("uname")).click();
    driver.findElement(By.id("uname")).clear();
    driver.findElement(By.id("uname")).sendKeys("testuser");
    driver.findElement(By.id("unumber")).click();
    driver.findElement(By.id("unumber")).clear();
    driver.findElement(By.id("unumber")).sendKeys("1234");
    driver.findElement(By.id("upassword")).click();
    driver.findElement(By.id("upassword")).clear();
    driver.findElement(By.id("upassword")).sendKeys("1234");
    driver.findElement(By.xpath("//button[@type='submit']")).click();
    driver.findElement(By.linkText("Products")).click();
    driver.findElement(By.linkText("Log In")).click();
    driver.findElement(By.name("userEmail")).click();
    driver.findElement(By.name("userEmail")).clear();
    driver.findElement(By.name("userEmail")).sendKeys("test@test.com");
    driver.findElement(By.name("userPassword")).click();
    driver.findElement(By.name("userPassword")).clear();
    driver.findElement(By.name("userPassword")).sendKeys("1234");
    driver.findElement(By.xpath("(.//*[normalize-space(text()) and normalize-space(.)='Password:'])[2]/following::button[1]")).click();
    driver.findElement(By.name("productName")).click();
    driver.findElement(By.name("productName")).click();
    driver.findElement(By.name("productName")).clear();
    driver.findElement(By.name("productName")).sendKeys("Chicken Biryani");
    driver.findElement(By.xpath("//button[@type='submit']")).click();
    driver.findElement(By.name("oQuantity")).click();
    driver.findElement(By.name("oQuantity")).clear();
    driver.findElement(By.name("oQuantity")).sendKeys("3");
    driver.findElement(By.xpath("(.//*[normalize-space(text()) and normalize-space(.)='SEARCH'])[1]/following::button[1]")).click();
    driver.findElement(By.linkText("Back")).click();
    driver.findElement(By.name("productName")).click();
    driver.findElement(By.name("productName")).clear();
    driver.findElement(By.name("productName")).sendKeys("Afgani Chicken");
    driver.findElement(By.xpath("//button[@type='submit']")).click();
    driver.findElement(By.name("oQuantity")).click();
    driver.findElement(By.name("oQuantity")).clear();
    driver.findElement(By.name("oQuantity")).sendKeys("4");
    driver.findElement(By.xpath("(.//*[normalize-space(text()) and normalize-space(.)='SEARCH'])[1]/following::button[1]")).click();
    driver.findElement(By.linkText("Back")).click();
    driver.findElement(By.linkText("Back")).click();
    driver.findElement(By.linkText("Home")).click();
  }

  @After
  public void tearDown() throws Exception {
    driver.quit();
    String verificationErrorString = verificationErrors.toString();
    if (!"".equals(verificationErrorString)) {
      fail(verificationErrorString);
    }
  }

  private boolean isElementPresent(By by) {
    try {
      driver.findElement(by);
      return true;
    } catch (NoSuchElementException e) {
      return false;
    }
  }

  private boolean isAlertPresent() {
    try {
      driver.switchTo().alert();
      return true;
    } catch (NoAlertPresentException e) {
      return false;
    }
  }

  private String closeAlertAndGetItsText() {
    try {
      Alert alert = driver.switchTo().alert();
      String alertText = alert.getText();
      if (acceptNextAlert) {
        alert.accept();
      } else {
        alert.dismiss();
      }
      return alertText;
    } finally {
      acceptNextAlert = true;
    }
  }
}
