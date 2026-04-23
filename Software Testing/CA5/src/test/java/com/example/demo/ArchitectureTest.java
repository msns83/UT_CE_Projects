package com.example.demo;

import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.fields;
import static com.tngtech.archunit.library.Architectures.layeredArchitecture;

@AnalyzeClasses(packages = "com.example.demo")
public class ArchitectureTest {

    @ArchTest
    static final ArchRule layered_architecture_rule = layeredArchitecture()
        .consideringAllDependencies()
        .layer("Controller").definedBy("..controller..")
        .layer("Service").definedBy("..service..")
        .layer("Repository").definedBy("..repository..")

        .whereLayer("Controller").mayNotBeAccessedByAnyLayer()
        .whereLayer("Service").mayOnlyBeAccessedByLayers("Controller")
        .whereLayer("Repository").mayOnlyBeAccessedByLayers("Service");

    @ArchTest
    static ArchRule repositories_must_be_named_correctly = classes()
            .that().resideInAPackage("..repository..")
            .should().haveSimpleNameEndingWith("Repository");

    @ArchTest
    static ArchRule controllers_must_be_in_controller_package = classes()
            .that().areAnnotatedWith(org.springframework.stereotype.Controller.class)
            .or().areAnnotatedWith(org.springframework.web.bind.annotation.RestController.class)
            .should().resideInAPackage("..controller..");

    @ArchTest
    static ArchRule no_field_injection_in_services = fields()
            .that().areDeclaredInClassesThat()
            .resideInAPackage("..service..")
            .should().notBeAnnotatedWith(org.springframework.beans.factory.annotation.Autowired.class);
}