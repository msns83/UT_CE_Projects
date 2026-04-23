package com.example.demo.features.mealplan;

import com.example.demo.features.user.service.MealPlanService;
import com.example.demo.features.user.service.CalorieEstimator;
import com.example.demo.features.user.service.PantryInventory;
import com.example.demo.features.user.service.MealPlan;
import com.example.demo.features.product.service.ProductServices;
import com.example.demo.features.product.model.Product;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.time.DayOfWeek;
import java.util.List;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.lenient;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class MealPlanServiceTest {

    @Mock ProductServices productServices;
    @Mock CalorieEstimator calorieEstimator;
    @Mock PantryInventory pantryInventory;

    MealPlanService mealPlanService;

    private Product product(int id, String name) {
        Product p = new Product();
        p.setPid(id);
        p.setPname(name);
        return p;
    }

    @BeforeEach
    void setup() {
        mealPlanService = new MealPlanService(productServices, calorieEstimator, pantryInventory);
    }

    @Test
    @DisplayName("Creates a valid weekly MealPlan when products and pantry are sufficient")
    void creates_valid_weekly_mealplan() {
        double dailyTarget = 2000;
        int mealsPerDay = 2;

        List<Product> products = List.of(
                product(1, "Chicken"),
                product(2, "Rice"),
                product(3, "Salad"),
                product(4, "Yogurt")
        );
        given(productServices.getAllProducts()).willReturn(products);

        given(calorieEstimator.estimateCalories(products.get(0))).willReturn(980.0);
        given(calorieEstimator.estimateCalories(products.get(1))).willReturn(1020.0);
        given(calorieEstimator.estimateCalories(products.get(2))).willReturn(250.0);
        given(calorieEstimator.estimateCalories(products.get(3))).willReturn(180.0);

        products.forEach(p -> lenient().when(pantryInventory.hasIngredients(p)).thenReturn(true));

        MealPlan plan = mealPlanService.generateWeeklyPlan(dailyTarget, mealsPerDay);

        Assertions.assertNotNull(plan);
        Assertions.assertEquals(7, plan.asMap().size());
        plan.asMap().forEach((day, entries) ->
                Assertions.assertEquals(mealsPerDay, entries.size()));
        for (DayOfWeek d : DayOfWeek.values()) {
            Assertions.assertTrue(plan.asMap().containsKey(d));
        }
    }

    @Test
    @DisplayName("Throws when there are no products available in the system")
    void fails_when_no_products_in_system() {
        given(productServices.getAllProducts()).willReturn(List.of());
        Assertions.assertThrows(IllegalStateException.class,
                () -> mealPlanService.generateWeeklyPlan(1800, 3));
    }

    @Test
    @DisplayName("Throws when pantry inventory is insufficient to fulfill meals")
    void fails_when_pantry_insufficient() {
        List<Product> products = List.of(
                product(10, "Oats"),
                product(11, "Milk")
        );
        given(productServices.getAllProducts()).willReturn(products);
        given(calorieEstimator.estimateCalories(products.get(0))).willReturn(300.0);
        given(calorieEstimator.estimateCalories(products.get(1))).willReturn(120.0);
        products.forEach(p -> lenient().when(pantryInventory.hasIngredients(p)).thenReturn(false));

        Assertions.assertThrows(IllegalStateException.class,
                () -> mealPlanService.generateWeeklyPlan(1500, 2));
    }
}