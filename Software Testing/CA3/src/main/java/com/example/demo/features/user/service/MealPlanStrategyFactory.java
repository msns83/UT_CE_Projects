package com.example.demo.features.user.service;

import org.springframework.stereotype.Component;

import com.example.demo.features.product.service.ProductServices;

@Component
public class MealPlanStrategyFactory {

    private final ProductServices productServices;
    private final CalorieEstimator calorieEstimator;
    private final PantryInventory pantryInventory;

    public MealPlanStrategyFactory(ProductServices productServices,
            CalorieEstimator calorieEstimator,
            PantryInventory pantryInventory) {
        this.productServices = productServices;
        this.calorieEstimator = calorieEstimator;
        this.pantryInventory = pantryInventory;
    }

    public MealPlanStrategy getStrategy(MealPlanType type) {
        if (type == null) {
            type = MealPlanType.BALANCED;
        }

        switch (type) {
            case HIGH_PROTEIN:
                return new HighProteinMealPlanStrategy(productServices, calorieEstimator, pantryInventory);
            case BUDGET_FRIENDLY:
                return new BudgetFriendlyMealPlanStrategy(productServices, calorieEstimator, pantryInventory);
            case BALANCED:
            default:
                return new BalancedMealPlanStrategy(productServices, calorieEstimator, pantryInventory);
        }
    }
}
