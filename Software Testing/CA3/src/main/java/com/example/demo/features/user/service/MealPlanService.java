package com.example.demo.features.user.service;

import org.springframework.stereotype.Component;

@Component
public class MealPlanService {

    private final MealPlanStrategyFactory strategyFactory;

    public MealPlanService(MealPlanStrategyFactory strategyFactory) {
        this.strategyFactory = strategyFactory;
    }

    public MealPlan generateWeeklyPlan(double dailyCalorieTarget, int mealsPerDay) {
        return generateWeeklyPlan(dailyCalorieTarget, mealsPerDay, MealPlanType.BALANCED);
    }

    public MealPlan generateWeeklyPlan(double dailyCalorieTarget,
            int mealsPerDay,
            MealPlanType type) {
        MealPlanStrategy strategy = strategyFactory.getStrategy(type);
        return strategy.generateWeeklyPlan(dailyCalorieTarget, mealsPerDay);
    }
}
