package com.example.demo.features.user.service;

public interface MealPlanStrategy {

    MealPlan generateWeeklyPlan(double dailyCalorieTarget, int mealsPerDay);
}
